import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthentication {
  FirebaseAuthentication._();

  static final FirebaseAuthentication instance = FirebaseAuthentication._();
  static var auth = FirebaseAuth.instance;


}