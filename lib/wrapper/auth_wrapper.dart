import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:interior_design/auth/register/register.dart';

import '../auth/login/login_form.dart';
import '../model/item_model.dart';
import '../screens/home/home_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Display a loading indicator while waiting
        } else if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          // return const SignUpForm();
           return const LoginForm();
        }
      },
    );
  }
}