import 'dart:io';

import 'package:chat_application_it/screens/home_screen.dart';
import 'package:chat_application_it/shared/cubits/app_cubit/app_cubit.dart';
import 'package:chat_application_it/shared/widgets/my_button/my_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../shared/widgets/my_form_field/my_form_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        print(state);
        if(state is GetImageSuccefully){
          AppCubit.get(context).cropImage();
        }
        if(state is GetImageError){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
        if(state is RegisterSuccessfully){
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Registered Successfully")));
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_)=>HomeScreen()), (route) => false);
        }
        if(state is RegisterError){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Scaffold(
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          cubit.finalImage == null ? const CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              'https://www.refugee-action.org.uk/wp-content/uploads/2016/10/anonymous-user.png',
                            ),
                          ):CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(
                              File(
                                cubit.finalImage!.path,
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              cubit.getImage();
                            },
                            child: Container(
                              width: 25,
                              height: 25,
                              decoration: const BoxDecoration(
                                  color: Colors.blueAccent,
                                  shape: BoxShape.circle
                              ),
                              child:  Center(
                                child: Icon(
                                  cubit.finalImage == null ?Icons.add : Icons.edit,
                                  color: Colors.white,
                                  size: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Card(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 20.0,
                            ),
                            MyFormField(
                              controller: _emailController,
                              prefixIcon: const Icon(
                                  Icons.email_outlined
                              ),
                              text: "Email",
                              validator: (value) {
                                RegExp regex = RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$");
                                if (!regex.hasMatch(value!)) {
                                  return "Invalid Email";
                                }
                                if (value.isEmpty) {
                                  return "Email can not be empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            MyFormField(
                              controller: _nameController,
                              prefixIcon: const Icon(
                                  Icons.person_4_outlined
                              ),
                              text: "Username",
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return "Username can not be empty";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            MyFormField(
                              isPassword: true,
                              isSecured: true,
                              controller: _passwordController,
                              prefixIcon: const Icon(
                                  Icons.lock
                              ),
                              text: "Password",
                              validator: (value) {
                                if (value!.length < 6) {
                                  return "Password must be more than 6 characters";
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      state is RegisterLoading ? const Center(
                      child: CircularProgressIndicator(),
                      ):MyButton(
                        text: "Register",
                        onTap: () {
                            cubit.register(
                                email: _emailController.text,
                                password: _passwordController.text,
                                name: _nameController.text,
                            );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
