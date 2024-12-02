import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:mobileproject/Screens/Main%20Screen.dart';
import '../Cubit/Login/Login Cubit.dart';
import '../Cubit/Login/Login States.dart';
import '../Shared/Constants.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final confirmController = TextEditingController();
  final dateController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  DateTime? selectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: const Color(0xFF00B96D),
              onPrimary: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dateController.text = DateFormat('MMM dd, yyyy').format(picked);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Register',
                          style: GoogleFonts.montserrat(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Register now to browse our hot offers',
                          style: GoogleFonts.montserrat(
                            fontSize: 20,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(height: 20),
                        defaultTextFormField(
                          textController: nameController,
                          label: 'Name',
                          prefixIcon: Icon(Icons.person),
                          type: TextInputType.text,
                          Validator: (value) {
                            if (value!.isEmpty) {
                              return 'Name must not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
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
                          },
                        ),
                        const SizedBox(height: 15),
                        defaultTextFormField(
                          onSubmit: (value) {},
                          textController: passwordController,
                          prefixIcon: Icon(Icons.lock),
                          label: 'Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              Shoplogincubit.get(context)
                                  .changeSignupPasswordVisibility();
                            },
                            icon: Shoplogincubit.get(context).signupPasswordObscure
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          obscureText:
                          Shoplogincubit.get(context).signupPasswordObscure,
                          type: TextInputType.visiblePassword,
                          Validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        defaultTextFormField(
                          onSubmit: (value) {},
                          textController: confirmController,
                          prefixIcon: Icon(Icons.lock),
                          label: 'Confirm Password',
                          suffixIcon: IconButton(
                            onPressed: () {
                              Shoplogincubit.get(context)
                                  .changeSignupConfirmPasswordVisibility();
                            },
                            icon: Shoplogincubit.get(context)
                                .signupConfirmPasswordObscure
                                ? Icon(Icons.visibility_off)
                                : Icon(Icons.visibility),
                          ),
                          obscureText: Shoplogincubit.get(context)
                              .signupConfirmPasswordObscure,
                          type: TextInputType.visiblePassword,
                          Validator: (value) {
                            if (value!.isEmpty) {
                              return 'Password is too short';
                            } else if (passwordController.text != value) {
                              return 'Password is not matched';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        defaultTextFormField(
                          textController: phoneController,
                          label: 'Phone',
                          prefixIcon: Icon(Icons.phone),
                          type: TextInputType.number,
                          Validator: (value) {
                            if (value!.isEmpty) {
                              return 'Phone must not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        TextFormField(
                          controller: dateController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            prefixIcon: Icon(Icons.calendar_today),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 10,
                            ),
                          ),
                          onTap: () => _selectDate(context),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Date of birth must not be empty';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 15),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MainScreen(),
                                  ),
                                );
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Color(0xFF00B96D),
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 10,
                                ),
                              ),
                            ),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}