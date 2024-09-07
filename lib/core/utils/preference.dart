import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import '../../model/item_model.dart';

class SharedPrefs {
  SharedPrefs._();

  static final SharedPrefs instance = SharedPrefs._();

  Future<void> storeItemsData(List<Item> itemsList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    List<Map<String, dynamic>> itemsMapList =
        itemsList.map((item) => item.toMap()).toList();

    String itemsJson = jsonEncode(itemsMapList);
    await prefs.setString('itemsData', itemsJson);
  }

  Future<List<Item>> loadItemsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? itemsJson = prefs.getString('itemsData');

    if (itemsJson != null) {
      List<dynamic> itemsMapList = jsonDecode(itemsJson);

      List<Item> itemsList = itemsMapList.map((itemMap) {
        return Item.fromMap(Map<String, dynamic>.from(itemMap));
      }).toList();

      return itemsList;
    } else {
      return [];
    }
  }
}
