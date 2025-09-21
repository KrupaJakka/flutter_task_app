import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/appointment_model.dart';
import '../data/appointment_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Provider for AppointmentRepository
final appointmentRepositoryProvider = Provider<AppointmentRepository>((ref) {
  return AppointmentRepository(FirebaseFirestore.instance);
});

/// StreamProvider for fetching all appointments
final calendarAppointmentsProvider = StreamProvider<List<Appointment>>((ref) {
  final repo = ref.watch(appointmentRepositoryProvider);
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

  bool _isSameDate(Appointment appt, DateTime day) {
    return appt.date.year == day.year &&
        appt.date.month == day.month &&
        appt.date.day == day.day;
  }

  @override
  Widget build(BuildContext context) {
    final appointmentsAsync = ref.watch(calendarAppointmentsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Appointment Calendar')),
      body: appointmentsAsync.when(
        data: (appointments) {
          final dayAppointments = _selectedDay != null
              ? appointments
                    .where((appt) => _isSameDate(appt, _selectedDay!))
                    .toList()
              : [];

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
                child: dayAppointments.isEmpty
                    ? const Center(
                        child: Text('No appointments for selected day'),
                      )
                    : ListView.builder(
                        itemCount: dayAppointments.length,
                        itemBuilder: (context, index) {
                          final appt = dayAppointments[index];
                          return ListTile(
                            title: Text(appt.title),
                            subtitle: Text(appt.date.toLocal().toString()),
                            trailing: ElevatedButton(
                              onPressed: () async {
                                final repo = ref.read(
                                  appointmentRepositoryProvider,
                                );
                                try {
                                  await repo.bookAppointment(
                                    widget.userId,
                                    appt,
                                  );
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Appointment booked!'),
                                    ),
                                  );
                                } catch (e) {
                                  if (!mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Error booking: $e'),
                                    ),
                                  );
                                }
                              },
                              child: const Text('Book'),
                            ),
                          );
                        },
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
