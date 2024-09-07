import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:interior_design/services/firebase_storage/firebase_store.dart';

import '../../core/utils/preference.dart';
import '../../model/item_model.dart';
import '../../model/user_details_model.dart';

class FirestoreDB {
  FirestoreDB._();

  static final FirestoreDB instance = FirestoreDB._();
  var auth = FirebaseAuth.instance;
  var store = FirebaseFirestore.instance;

  var usersCollection = "users";

  Future<UserDetailsModel> getUsersData() async {
    UserDetailsModel userDetails;
    final User? user = auth.currentUser;
    DocumentSnapshot<Map<String, dynamic>> data =
        await store.collection(usersCollection).doc(user?.uid).get();

    userDetails = UserDetailsModel.fromJson(data.data());
    return userDetails;
  }

  Future<void> addUsersData({required UserDetailsModel userDetails}) async {
    final User? user = auth.currentUser;
    if (user != null) {
      try {
        print("Came to add Data");
        var document = store.collection(usersCollection).doc(user.uid);
        print("userDetails: ${userDetails.toJson()}");

        document.set(userDetails.toJson());
        print("Done");

        FirebaseStore.instance.createUserFolder(user.uid);
      } catch (e) {
        print("Exception -- $e");
      }
    }
  }

  Future<void> addItem({required UserDetailsModel userDetails}) async {
    final User? user = auth.currentUser;
    if (user != null) {
      var document = store.collection(usersCollection).doc(user.uid);
      document.set(userDetails.toJson(), SetOptions(merge: true));
    }
  }

  Future<List<Item>> fetchItemsData() async {

    List<Item> itemsList = [];

    final User? user = auth.currentUser;
    if (user != null) {
      try {
        QuerySnapshot itemsSnapshot = await store.collection('items').get();

        for (var doc in itemsSnapshot.docs) {
          String docId = doc.id;
          Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;

          QuerySnapshot<Map<String, dynamic>> itemsImagesSnapshot = await store
              .collection('items')
              .doc(docId)
              .collection('itemsImages')
              .get();

          List<String> subImages = itemsImagesSnapshot.docs
              .map((subDoc) => subDoc.data()['url'] as String)
              .toList();

          Item item = Item(
            firstImage: docData['firstImage'],
            name: docData['name'],
            subImages: subImages,
          );

          itemsList.add(item);
        }
        return itemsList;
      } catch(e) {
        print("EXCEPTION ON FETCHING DATA - $e");
      }
    }
    return [];
  }

  Future<void> loadAndStoreItemsData() async {
    List<Item> itemsList = await fetchItemsData();

    await SharedPrefs.instance.storeItemsData(itemsList);

    // List<Item> savedItemsList = await loadItemsData();
    //
    // print(savedItemsList);
  }
}
