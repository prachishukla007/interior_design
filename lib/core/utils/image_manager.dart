import 'dart:io';

class ImageManager {
  static final ImageManager _instance = ImageManager._internal();
  List<String> uploadedImages = [];

  factory ImageManager() {
    return _instance;
  }

  ImageManager._internal();

  void addImage(String image) {
    // print("got data $image");
    uploadedImages.add(image);
    // print("got data $uploadedImages");

  }

  List<String> getImages() {
    return uploadedImages;
  }

  void clear() {
    uploadedImages.clear();
    }
}
