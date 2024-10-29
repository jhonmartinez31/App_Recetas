import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_personal/screens/customerDrawer.screen.dart';
import 'package:proyecto_personal/screens/recetasDetalle.screen.dart';

class RecetasScreen extends StatelessWidget {
  const RecetasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recetas'),
        backgroundColor: Colors.amber,
      ),
      drawer: const CustomDrawer(), // Added const for better performance
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'images/fondo.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Contenido
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('recetas').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final recetas = snapshot.data!.docs;
              return ListView.builder(
                itemCount: recetas.length,
                itemBuilder: (context, index) {
                  final receta = recetas[index];
                  return ListTile(
                    title: Text(receta['titulo']),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecetasDetalleScreen(
                            titulo: receta['titulo'],
                            ingredientes: receta['ingredientes'],
                            preparacion: receta['preparacion'],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
