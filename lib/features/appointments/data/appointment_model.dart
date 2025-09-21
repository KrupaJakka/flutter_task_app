import 'package:cloud_firestore/cloud_firestore.dart';

class Appointment {
  final String id;
  final String title;
  final DateTime date;

  Appointment({required this.id, required this.title, required this.date});

  /// Creates an Appointment from Firestore document data
  factory Appointment.fromMap(String id, Map<String, dynamic> data) {
    return Appointment(
      id: id,
      title: data['title'] as String? ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  /// Converts Appointment to a map for Firestore storage
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'date': Timestamp.fromDate(date), // store as Timestamp
    };
  }
}
