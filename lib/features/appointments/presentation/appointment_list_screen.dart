import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../data/appointment_model.dart';
import '../data/appointment_repository.dart';
import 'calendar_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; 

final appointmentsProvider = StreamProvider<List<Appointment>>((ref) {
  final repo = AppointmentRepository(FirebaseFirestore.instance);
  return repo.getAppointments();
});

class AppointmentListScreen extends ConsumerWidget {
  final String userId;
  const AppointmentListScreen({super.key, required this.userId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appointmentsAsync = ref.watch(appointmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => CalendarScreen(userId: userId),
                ),
              );
            },
          ),
        ],
      ),
      body: appointmentsAsync.when(
        data: (appointments) => ListView.builder(
          itemCount: appointments.length,
          itemBuilder: (context, index) {
            final appt = appointments[index];
            return ListTile(
              title: Text(appt.title),
              subtitle: Text(appt.date.toLocal().toString().split(' ')[0]),
              trailing: ElevatedButton(
                child: const Text('Book'),
                onPressed: () async {
                  final repo = AppointmentRepository(
                    FirebaseFirestore.instance,
                  );
                  await repo.bookAppointment(userId, appt);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Appointment booked!')),
                  );
                },
              ),
            );
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
