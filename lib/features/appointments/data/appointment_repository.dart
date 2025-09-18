import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_model.dart';

class AppointmentRepository {
  final FirebaseFirestore firestore;

  AppointmentRepository(this.firestore);

  Stream<List<Appointment>> getAppointments() {
    return firestore
        .collection('appointments')
        .orderBy('date')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Appointment.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  Future<void> bookAppointment(String userId, Appointment appointment) async {
    await firestore
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(appointment.id)
        .set(appointment.toMap());
  }
}
