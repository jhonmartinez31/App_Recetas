import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto_personal/screens/recipe_detail.screen.dart';
import 'package:proyecto_personal/screens/customerDrawer.screen.dart';

// Clase HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  HomeScreenState createState() => HomeScreenState();
}

// Modelo de receta predeterminada
class Receta {
  final String title;
  final String image;
  final List<String> ingredientes;
  final String preparacion;

  Receta({
    required this.title,
    required this.image,
    required this.ingredientes,
    required this.preparacion,
  });
}

// Lista de recetas predeterminadas
final List<Receta> recetasPredefinidas = [
  Receta(
    title: 'Ensalada César',
    image: 'assets/images/ensalada.jpg',
    ingredientes: ['Lechuga', 'Crutones', 'Queso parmesano', 'Aderezo César'],
    preparacion:
        '1. Lava la lechuga. 2. Agrega los crutones. 3. Añade el queso y el aderezo.',
  ),
  Receta(
    title: 'Pizza Margherita',
    image: 'assets/images/pizza.jpg',
    ingredientes: ['Masa de pizza', 'Tomate', 'Queso mozzarella', 'Albahaca'],
    preparacion:
        '1. Precalienta el horno. 2. Coloca el tomate y el queso sobre la masa. 3. Hornea y agrega la albahaca al servir.',
  ),
  // Nuevas recetas agregadas
  Receta(
    title: 'Sopa de Tomate',
    image: 'assets/images/sopatomate.jpg',
    ingredientes: [
      'Tomates frescos',
      'Cebolla',
      'Ajo',
      'Caldo de vegetales',
      'Albahaca'
    ],
    preparacion:
        '1. Sofríe la cebolla y el ajo. 2. Agrega los tomates y el caldo. 3. Cocina hasta que estén tiernos. 4. Licúa y sirve con albahaca fresca.',
  ),
  Receta(
    title: 'Spaghetti Carbonara',
    image: 'assets/images/spaghetti.jpg',
    ingredientes: [
      'Spaghetti',
      'Tocino',
      'Huevos',
      'Queso parmesano',
      'Pimienta negra'
    ],
    preparacion:
        '1. Cocina la pasta. 2. Sofríe el tocino. 3. Mezcla los huevos y el queso. 4. Incorpora la mezcla de huevo y queso con la pasta caliente y el tocino.',
  ),
  Receta(
    title: 'Hamburguesa Clásica',
    image: 'assets/images/hamburguesa.jpg',
    ingredientes: [
      'Pan de hamburguesa',
      'Carne molida',
      'Lechuga',
      'Tomate',
      'Queso cheddar'
    ],
    preparacion:
        '1. Cocina la carne en la parrilla. 2. Coloca el queso sobre la carne caliente. 3. Arma la hamburguesa con el pan, la carne, lechuga, y tomate.',
  ),
  Receta(
    title: 'Tacos de Pollo',
    image: 'assets/images/tacos.jpg',
    ingredientes: [
      'Tortillas',
      'Pollo desmenuzado',
      'Cebolla',
      'Cilantro',
      'Salsa'
    ],
    preparacion:
        '1. Cocina el pollo y desmenúzalo. 2. Calienta las tortillas. 3. Coloca el pollo en las tortillas y añade cebolla, cilantro, y salsa al gusto.',
  ),
  Receta(
    title: 'Panqueques',
    image: 'assets/images/panqueques.jpg',
    ingredientes: ['Harina', 'Leche', 'Huevos', 'Azúcar', 'Polvo de hornear'],
    preparacion:
        '1. Mezcla la harina, leche, huevos, azúcar y polvo de hornear. 2. Cocina en un sartén caliente hasta que se formen burbujas y voltea. 3. Sirve con miel o frutas.',
  ),
  Receta(
    title: 'Enchiladas Verdes',
    image: 'assets/images/enchiladas.jpg',
    ingredientes: ['Tortillas', 'Pollo', 'Salsa verde', 'Queso', 'Cebolla'],
    preparacion:
        '1. Cocina el pollo y desmenúzalo. 2. Rellena las tortillas con pollo y enrolla. 3. Cubre con salsa verde y queso. 4. Hornea hasta que el queso esté derretido.',
  ),
];

class HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Método para obtener recetas desde Firestore
  Stream<List<Map<String, dynamic>>> _fetchRecipes() {
    return FirebaseFirestore.instance
        .collection('recetas')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'title': doc['title'] as String,
          'image': doc['image'] as String,
          'ingredientes': List<String>.from(doc['ingredientes'] ?? []),
          'preparacion': doc['preparacion'] as String? ?? '',
        };
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: const Text('Recetas Listas'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
      ),
      drawer: const CustomDrawer(),
      body: Stack(
        children: [
          // Fondo de la imagen
          Positioned.fill(
            child: Image.asset(
              'images/2.jpg',
              fit: BoxFit.cover,
              color: Colors.black.withOpacity(0.6),
              colorBlendMode: BlendMode.darken,
            ),
          ),
          // StreamBuilder para obtener recetas de Firestore
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: _fetchRecipes(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              // Combinar recetas predeterminadas con las de Firestore
              final recipes = [
                ...recetasPredefinidas.map((receta) => {
                      'title': receta.title,
                      'image': receta.image,
                      'ingredientes': receta.ingredientes,
                      'preparacion': receta.preparacion,
                    }),
                ...?snapshot.data,
              ];

              if (recipes.isEmpty) {
                return const Center(child: Text('No hay recetas disponibles'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(8.0),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  childAspectRatio: 3 / 4,
                ),
                itemCount: recipes.length,
                itemBuilder: (context, index) {
                  final recipe = recipes[index];
                  final recipeTitle = recipe['title'] as String;
                  final recipeImage = recipe['image'] as String;
                  final recipeIngredients =
                      List<String>.from(recipe['ingredientes'] ?? []);
                  final recipePreparation = recipe['preparacion'] as String;

                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RecipeDetailScreen(
                            title: recipeTitle,
                            image: recipeImage,
                            ingredients: recipeIngredients,
                            preparation: recipePreparation,
                          ),
                        ),
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeInOut,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 1,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Card(
                        elevation: 3.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Column(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                                child: Image.network(
                                  recipeImage,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                recipeTitle,
                                style: const TextStyle(
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
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
