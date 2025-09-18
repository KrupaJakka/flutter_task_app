import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/appointment_model.dart';
import '../data/appointment_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final calendarAppointmentsProvider = StreamProvider<List<Appointment>>((ref) {
  final repo = AppointmentRepository(FirebaseFirestore.instance);
  return repo.getAppointments();
});

class CalendarScreen extends ConsumerStatefulWidget {
  final String userId;
  const CalendarScreen({super.key, required this.userId});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(calendarAppointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Calendar')),
      body: appointmentsAsync.when(
        data: (appointments) {
          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
              ),
              Expanded(
                child: ListView(
                  children: appointments
                      .where(
                        (appt) =>
                            _selectedDay != null &&
                            appt.date.year == _selectedDay!.year &&
                            appt.date.month == _selectedDay!.month &&
                            appt.date.day == _selectedDay!.day,
                      )
                      .map(
                        (appt) => ListTile(
                          title: Text(appt.title),
                          subtitle: Text(appt.date.toLocal().toString()),
                          trailing: ElevatedButton(
                            onPressed: () async {
                              final repo = AppointmentRepository(
                                FirebaseFirestore.instance,
                              );
                              await repo.bookAppointment(widget.userId, appt);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Appointment booked!'),
                                ),
                              );
                            },
                            child: const Text('Book'),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
