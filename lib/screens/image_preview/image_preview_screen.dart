import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interior_design/navigator/navigator_services.dart';

import '../../arguments/save_image_args.dart';
import '../../routes/route_manager.dart';

class ImagePreviewPage extends StatefulWidget {
  final ImageSource open;

  const ImagePreviewPage({super.key, required this.open});

  @override
  State<ImagePreviewPage> createState() => _ImagePreviewPageState();
}

class _ImagePreviewPageState extends State<ImagePreviewPage> {
  XFile? image;
  String errorMessage = '';
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    initCam();
  }

  initCam() async {
    image = await ImagePicker().pickImage(source: widget.open);
    setState(() {});
  }

  void _removeBackground(BuildContext context, XFile image) async {
    setState(() {
      isLoading = true;
    });

    try {
      final uploadedImageResp = await uploadImage(image);
      if (uploadedImageResp.runtimeType == String) {
        errorMessage = "Failed to upload image";
        return;
      }
      setState(() {
        isLoading = true;
      });
      await appNavigator.pushNamed(Routes.saveImage, args: SaveImageArguments(imagePath: image.path, uploadedImage: uploadedImageResp));

    } catch (e) {
      setState(() {
        isLoading = false;
      });
      // If an error occurs, log the error to the console.
      print(e);
    }


    // try {
    //   final uploadedImageResp = await uploadImage(image);
    //   // If the picture was taken, display it on a new screen.
    //   if (uploadedImageResp.runtimeType == String) {
    //     errorMessage = "Failed to upload image";
    //     return;
    //   }
    //   print("IMage uploaded");
    //   appNavigator.pushNamed(Routes.saveImage,
    //       args: SaveImageArguments(image: image!));
    // } catch(e) {
    //   print("ERROR ON BCKGRD RMV ${e.toString()}");
    // }
  }

  uploadImage(XFile image) async {
    var formData = FormData();
    var dio = Dio();
    dio.options.headers["X-Api-Key"] = "ZfhgbEQgq2n8t3ivfbhYFdU5";
    try {
      if (kIsWeb) {
        var _bytes = await image.readAsBytes();
        formData.files.add(MapEntry(
          "image_file",
          MultipartFile.fromBytes(_bytes, filename: "pic-name.png"),
        ));
      } else {
        formData.files.add(MapEntry(
          "image_file",
          await MultipartFile.fromFile(image.path, filename: "pic-name.png"),
        ));
      }
      Response<List<int>> response = await dio.post(
          "https://api.remove.bg/v1.0/removebg",
          data: formData,
          options: Options(responseType: ResponseType.bytes));
      print("IIIIII ${response.data}");

      return response.data;
    } catch (e) {
      print("IIIIII $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Image'),
        backgroundColor: const Color(0xffd25f5f),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (image != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(image!.path),
                    fit: BoxFit.contain, // Ensures the image is properly fitted inside the container
                  ),
                ),
              ),
            const SizedBox(height: 20.0),
            isLoading ? Center(child: SizedBox(height: 47, width: 47,child: CircularProgressIndicator())) : ElevatedButton(
              onPressed: () => _removeBackground(context, image!),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
                backgroundColor: const Color(0xffd25f5f),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              child: const Text(
                "REMOVE BACKGROUND",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}
