import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:interior_design/core/utils/validators.dart';
import 'package:interior_design/custom_widgets/custom_text_field.dart';
import 'package:interior_design/model/user_details_model.dart';
import 'package:interior_design/routes/route_manager.dart';
import 'package:interior_design/services/firebase_db/firestore_db.dart';

import '../../navigator/navigator_services.dart';
import '../../screens/home/home_screen.dart';


class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool _obscureText = true;

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    setState(() {
      isLoading = true;
    });
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      if (userCredential.user != null) {
        UserDetailsModel userDetails = UserDetailsModel(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            phone: _phoneController.text);
        await FirestoreDB.instance.addUsersData(userDetails: userDetails);
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
        case 'email-already-in-use':
          message = 'The email address is already in use by another account.';
          break;
        case 'weak-password':
          message = 'The password provided is too weak.';
          break;
        default:
          message = e.message ?? 'An error occurred';
      }
      Fluttertoast.showToast(msg: message);
    }
  }

  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
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
              image: AssetImage('assets/images/bg-image5.jpeg'),
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
                        'assets/images/logo3-main.jpeg',
                        height: 150.0,
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              controller: _firstNameController,
                              hintText: 'First Name',
                              validator: _validateFirstName,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Expanded(
                            child: CustomTextField(
                              controller: _lastNameController,
                              hintText: 'Last Name',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _emailController,
                        hintText: 'Email',
                        validator: Validator.validateEmail,
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _phoneController,
                        hintText: 'Phone Number',
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _passwordController,
                        hintText: 'Password',
                        obscureText: _obscureText,
                        validator: (value) {
                          Validator.validatePassword(value, _passwordController, _confirmPasswordController);
                          return null;
                        },
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      CustomTextField(
                        controller: _confirmPasswordController,
                        hintText: 'Confirm Password',
                        obscureText: _obscureText,
                        validator: (value) {
                          Validator.validatePassword(value, _passwordController, _confirmPasswordController);
                          return null;
                        },
                        suffixIcon: IconButton(
                          splashColor: Colors.transparent,
                          icon: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: _togglePasswordVisibility,
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
                              onPressed: _register,
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xffd25f5f).withOpacity(0.9)),
                                // Adjust opacity here
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 30.0)),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: const BorderSide(color: Colors.white),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                      const SizedBox(height: 10.0),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text(
                            "Already have an account? Login",
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
