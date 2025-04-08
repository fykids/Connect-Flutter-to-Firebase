import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/models/user_models.dart';
import 'package:flutter_firebase_1/services/auth_services.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  final AuthServices _authServices = AuthServices();
  String? _displayName;
  String? _email;
  String? _password;
  String? _phone;

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      setState(() => _isLoading = true);

      try {
        UserModels? user = await _authServices.signUpWithEmailAndPassword(
          _email!,
          _password!,
          _displayName!,
          _phone!,
        );

        if (user != null) {
          if (kDebugMode) {
            print('Registrasi berhasil: ${user.email}');
          }
          Navigator.pushReplacementNamed(
            // ignore: use_build_context_synchronously
            context,
            '/home',
            arguments: user.email,
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Registrasi gagal. Coba lagi.'),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        String errorMessage = 'Registrasi gagal. Coba lagi.';
        if (e.code == 'email-already-in-use') {
          errorMessage = 'Email sudah digunakan.';
        } else if (e.code == 'weak-password') {
          errorMessage = 'Password terlalu lemah.';
        }
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } catch (e) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
        );
        if (kDebugMode) {
          print('Error registrasi: $e');
        }
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(
              // ignore: use_build_context_synchronously
              context,
              '/login',
            );
          },
          icon: Icon(Icons.arrow_back_outlined),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  // ignore: use_build_context_synchronously
                                  context,
                                  '/register',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: Size(double.maxFinite, 50),
                              ),
                              child: const Text('Daftar'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleRegister,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: Size(double.maxFinite, 50),
                                backgroundColor: Colors.amber,
                              ),
                              child: const Text('Masuk'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
