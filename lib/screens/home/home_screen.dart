import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:interior_design/navigator/navigator_services.dart';
import 'package:interior_design/viewmodel/home_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import '../../arguments/item_preview_args.dart';
import '../../core/constants/color_constant.dart';
import '../../core/constants/icon_constant.dart';
import '../../core/res/app_text_styles.dart';
import '../../core/utils/image_manager.dart';
import '../../model/item_model.dart';
import '../../routes/route_manager.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  late Timer _timer;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static const Color secondary = Color(0xffFFFFF0);
  static const Color primary = Color(0xFF051f0b);

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

  Future<void> storeImageUrlInFirestore(String downloadUrl) async {
    try {
      final firestore = FirebaseFirestore.instance;
      final imageRef = firestore
          .collection('items')
          .doc('book_shelf')
          .collection('itemsImages')
          .doc();
      await imageRef.set({
        'url': downloadUrl,
      });
    } catch (e) {
      print("EXCEPTION- $e");
    }
  }

  Future<void> handleImageUpload() async {
    try {
      final imageData = await loadAsset("assets/images/bg-image26.jpeg");
      final downloadUrl = await uploadImageToFirebase(imageData,
          'items/book_shelf/book_shelf${DateTime.now().millisecondsSinceEpoch}');
      await storeImageUrlInFirestore(downloadUrl);
      print('Image URL stored in Firestore: $downloadUrl');
    } catch (e) {
      print('Error uploading image: $e');
    }
  }

  Future<void> showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // User must tap button to close
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Log Out', style: AppTextStyles.blackBoldText22()),
          content: const Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(
                  color: ColorConstant.red,
                  decoration: TextDecoration.underline,
                  decorationColor: ColorConstant.red, // Underline color
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorConstant.green.withOpacity(0.5),
                // Makes the button background transparent
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  // Circular border radius
                  side: BorderSide(
                      color: ColorConstant.green,
                      width: 2), // Border color and width
                ),
              ),
              onPressed: () async {
                ImageManager().clear();
                await signOut(context);
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Log Out',
                  style: TextStyle(color: ColorConstant.black)),
            ),
          ],
        );
      },
    );
  }

  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You have been signed out.')),
      );

      Navigator.pushReplacementNamed(context, Routes.login);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign out: $e')),
      );
    }
  }

  Future<void> _listFiles() async {
    print("got data");

    String? userId = _auth.currentUser?.uid;
    final ListResult result =
        await _storage.ref('users_posts/$userId/my_collection/').listAll();
    final List<String> urls = [];

    for (var ref in result.items) {
      final String url = await ref.getDownloadURL();
      urls.add(url);
      !url.contains("placeholder.txt") ? ImageManager().addImage(url) : null;
    }

    print(ImageManager().uploadedImages);
  }

  @override
  void initState() {
    super.initState();
    _listFiles();
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < 3) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }

      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      appBar: AppBar(
        backgroundColor: ColorConstant.secondary,

        // shadowColor: ColorConstant.appGrey,
        title: Row(
          children: [
            const CircleAvatar(
              backgroundImage: AssetImage(IconConstant.appLogoIcon),
              // Your logo image
              radius: 20.0,
              backgroundColor: Colors.white,
            ),
            const SizedBox(width: 10.0),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search',
                    prefixIcon: Icon(Icons.search),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(10.0),
                  ),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // handleImageUpload();
              showLogoutDialog(context);
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Padding around the image slider
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0), // Rounded corners
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 200.0,
                          child: PageView(
                            controller: _pageController,
                            onPageChanged: (int page) {
                              setState(() {
                                _currentPage = page;
                              });
                            },
                            children: [
                              Image.asset(IconConstant.bgImage1,
                                  fit: BoxFit.cover),
                              Image.asset(IconConstant.bgImage2,
                                  fit: BoxFit.cover),
                              Image.asset(IconConstant.bgImage3,
                                  fit: BoxFit.cover),
                              Image.asset(IconConstant.bgImage6,
                                  fit: BoxFit.cover),
                            ],
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          left: 0.0,
                          right: 0.0,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(4, (index) {
                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4.0),
                                height: 8.0,
                                width: _currentPage == index ? 12.0 : 8.0,
                                decoration: BoxDecoration(
                                  color: _currentPage == index
                                      ? primary
                                      : primary.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              );
                            }),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Consumer<HomeViewModel>(builder: (context, controller, c) {
                  return Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(8.0),
                      physics: const BouncingScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 1.0,
                      ),
                      itemCount: controller.items
                          .where(
                              (c) => c.name.toLowerCase().contains(_searchQuery))
                          .toList()
                          .length,
                      itemBuilder: (context, index) {
                        final filteredCategories = controller.items
                            .where((c) =>
                                c.name.toLowerCase().contains(_searchQuery))
                            .toList();
                        final category = filteredCategories[index];
                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: () {
                                appNavigator.pushNamed(Routes.itemPreview,
                                    args: ItemPreviewArgs(
                                        name: category.name,
                                        itemImages: category.subImages));
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(),
                                  // boxShadow: [BoxShadow(color: ColorConstant.appGrey,offset:Offset(0,0),spreadRadius: 0, blurRadius: 0)]
                                ),
                                alignment: Alignment.center,
                                child: CachedNetworkImage(
                                  imageUrl: category.firstImage,
                                  fit: BoxFit.cover,
                                  // Ensures the image covers the entire container
                                  placeholder: (context, url) =>
                                      Shimmer.fromColors(
                                    baseColor: Colors.grey[300]!,
                                    highlightColor: Colors.grey[100]!,
                                    child: Container(
                                      width: double.infinity,
                                      // Makes sure the shimmer fills the entire width
                                      height: double.infinity,
                                      // Makes sure the shimmer fills the entire height
                                      color: Colors.grey[300],
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ));
                      },
                    ),
                  );
                }),
              ],
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                heroTag: "add-btn",
                onPressed: () {
                  Navigator.of(context).pushNamed(Routes.upload);
                },
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                elevation: 10.0,
                child: const Icon(Icons.add, color: ColorConstant.appWhite,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
