class Item {
  final String firstImage;
  final String name;
  final List<String> subImages;

  Item({
    required this.firstImage,
    required this.name,
    required this.subImages,
  });

  // Method to convert Firestore data into Item object
  factory Item.fromMap(Map<String, dynamic> data) {
    return Item(
      firstImage: data['firstImage'] as String,
      name: data['name'] as String,
      subImages: List<String>.from(data['subImages']),
    );
  }

  // Method to convert Item object into a Map for SharedPreferences storage
  Map<String, dynamic> toMap() {
    return {
      'firstImage': firstImage,
      'name': name,
      'subImages': subImages,
    };
  }
}
