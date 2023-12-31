// ignore_for_file: avoid_print
import 'package:flutter/material.dart';
import 'package:my_app/models/AppColors.dart';
import 'package:my_app/models/background_wave.dart';
import 'package:my_app/models/input_field.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'main_page.dart';

//TODO: please add the error messages to the user when they they try to signup ie. the 'passwordErrorMessage'
//TODO: please add the email error message so users can see it. 
bool isPasswordValid(String password) {
  if (password.length < 8) {
    return false;
  }
  RegExp specialCharRegex = RegExp(r'[!@#%^&*(),.?:{}|<>]');
  if (!specialCharRegex.hasMatch(password)) {
    return false;
  }
  return true;
}

// ignore: must_be_immutable
class SignUpPage extends StatelessWidget {
  final BuildContext context; // Add this line
  SignUpPage({required this.context, Key? key}) : super(key: key);
  //initiating database connection
  final FirebaseAuth _auth = FirebaseAuth.instance; // for user
  // text editing controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final rptPasswordController = TextEditingController();
  String passwordErrorMessage = "";
  String emailErrorMessage =''; 

  void signUpUser() async {
    String email = emailController.text.trim(); 
    String password = passwordController.text.trim();
    try {
      List<String> signInMethods = await _auth.fetchSignInMethodsForEmail(email);
      if (signInMethods.isNotEmpty) {
        // Email has been used before, show an error message
        print('Email has already been used before');
        emailErrorMessage = "Email has already been used before"; 
        return;
      }
      if (passwordController.text != rptPasswordController.text) {
        // Passwords don't match, show an error message
        passwordErrorMessage = "Passwords should match";
        return;
      } else if (!isPasswordValid(password)) {
        passwordErrorMessage =
          "Password should have at least 8 characters and should have at least one special character (!@#%^&*(),.?:{}|<>])";
        return;
      }
      UserCredential userCredential =
        await _auth.createUserWithEmailAndPassword(
          email: emailController.text,
          password: passwordController.text,
        );
      // User has signed up successfully
      print('User signed up: ${userCredential.user!.uid}');
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()), // Replace YourNextPage with the actual page you want to navigate to
      );
    } on FirebaseAuthException catch (e) {
      // Handle errors
      print('Signup failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const BackgroundWave(height: 200),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 50,
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  controller: emailController,
                  headerText: "Email",
                  hintText: "example@email.com",
                  obscureText: false,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  controller: passwordController,
                  headerText: "Password",
                  hintText: "*************",
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: InputField(
                  controller: rptPasswordController,
                  headerText: "Repeat Password",
                  hintText: "*************",
                  obscureText: true,
                ),
              ),
              const SizedBox(
                height: 48,
              ),
              Container(
                height: 40,
                alignment: Alignment.center,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.accent),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.secondary.withOpacity(0.25),
                      blurRadius: 4,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: signUpUser,
                  child: Text(
                    "Sign Up",
                    style: TextStyle(
                      color: AppColors.accent,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Divider(
                  color: AppColors.secondary.withOpacity(0.6),
                  thickness: 1,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: Text(
                  "Already have an account?",
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.secondary.withOpacity(0.5),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Sign In",
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.accent,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
