import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? errorText;
  bool obscure = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    setState(() => errorText = null);
    final notifier = ref.read(authNotifierProvider.notifier);

    try {
      await notifier.signIn(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
      // On success, auth stream will update and SplashScreen route logic will handle navigation
    } catch (e) {
      setState(() => errorText = e.toString());
    }
  }

  Future<void> _signup() async {
    setState(() => errorText = null);
    final notifier = ref.read(authNotifierProvider.notifier);

    try {
      await notifier.signUp(
        emailController.text.trim(),
        passwordController.text.trim(),
      );
    } catch (e) {
      setState(() => errorText = e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authNotifierProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: obscure,
              decoration: InputDecoration(
                labelText: 'Password',
                suffixIcon: IconButton(
                  icon: Icon(obscure ? Icons.visibility_off : Icons.visibility),
                  onPressed: () => setState(() => obscure = !obscure),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (errorText != null) ...[
              Text(errorText!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
            ],
            authState.loading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _login,
                      child: const Text('Login'),
                    ),
                  ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: _signup,
                child: const Text('Create account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
