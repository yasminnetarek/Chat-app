import 'package:flutter/material.dart';

class MyFormField extends StatefulWidget {

  final TextEditingController controller;
  final String?Function(String?) validator;
  final Icon prefixIcon;
  final bool isPassword;
  final String text;
  bool? isSecured;


  MyFormField({
    Key? key,
    required this.controller,
    required this.text,
    required this.validator,
    required this.prefixIcon,
    this.isPassword = false,
    this.isSecured = false,
  }) : super(key: key);

  @override
  State<MyFormField> createState() => _MyFormFieldState();
}

class _MyFormFieldState extends State<MyFormField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: widget.isSecured!,
      controller: widget.controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            width: 1.0,
            color: Colors.black,
          ),
        ),
        hintText: widget.text,
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.isPassword ? IconButton(
            onPressed: (){
              setState(() {
                widget.isSecured = !widget.isSecured!;
              });
            },
            icon: Icon(
              widget.isSecured! ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            ),
        ):null,
      ),
      validator:widget.validator,
    );
  }
}
