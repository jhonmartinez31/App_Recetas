import 'package:flutter/material.dart';

class RecetasDetalleScreen extends StatelessWidget {
  final String titulo;
  final String ingredientes;
  final String preparacion;

  const RecetasDetalleScreen({
    super.key,
    required this.titulo,
    required this.ingredientes,
    required this.preparacion,
  });

  @override
  Widget build(BuildContext context) {
    // Convertir los ingredientes en una lista
    List<String> ingredientesList = ingredientes.split(', ');

    return Scaffold(
      appBar: AppBar(
        title: Text(titulo),
        backgroundColor: Colors.amber,
      ),
      body: SingleChildScrollView(
        // Envuelve el contenido en SingleChildScrollView
        child: Stack(
          children: [
            // Imagen de fondo
            Positioned.fill(
              child: Image.asset(
                'images/fondo.jpg',
                fit: BoxFit.cover,
              ),
            ),
            // Contenido con fondo semi-transparente
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ingredientes:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    // Mostrar ingredientes como una lista
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ingredientesList.map((ingredient) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 2.0),
                          child: Text(
                            '- $ingredient',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Preparación:',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      preparacion,
                      style: const TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
