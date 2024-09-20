import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:interior_design/core/constants/color_constant.dart';
import 'package:shimmer/shimmer.dart';

import '../../core/res/app_text_styles.dart';
import '../../core/utils/image_manager.dart';
import '../../navigator/navigator_services.dart';
import '../../routes/route_manager.dart';

class ARLayouts extends StatefulWidget {
  const ARLayouts({super.key});

  @override
  State<ARLayouts> createState() => _ARLayoutsState();
}

class _ARLayoutsState extends State<ARLayouts> {
  final uploadedImages = ImageManager().getLayoutImages().reversed.toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffFFFFF0),
      appBar: AppBar(
        title: Text(
          "My Layouts",
          style: AppTextStyles.blackBoldText22(),
        ),
        centerTitle: true,
        leading: IconButton(
            onPressed: () {
              appNavigator.popUntil(Routes.home);
            },
            icon: const Icon(Icons.arrow_back)),
        flexibleSpace: Container(
          decoration: const BoxDecoration(color: ColorConstant.secondary),
        ),
      ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0),
            child: Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: GridView.builder(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.all(10),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
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
                            child: CachedNetworkImage(
                              imageUrl: uploadedImages[index],
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Shimmer.fromColors(
                                baseColor: Colors.grey[300]!,
                                highlightColor: Colors.grey[100]!,
                                child: Container(
                                  width: 50,
                                  height: 50,
                                  color: Colors.grey[300],
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
            )),
      ),
    );
  }
}
