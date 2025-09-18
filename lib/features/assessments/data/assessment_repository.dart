import 'package:cloud_firestore/cloud_firestore.dart';
import 'assessment_model.dart';

class AssessmentRepository {
  final FirebaseFirestore firestore;

  AssessmentRepository(this.firestore);

  Stream<List<Assessment>> getAssessments({int limit = 10}) {
    return firestore
        .collection('assessments')
        .limit(limit)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Assessment.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<Assessment?> getAssessment(String id) async {
    final doc = await firestore.collection('assessments').doc(id).get();
    if (doc.exists) {
      return Assessment.fromMap(doc.id, doc.data()!);
    }
    return null;
  }
}
