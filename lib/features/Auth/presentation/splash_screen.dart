import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';
import 'login_screen.dart';
import 'home_screen.dart';

class SplashScreen extends ConsumerWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(firebaseAuthStateProvider);

    return Scaffold(
      body: Center(
        child: authAsync.when(
          data: (user) {
            // Navigate after build completes
            Future.microtask(() {
              if (user == null) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              } else {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => HomeScreen(userId: user.uid),
                  ),
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
