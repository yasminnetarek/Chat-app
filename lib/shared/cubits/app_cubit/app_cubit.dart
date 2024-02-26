import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meta/meta.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());

  static AppCubit get(context)=>BlocProvider.of(context);

  ImagePicker picker = ImagePicker();
  XFile? image;
  CroppedFile? finalImage;

  //Auth Variables
  var _auth = FirebaseAuth.instance;
  var _database = FirebaseFirestore.instance;
  var _storage = FirebaseStorage.instance;

  void getImage(){
    picker.pickImage(source: ImageSource.camera).then((value) {
      if(value == null){
        emit(GetImageError("Didn't capture image"));
      }
      else{
        image = value;
        emit(GetImageSuccefully());
      }
    }).catchError((error){
      emit(GetImageError(error.toString()));
    });
  }

  void cropImage() {
    ImageCropper().cropImage(
      sourcePath: image!.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9
      ],
      uiSettings: [
        AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        IOSUiSettings(
          title: 'Cropper',
        ),
      ],
    ).then((value){
      finalImage = value;
      emit(CroppedSuccessfully());
    }).catchError((error){
      emit(CroppedError(error.toString()));
    });
  }

  void register({
  required String email,
  required String password,
  required String name,
}){
    emit(RegisterLoading());
    if(finalImage == null){
      emit(RegisterError("Image Required"));
    }
    else{
      _auth.createUserWithEmailAndPassword
        (
        email: email,
        password: password,
      ).then((value){
        _storage.ref("userImage").
        child(finalImage!.path.split('/').last).
        putFile(
          File(
            finalImage!.path,
          ),
        ).then((image) {
          image.ref.getDownloadURL().then((imgUrl) {
            _database.
            collection("users").
            doc(value.user!.uid).set(
              {
                'userId':value.user!.uid,
                'email':email,
                'name':name,
                'image':imgUrl,
                'online':true,
              },
            ).then((value) {
              emit(RegisterSuccessfully());
            }).catchError((error){
              emit(RegisterError(error.toString()));
            });
          }).catchError((error){
            emit(RegisterError(error.toString()));
          });
        }).catchError((error){
          emit(RegisterError(error.toString()));
        });
      }).catchError((error){
        emit(RegisterError(error.toString()));
      });
    }

  }
}
