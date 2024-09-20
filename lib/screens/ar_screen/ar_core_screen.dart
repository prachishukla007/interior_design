import 'package:arcore_flutter_plugin/arcore_flutter_plugin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:interior_design/navigator/navigator_services.dart';
import 'dart:typed_data';
import 'package:vector_math/vector_math_64.dart' as vector;

import '../../routes/route_manager.dart';

class ArViewScreen extends StatefulWidget {
  final List<String> items;

  const ArViewScreen({super.key, required this.items});

  @override
  _ArViewScreenState createState() => _ArViewScreenState();
}

class _ArViewScreenState extends State<ArViewScreen> {
  ArCoreController? arCoreController;

  @override
  void dispose() {
    arCoreController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onPanUpdate: (details) {
          // Handle drag event if needed
        },
        child: ArCoreView(
          onArCoreViewCreated: _onArCoreViewCreated,
          enableTapRecognizer: true,
        ),
      ),
      floatingActionButton:  FloatingActionButton(
        onPressed: () async {
          String path = await arCoreController?.snapshot() ?? "";
          handleImageUpload(path);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Photo saved on $path"),));
          appNavigator.pushReplacementNamed(Routes.layouts);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.photo),
      ),
    );
  }

  void _onArCoreViewCreated(ArCoreController controller) {
    arCoreController = controller;
    arCoreController?.onPlaneTap = _handleOnPlaneTap;
  }

  void _handleOnPlaneTap(List<ArCoreHitTestResult> hits) async {
    final hit = hits.last;
    for (String itemUrl in widget.items) {
      await _addImageFromUrl(hit, itemUrl);
    }
  }

  Future<void> _addImageFromUrl(ArCoreHitTestResult hit, String url) async {
    try {
      // Load the image from the URL
      Uint8List imageBytes = await _loadImageFromUrl(url);

      // Create and add the image node to AR
      ArCoreNode imageNode = ArCoreNode(
        image: ArCoreImage(
          bytes: imageBytes,
          width: 200, // Specify your desired width
          height: 200, // Specify your desired height
        ),
        position: vector.Vector3(hit.pose.translation[0], hit.pose.translation[1], hit.pose.translation[2]),
      );

      arCoreController?.addArCoreNode(imageNode);
    } catch (e) {
      print('Error loading image from URL: $e');
    }
  }

  Future<Uint8List> _loadImageFromUrl(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception('Failed to load image from URL');
    }
  }

  Future<Uint8List> loadAsset(String assetPath) async {
    final ByteData data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List();
  }

  Future<String> uploadImageToFirebase(
      Uint8List imageData, String firebasePath) async {
    final storageRef = FirebaseStorage.instance.ref().child(firebasePath);
    final uploadTask = storageRef.putData(imageData);
    final snapshot = await uploadTask.whenComplete(() => {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  Future<void> storeImageUrlInFirestore(String downloadUrl,String? userId) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final imageRef = firestore
          .collection('users')
          .doc(userId)
          .collection('layouts')
          .doc();
      await imageRef.set({
        'url': downloadUrl,
      });
    } catch (e) {
      print("EXCEPTION- $e");
    }
  }

  Future<void> handleImageUpload(String assetUrl) async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;

    try {
      final imageData = await loadAsset(assetUrl);
      final downloadUrl = await uploadImageToFirebase(imageData,
          'users_layouts/$userId/layout${DateTime.now().millisecondsSinceEpoch}');
      await storeImageUrlInFirestore(downloadUrl, userId);
      print('Image URL stored in Firestore: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }
}
