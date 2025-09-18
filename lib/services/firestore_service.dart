import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<QuerySnapshot> getCollection(
    String path, {
    int limit = 10,
    DocumentSnapshot? startAfter,
  }) {
    Query query = _db.collection(path).limit(limit);
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    return query.get();
  }

  Future<DocumentSnapshot> getDocument(String path, String id) {
    return _db.collection(path).doc(id).get();
  }

  Future<void> setDocument(String path, String id, Map<String, dynamic> data) {
    return _db.collection(path).doc(id).set(data, SetOptions(merge: true));
  }
}
