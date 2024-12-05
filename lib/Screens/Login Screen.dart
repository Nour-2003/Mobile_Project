import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileproject/Screens/Main%20Screen.dart';
import 'package:mobileproject/Screens/Register%20Screen.dart';

import '../Cubit/Login/Login Cubit.dart';
import '../Cubit/Login/Login States.dart';
import '../Shared/Constants.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var emailController = TextEditingController();
    var passwordController = TextEditingController();
    var FormKey = GlobalKey<FormState>();
    return BlocProvider(
      create: (BuildContext context) => Shoplogincubit(),
      child: BlocConsumer<Shoplogincubit, LoginStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              body: Center(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: FormKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'LOGIN',
                            style: GoogleFonts.montserrat(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Login now to browse our hot offers',
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                color: Colors.grey,
                              )),
                          SizedBox(
                            height: 20,
                          ),
                          defaultTextFormField(
                              textController: emailController,
                              prefixIcon: Icon(Icons.email_outlined),
                              label: 'Email',
                              type: TextInputType.emailAddress,
                              Validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Email must not be empty';
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          defaultTextFormField(
                              onSubmit: (value) {},
                              textController: passwordController,
                              prefixIcon: Icon(Icons.lock),
                              label: 'Password',
                              suffixIcon: IconButton(
                                onPressed: () {
                                  Shoplogincubit.get(context)
                                      .changePasswordVisibility();
                                },
                                icon:
                                    Shoplogincubit.get(context).passwordObscure
                                        ? Icon(Icons.visibility_off)
                                        : Icon(Icons.visibility),
                              ),
                              obscureText:
                                  Shoplogincubit.get(context).passwordObscure,
                              type: TextInputType.visiblePassword,
                              Validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Password is too short';
                                }
                                return null;
                              }),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                  onPressed: () async {
                                    if (emailController.text.isEmpty) {
                                      AwesomeDialog(
                                        context: context,
                                        dialogType: DialogType.error,
                                        animType: AnimType.rightSlide,
                                        title: 'Forget Password',
                                        desc:
                                            'Please enter your email to reset your password',
                                      )..show();
                                      return;
                                    }
                                      try {
                                      await FirebaseAuth.instance.sendPasswordResetEmail(
                                            email: emailController.text
                                        );
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.success,
                                          animType: AnimType.rightSlide,
                                          title: 'Forget Password',
                                          desc:
                                          'Check your email to reset your password',
                                        )..show();
                                      } catch (e) {
                                        AwesomeDialog(
                                          context: context,
                                          dialogType: DialogType.error,
                                          animType: AnimType.rightSlide,
                                          title: 'Forget Password',
                                          desc:
                                          'Please enter a valid email',
                                        )..show();
                                      }

                                  },
                                  child: Text(
                                    'Forget Password?',
                                    style: TextStyle(color: Color(0xFF00B96D)),
                                  )),
                            ],
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                                onPressed: () async {
                                  // if (FormKey.currentState!.validate()) {
                                  //   Shoplogincubit.get(context).userLogin(
                                  //       email: emailController.text,
                                  //       password: passwordController.text);
                                  // }
                                  if (FormKey.currentState!.validate()) {
                                    try {
                                      final credential = await FirebaseAuth
                                          .instance
                                          .signInWithEmailAndPassword(
                                              email: emailController.text,
                                              password:
                                                  passwordController.text);
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  MainScreen()));
                                    } on FirebaseAuthException catch (e) {
                                      if (e.code ==
                                          'The supplied auth credential is incorrect, malformed or has expired.') {
                                        print('No user found for that email.');
                                      } else if (e.code == 'wrong-password') {
                                        print(
                                            'Wrong password provided for that user.');
                                      }
                                    }
                                  }
                                },
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Color(0xFF00B96D)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                                  padding: MaterialStateProperty.all(
                                      EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 10)),
                                ),
                                child: Text(
                                  'LOGIN',
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.white),
                                )),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text('Don\'t have an account?'),
                              TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                RegisterScreen()));
                                  },
                                  child: Text(
                                    'REGISTER NOW',
                                    style: TextStyle(color: Color(0xFF00B96D)),
                                  ))
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }
}
