import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interior_design/core/constants/color_constant.dart';
import 'package:interior_design/download_button_main.dart';
import 'package:interior_design/services/firebase_storage/firebase_store.dart';
import 'package:path_provider/path_provider.dart';

class SaveImagePage extends StatefulWidget {
  final String imagePath;
  final List<int> uploadedImage;

  SaveImagePage(
      {super.key, required this.imagePath, required this.uploadedImage});

  @override
  State<SaveImagePage> createState() => _SaveImagePageState();
}

class _SaveImagePageState extends State<SaveImagePage> {
  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  XFile? _newImageFile;

  @override
  void initState() {
    _convertAndSaveImage();
    super.initState();
  }

  Future<void> _convertAndSaveImage() async {
    final Uint8List imageData = Uint8List.fromList(widget.uploadedImage);

    final directory =
        await getTemporaryDirectory();
    final filePath =
        '${directory.path}/new_image${DateTime.now().millisecondsSinceEpoch}.png';
    final file = File(filePath);
    setState(() {
      _newImageFile = XFile(filePath);
    });

    await file.writeAsBytes(imageData);
  }

  @override
  Widget build(BuildContext context) {
    var image;
    if (kIsWeb) {
      image = Image.network(widget.imagePath);
    } else {
      image = Image.file(File(widget.imagePath));
    }
    var otherImage = null;
    try {
      otherImage = Image.memory(
        Uint8List.fromList(widget.uploadedImage),
      );
      // _convertAndSaveImage();
    } catch (e) {
      otherImage = const SizedBox.shrink();
    }
    return Scaffold(
        appBar: AppBar(title: const Text('Display the Picture')),
        body: SingleChildScrollView(
            child: Column(children: [
          // Original Image with 16 font and padding of 16
          const Text("Background Removed Image",
              style: TextStyle(fontSize: 16)),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
          Container(
            height: 600,
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: otherImage,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4)),
              isLoading ? const Center(child: SizedBox(height:47,width:47,child: CircularProgressIndicator())) : ElevatedButton(
            onPressed: () async {
              setState(() {
                isLoading = true;
              });
              if (otherImage is Image) {
                await FirebaseStore.instance.saveImage(context, _newImageFile!);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please try later!")));
              }
              setState(() {
                isLoading = false;
              });
            },
            // onPressed: () => appNavigator.popUntil('/home'),
            style: ElevatedButton.styleFrom(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
              backgroundColor: const Color(0xffd25f5f),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
            ),
            child: const Text(
              "SAVE IMAGE",
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
        ])));
  }
}
