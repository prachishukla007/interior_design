import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class PreviewScreen extends StatefulWidget {
  final List<String> itemImages;
  final String name;

  const PreviewScreen({
    Key? key,
    required this.itemImages,
    required this.name,
  }) : super(key: key);

  @override
  _PreviewScreenState createState() => _PreviewScreenState();
}

class _PreviewScreenState extends State<PreviewScreen> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: const Color(0xfff1eeed), // Light green background
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_sharp, color:  Color(0xFF051f0b)),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen (home page)
          },
        ),
        centerTitle: true,
        title: Text(
          widget.name,
          style: const TextStyle(fontSize:22, fontWeight: FontWeight.w600,color:  Color(0xFF051f0b)),
        ),
        backgroundColor: Colors.transparent, // Darker green for the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0), // Padding added from the sides
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Carousel of images
            Expanded(
              child: PageView.builder(
                controller: _pageController, // Use a PageController to control swiping
                itemCount: widget.itemImages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0), // Add padding to the PageView items
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image Container
                        Container(
                          height: size.height * 0.5,
                          // width: size.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: const Color(0xFF051f0b), // Green border for a 3D effect
                              width: 4.0, // Thickness of the border
                            ),
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                offset: const Offset(4, 4), // Shadow position
                                blurRadius: 8, // Blur effect for the shadow
                              ),
                            ],
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.itemImages[index],
                            // fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                Shimmer.fromColors(
                                  baseColor: Colors.grey[300]!,
                                  highlightColor: Colors.grey[100]!,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.grey[300],
                                  ),
                                ),
                            // errorWidget: (context, url, error) =>
                            //     const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(height: 8.0), // Spacing between the image and item name

                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 10.0), // Reduced space above thumbnails

            // Thumbnails at the bottom
            Wrap(
              spacing: 10, runSpacing: 10,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: widget.itemImages.map((imageUrl) {
                int index = widget.itemImages.indexOf(imageUrl);
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = index;
                      _pageController.jumpToPage(index); // Jump to the selected image in the PageView
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4.0),
                    padding: const EdgeInsets.all(2.0),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: _currentIndex == index
                            ? const Color(0xFF051f0b) // Darker green for the active thumbnail
                            : Colors.grey,
                        width: 2.0,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 50.0,
                      height: 50.0,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: double.infinity,
                              color: Colors.grey[300],
                            ),
                          ),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 15.0), // Slightly smaller space before the button

            // 'USE' button with curved edges and primary color
            GestureDetector(
              onTap: () {
                // Handle your 'USE' button action here
                print("Selected image: ${widget.itemImages[_currentIndex]}");
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14.0, horizontal: 60.0),
                decoration: BoxDecoration(
                  color: const Color(0xFF051f0b), // Primary dark green color for button
                  borderRadius: BorderRadius.circular(30.0), // Curved edges
                ),
                child: const Text(
                  'USE',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white, // White text color
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20.0), // Add some space at the bottom
          ],
        ),
      ),
    );
  }
}