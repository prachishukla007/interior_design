import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interior_design/auth/register/register.dart';
import 'package:interior_design/core/constants/color_constant.dart';
import 'package:interior_design/core/constants/icon_constant.dart';
import 'package:interior_design/navigator/navigator_services.dart';

import '../../custom_widgets/custom_text_field.dart';
import '../../routes/route_manager.dart';
import '../../screens/home/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _usernameController.text,
        password: _passwordController.text,
      );
      // Navigate to HomeScreen on successful login
      if (userCredential.user != null) {
        setState(() {
          isLoading = false;
        });
        appNavigator.pushReplacementNamed(Routes.home);
        // Navigator.pushReplacementNamed(
        //   context,
        //   Routes.home,
        // );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        isLoading = false;
      });
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      Fluttertoast.showToast(msg: message);
    }
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!value.contains('@') || !value.contains('.')) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters long';
    }
    return null;
  }

  void _hideKeyboard() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: _hideKeyboard,
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(IconConstant.bgImage5),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        IconConstant.appLogoIcon,
                        height: 280.0,
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _usernameController,
                        hintText: 'Username',
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: _obscureText,
                        validator: _validatePassword,
                        suffixIcon: InkWell(
                          onTap: _togglePasswordVisibility,
                          child: Icon(
                            _obscureText ? Icons.visibility : Icons.visibility_off,
                            color: const Color(0xffcec2c2),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      isLoading
                          ? const Center(
                        child: SizedBox(
                          height: 25,
                          width: 25,
                          child: CircularProgressIndicator(),
                        ),
                      )
                          : ElevatedButton(
                        onPressed: _login,
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(ColorConstant.primary), // Adjust opacity here
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.symmetric(
                                  vertical: 15.0, horizontal: 30.0)),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                              side: const BorderSide(color: Color(0xffffffff)),
                            ),
                          ),
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextButton(
                          onPressed: () {
                            appNavigator.pushNamed(Routes.register);

                            // Navigator.pushNamed(
                            //     context,
                            //     Routes.register);
                          },
                          child: const Text(
                            "Don't have an account?",
                            style: TextStyle(
                              fontSize: 15,
                              decoration: TextDecoration.underline,
                              decorationColor: Colors.white,
                              color: Color(0xffffffee),
                            ),
                          ))
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
