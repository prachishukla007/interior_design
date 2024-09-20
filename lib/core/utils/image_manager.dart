import 'dart:io';

class ImageManager {
  static final ImageManager _instance = ImageManager._internal();
  List<String> uploadedImages = [];
  List<String> uploadedLayoutImages = [];

  factory ImageManager() {
    return _instance;
  }

  ImageManager._internal();

  void addImage(String image) {
    uploadedImages.add(image);

  }

  List<String> getImages() {
    return uploadedImages;
  }

  void addLayoutImage(String image) {
    // print("got data $image");
    uploadedLayoutImages.add(image);
    // print("got data $uploadedImages");
  }

  List<String> getLayoutImages() {
    return uploadedLayoutImages;
  }

  void clear() {
    uploadedImages.clear();
    }
}
