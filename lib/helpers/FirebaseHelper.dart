import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseHelper {
  static Future<String> storeBackup(
      String userID, Map<String, Object?> content) async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    String now = DateTime.now().toString();

    await firestore.collection(userID).doc(now).set(
          content,
          SetOptions(merge: true),
        );

    return now;
  }

  static Future<Map<String, Object?>> getDocumentIDs(String userID) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(userID);
    QuerySnapshot snapshot = await collection.get();

    Map<String, Object?> result = {};

    for (QueryDocumentSnapshot doc in snapshot.docs) {
      String documentID = doc.id;
      DocumentSnapshot document = await collection.doc(documentID).get();
      Map<String, Object?> data = document.data() as Map<String, Object?>;

      result[documentID] = data;
    }

    return result;
  }

  static Future<void> deleteBackup(String userID, String backupID) async {
    CollectionReference collection = FirebaseFirestore.instance.collection(userID);
    await collection.doc(backupID).delete();
  }
}
