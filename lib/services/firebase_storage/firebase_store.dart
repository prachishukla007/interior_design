import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interior_design/navigator/navigator_services.dart';
import 'package:path_provider/path_provider.dart';


import 'package:path/path.dart';

import '../../core/utils/image_manager.dart';
import '../../routes/route_manager.dart';


class FirebaseStore {
  FirebaseStore._();

  static final FirebaseStore instance = FirebaseStore._();
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> saveImage(BuildContext context, XFile image) async {
    String? userId = _auth.currentUser?.uid;
    try {
      final storageRef = FirebaseStorage.instance.ref();
      final fileName = basename(image.path);
      // final imageRef = storageRef.child('${auth.currentUser?.uid}/my_collection/$fileName');
      final imageRef = storageRef.child('users_posts/$userId/my_collection/$fileName');

      await imageRef.putFile(File(image.path));

      final downloadUrl = await imageRef.getDownloadURL();

      final directory = await getApplicationDocumentsDirectory();
      final localImagePath = '${directory.path}/$fileName';
      final savedImage = await File(image.path).copy(localImagePath);

      ImageManager().addImage(downloadUrl);


      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image saved successfully!')),
      );
      appNavigator.pushNamedAndRemoveUntil(Routes.upload,predicate: (Route<dynamic> route) => true);

      // Navigator.popUntil(context, ModalRoute.withName(Routes.imagePreview));
      // appNavigator.popUntil(Routes.imagePreview);
      // Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save the image: $e')),
      );
    }
  }

  Future<void> createUserFolder(String userId) async {
    final FirebaseStorage _storage = FirebaseStorage.instance;

    String folderPath = 'users_posts/$userId/my_collection/';

    Reference ref = _storage.ref().child(folderPath).child('placeholder.txt');

    try {
      await ref.putString('');
    } catch (e) {
      print('Failed to create folder: $e');
      throw e;
    }
  }

}