import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_task_app/features/appointments/presentation/appointment_list_screen.dart';
import 'package:flutter_task_app/features/assessments/presentation/assessment_list_screen.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(firebaseAuthStateProvider);

    return Scaffold(
      body: Center(
        child: authAsync.when(
          data: (user) {
            Future.microtask(() {
              if (user == null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const AppHome()),
                );
              }
            });

            return const CircularProgressIndicator();
          },
          loading: () => const CircularProgressIndicator(),
          error: (e, _) => Text('Error checking auth: $e'),
        ),
      ),
    );
  }
}

class AppHome extends StatefulWidget {
  const AppHome({super.key});
  @override
  State<AppHome> createState() => _AppHomeState();
}

class _AppHomeState extends State<AppHome> {
  int _index = 0;

  final screens = [AppointmentListScreen(userId: ''), AssessmentListScreen()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Assessments',
          ),
        ],
      ),
    );
  }
}
