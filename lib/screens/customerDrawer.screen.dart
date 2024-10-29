import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto_personal/screens/gestionarRecetas.screen.dart';
import 'package:proyecto_personal/screens/home.screen.dart';
import 'package:proyecto_personal/screens/login.screen.dart';
import 'package:proyecto_personal/screens/recetas.screen.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user =
        FirebaseAuth.instance.currentUser; // Variable 'user' declarada aquí

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          SizedBox(
            height: 200.0,
            child: DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.amber,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset('images/Ozin.jpeg', height: 80.0),
                  const SizedBox(height: 10),
                  const Text(
                    'Bienvenido',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    // Uso de la variable 'user' para mostrar el correo
                    user?.email ?? 'usuario@ejemplo.com',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.receipt_long),
            title: const Text('Recetas Creadas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const RecetasScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.cookie),
            title: const Text('Gestionar Recetas'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const GestionarRecetasScreen()),
              );
            },
          ),
          ExpansionTile(
            leading: const Icon(Icons.person),
            title: const Text('Perfil'),
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Cerrar Sesión'),
                onTap: () async {
                  await FirebaseAuth.instance.signOut();
                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
