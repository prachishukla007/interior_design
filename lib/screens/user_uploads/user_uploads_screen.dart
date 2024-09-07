import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:interior_design/core/constants/color_constant.dart';
import 'package:shimmer/shimmer.dart';

import '../../arguments/image_preview_args.dart';
import '../../core/constants/icon_constant.dart';
import '../../core/res/app_text_styles.dart';
import '../../core/utils/image_manager.dart';
import '../../navigator/navigator_services.dart';
import '../../routes/route_manager.dart';


class UserUploadsScreen extends StatefulWidget {
  const UserUploadsScreen({super.key});

  @override
  State<UserUploadsScreen> createState() => _UserUploadsScreenState();
}

class _UserUploadsScreenState extends State<UserUploadsScreen> {
  final ImagePicker _picker = ImagePicker();
  final uploadedImages = ImageManager().getImages().reversed.toList();



  Future<void> _handleCamera(BuildContext context) async {
    appNavigator.pushNamed(Routes.imagePreview,
      args: ImagePreviewArguments(open: ImageSource.camera));

  }

  Future<void> _handleFileUpload(BuildContext context) async {
    appNavigator.pushNamed(Routes.imagePreview,
        args: ImagePreviewArguments(open: ImageSource.gallery));

  }

  Future<void> _showRecommendationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap a button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Upload Recommendation', style: AppTextStyles.blackBoldText22()),
          content: const Text('For the best results, please capture a clear picture with no other objects in the frame. Ensure that the background is plain and unobstructed to help us effectively remove the background and enhance your experience.',
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(color: Colors.green, width: 2),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _showUploadOptions(context);
              },
              child: const Text(
                'Okay',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showUploadOptions(BuildContext context) {
    showModalBottomSheet(
      isDismissible: true,
      enableDrag: true,
      isScrollControlled: true, // Allows for height customization
      context: context,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _handleCamera(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.file_upload),
                title: const Text('Upload image'),
                onTap: () {
                  Navigator.pop(context);
                  _handleFileUpload(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFF0),
      appBar: uploadedImages.isNotEmpty ? AppBar(
        title: Text("My items", style: AppTextStyles.blackBoldText22(),),
        centerTitle: true,
        // backgroundColor: ColorConstant.secondary,

        flexibleSpace: Hero(
          tag: "add-btn",
          child: Container(
            decoration: const BoxDecoration(
              color: ColorConstant.secondary
              // gradient: LinearGradient(
              //   colors: [
              //     ColorConstant.primary, // Start color (e.g., orange)
              //     const Color(0xFFffffff),
              //     ColorConstant.primary, // Start color (e.g., orange)
              //     // End color (e.g., purple)
              //   ],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: TextButton(onPressed: () => _showRecommendationDialog(context),
                 child: Icon(Icons.add_a_photo_outlined, color: ColorConstant.black,))

          )
        ],
      )
          : null,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 2.0),
          child: uploadedImages.isNotEmpty
              ? Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: GridView.builder(
                      physics: const BouncingScrollPhysics(),
                                padding: const EdgeInsets.all(10),
                                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                                ),
                                itemCount: uploadedImages.length,
                                itemBuilder: (context, index) {
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(),
                        // boxShadow: [BoxShadow(color: ColorConstant.appGrey,offset:Offset(0,0),spreadRadius: 0, blurRadius: 0)]
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: CachedNetworkImage(imageUrl: uploadedImages[index],
                          fit: BoxFit.fill,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: 50,
                              height: 50,
                              color: Colors.grey[300],
                            ),
                          ),                        // Center(child: SizedBox (height: 20,width: 20,child: CircularProgressIndicator(),)
                              // ),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        )
                        // Image.network(
                        //   uploadedImages[index],
                        //   fit: BoxFit.cover, // Adjust based on your needs
                        // ),
                      ),
                    );
                                },
                              ),
                  ),
                ],
              ) : Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Image.asset(IconConstant.emptyDataGif,color: ColorConstant.primary,
                  colorBlendMode: BlendMode.hue,),
              ),
              const SizedBox(height: 20.0),

              // Updated text message
              const Text(
                "OOPS!!",
                style: TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Matemasie",
                  color: Colors.black87,
                  letterSpacing: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10.0),
              const Text(
                "Upload your pic and watch your vision come alive!!",
                style: TextStyle(
                  fontSize: 15,
                  fontFamily: 'Matemasie-Regular',
                  color: Colors.black54,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () => _showRecommendationDialog(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 30.0, vertical: 12.0),
                  backgroundColor: const Color(0xffd25f5f),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text(
                  "LET'S UPLOAD",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
