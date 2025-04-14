import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/models/user_models.dart';
import 'package:flutter_firebase_1/services/auth_services.dart';
import 'package:flutter_firebase_1/widgets/custom_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreen createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final AuthServices _authServices = AuthServices();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? _email;
  String? _password;
  bool _isPasswordVisible = false;
  bool _isLoading = false;

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    setState(() => _isLoading = true);

    try {
      UserModels? user = await _authServices.signInWithEmailAndPassword(
        _email!,
        _password!,
      );

      if (user != null) {
        await _firebaseAuth.currentUser?.reload();
        final currentUser = _firebaseAuth.currentUser;

        if (currentUser != null && !currentUser.emailVerified) {
          await _firebaseAuth.signOut();
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Email belum diverifikasi. Cek inbox kamu!'),
              ),
            );
          }
        } else {
          if (kDebugMode) print('Login berhasil: ${user.email}');
          if (mounted) {
            Navigator.pushReplacementNamed(context, '/home');
          }
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Login gagal. Periksa email dan password Anda.'),
            ),
          );
        }
      }
    } catch (e) {
      if (kDebugMode) print('Error login: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan. Coba lagi.')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text('WELL'),
              Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomField(
                        hintText: 'Email',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong';
                          }
                          return null;
                        },
                        onSaved: (value) => _email = value,
                      ),
                      const SizedBox(height: 4),
                      CustomField(
                        hintText: 'Password',
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Password tidak boleh kosong';
                          }
                          return null;
                        },
                        onSaved: (value) => _password = value,
                        obscureText: !_isPasswordVisible,
                        keyboardType: TextInputType.visiblePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          fixedSize: const Size(double.maxFinite, 50),
                          alignment: Alignment.centerLeft,
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: const Text('Lupa Password?'),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/register',
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: const Size(double.maxFinite, 50),
                              ),
                              child: const Text('Daftar'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _handleLogin,
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                fixedSize: const Size(double.maxFinite, 50),
                                backgroundColor: Colors.amber,
                              ),
                              child:
                                  _isLoading
                                      ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                      )
                                      : const Text('Masuk'),
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
