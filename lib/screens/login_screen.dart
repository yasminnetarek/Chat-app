import 'package:flutter/material.dart';

import '../shared/widgets/my_button/my_button.dart';
import '../shared/widgets/my_form_field/my_form_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Column(
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'chat with friends easily',
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 18.0,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20.0,
                ),
                Card(
                  child: Form(
                    key: _formKey,
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
                          validator:  (value){
                            RegExp regex =RegExp( "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+\$");
                            if(!regex.hasMatch(value!)){
                              return "Invalid Email";
                            }
                            if(value.isEmpty){
                              return "Email can not be empty";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        MyFormField(
                          controller: _passwordController,
                          prefixIcon: const Icon(
                              Icons.person_4_outlined
                          ),
                          text: "Password",
                          validator:  (value){
                            if(value!.length < 6 ){
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
                ),
                const SizedBox(
                  height: 20.0,
                ),
                MyButton(
                  text: "Login",
                  onTap: (){

                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
