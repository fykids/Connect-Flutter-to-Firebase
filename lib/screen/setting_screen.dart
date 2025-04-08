import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/services/auth_services.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // ignore: no_leading_underscores_for_local_identifiers
    final AuthServices _authServices = AuthServices();
    return Scaffold(
      body: Center(
        child: TextButton(
          onPressed: () async {
            // Panggil fungsi logout
            await _authServices.signOut();

            // Navigasi ke halaman login
            // ignore: use_build_context_synchronously
            Navigator.pushReplacementNamed(context, '/login');
          },
          child: Text('Keluar'),
        ),
      ),
    );
  }
}
