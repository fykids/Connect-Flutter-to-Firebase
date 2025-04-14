import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_1/models/user_models.dart';
import 'package:flutter_firebase_1/services/auth_services.dart';
import 'package:flutter_firebase_1/widgets/custom_field.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey2 = GlobalKey<FormState>();
  bool _isLoading = false;
  final AuthServices _authServices = AuthServices();
  String? _displayName;
  String? _email;
  String? _password;
  String? _phone;
  bool _isPasswordVisible = false;

  Future<void> _handleRegister() async {
    if (_formKey2.currentState!.validate()) {
      _formKey2.currentState!.save();
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
            '/login',
          );
        } else {
          // ignore: use_build_context_synchronously
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registrasi gagal. Coba lagi.')),
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
        ScaffoldMessenger.of(
          // ignore: use_build_context_synchronously
          context,
        ).showSnackBar(SnackBar(content: Text(errorMessage)));
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
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey2,
              child: Column(
                children: [
                  CustomField(
                    hintText: 'Email',
                    validator: (value) {
                      if (value!.isEmpty) return 'Email tidak boleh kosong';
                      return null;
                    },
                    onSaved: (value) => _email = value!,
                  ),
                  const SizedBox(height: 4),
                  CustomField(
                    hintText: 'Nama Lengkap',
                    validator: (value) {
                      if (value!.isEmpty) return 'Nama tidak boleh kosong';
                      return null;
                    },
                    onSaved: (value) => _displayName = value!,
                  ),
                  const SizedBox(height: 4),
                  CustomField(
                    hintText: 'Nomor HP',
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Nomor HP tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) => _phone = value!,
                  ),
                  const SizedBox(height: 4),
                  CustomField(
                    hintText: 'Password',
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Password tidak boleh kosong';
                      }
                      return null;
                    },
                    onSaved: (value) => _password = value!,
                    obscureText: !_isPasswordVisible,
                    keyboardType: TextInputType.visiblePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(
                          () => _isPasswordVisible = !_isPasswordVisible,
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _handleRegister,
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: Colors.amber,
                      fixedSize: const Size(double.maxFinite, 50),
                    ),

                    child:
                        _isLoading
                            ? const CircularProgressIndicator()
                            : const Text('Daftar'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
