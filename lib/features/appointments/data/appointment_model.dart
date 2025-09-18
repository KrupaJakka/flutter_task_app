import 'package:cloud_firestore/cloud_firestore.dart'; 

class Appointment {
  final String id;
  final String title;
  final DateTime date;

  Appointment({required this.id, required this.title, required this.date});

  factory Appointment.fromMap(String id, Map<String, dynamic> data) {
    return Appointment(
      id: id,
      title: data['title'] ?? '',
      date: (data['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {'title': title, 'date': date};
  }
}
