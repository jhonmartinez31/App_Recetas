import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_personal/screens/home.screen.dart';
import 'package:proyecto_personal/screens/register.screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool _isLoading = false;
  bool _isPasswordVisible = false;

  void _tryLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();

      setState(() {
        _isLoading = true;
      });

      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _email,
          password: _password,
        );

        if (!mounted) return;

        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        _showErrorDialog(e.message);
      } catch (e) {
        _showErrorDialog('Ocurrió un error inesperado. Inténtalo de nuevo.');
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showErrorDialog(String? message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Error'),
        content: Text(message ?? 'Ocurrió un error inesperado.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
            },
            child: const Text('Ok'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'images/2.jpg',
              fit: BoxFit.cover,
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16.0),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 400),
                      child: Container(
                        padding: const EdgeInsets.all(20.0),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.8),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'BIENVENIDO \n INICIA SESION PARA ENTRAR 👨‍🍳🥗🍪🍥',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              TextFormField(
                                decoration:
                                    const InputDecoration(labelText: 'Email'),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty || !value.contains('@')) {
                                    return 'Introduce un email válido';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _email = value!;
                                },
                              ),
                              TextFormField(
                                decoration: InputDecoration(
                                  labelText: 'Contraseña',
                                  suffixIcon: IconButton(
                                    icon: Icon(
                                      _isPasswordVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        _isPasswordVisible =
                                            !_isPasswordVisible;
                                      });
                                    },
                                  ),
                                ),
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value!.isEmpty || value.length < 6) {
                                    return 'Introduce una contraseña válida';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _password = value!;
                                },
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: _tryLogin,
                                child: const Text('Iniciar Sesión'),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const RegisterScreen(),
                                    ),
                                  );
                                },
                                child: const Text(
                                    '¿No tienes una cuenta? Regístrate aquí'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
