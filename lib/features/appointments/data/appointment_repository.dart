import 'package:cloud_firestore/cloud_firestore.dart';
import 'appointment_model.dart';

class AppointmentRepository {
  final FirebaseFirestore firestore;

  AppointmentRepository(this.firestore);

  /// Returns a stream of all appointments, ordered by date
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

  /// Books an appointment for a specific user
  Future<void> bookAppointment(String userId, Appointment appointment) async {
    final bookingRef = firestore
        .collection('users')
        .doc(userId)
        .collection('bookings')
        .doc(appointment.id);

    await bookingRef.set(appointment.toMap());
  }
}
