import 'package:flutter/material.dart';

class RecipeDetailScreen extends StatelessWidget {
  final String title;
  final String image;
  final List<String> ingredients;
  final String preparation;

  const RecipeDetailScreen({
    super.key,
    required this.title,
    required this.image,
    required this.ingredients,
    required this.preparation,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.amber,
      ),
      body: Stack(
        children: [
          // Imagen de fondo
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: const NetworkImage(
                    'https://media.istockphoto.com/id/1458698228/es/foto/enfoque-selectivo-mesa-de-madera-sobre-fondo-borroso-de-la-encimera-de-la-cocina.jpg?s=612x612&w=0&k=20&c=2FuPuHvC007mTh2pgfbOtPzEBuQJbhOw1ezIEmJIbgw='), // URL de la imagen de fondo
                fit: BoxFit.cover, // Cubre toda la pantalla
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(
                      0.5), // Oscurece ligeramente para mejorar legibilidad
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          // Contenido de la pantalla
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.4,
                      child: AspectRatio(
                        aspectRatio: 4 / 3,
                        child: Image.network(image, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Ingredientes',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  ...ingredients.map((ingredient) => Text('- $ingredient',
                      style: const TextStyle(color: Colors.white))),
                  const SizedBox(height: 16.0),
                  const Text(
                    'Preparación',
                    style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8.0),
                  Text(preparation,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
