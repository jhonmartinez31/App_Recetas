import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:proyecto_personal/screens/login.screen.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializa Firebase con las opciones correctas
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp()); // Añadido 'const' aquí
}

class MyApp extends StatelessWidget {
  const MyApp({super.key}); // Añadido 'const' aquí

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recetas de Cocina',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginScreen(), // Añadido 'const' aquí
    );
  }
}
