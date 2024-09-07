import 'dart:io';
import 'package:flutter/material.dart';
import 'package:interior_design/core/utils/preference.dart';
import 'package:interior_design/model/item_model.dart';
import 'package:interior_design/services/firebase_db/firestore_db.dart';


class HomeViewModel with ChangeNotifier {
  int tabIndex = 0;
  bool nudgeUser = false;
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  List<Item> items = [];

  HomeViewModel() {
    loadItemsData();
  }

  Future<void> loadItemsData() async {
    await FirestoreDB.instance.loadAndStoreItemsData();
    List<Item> savedItemsList = await SharedPrefs.instance.loadItemsData();
    items = savedItemsList;
    print("ITEMSS length - ${savedItemsList.isEmpty}");
    print("ITEMSS - $savedItemsList");
    notifyListeners();
  }
}
