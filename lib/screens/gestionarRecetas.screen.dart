import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto_personal/screens/customerDrawer.screen.dart';

class GestionarRecetasScreen extends StatefulWidget {
  const GestionarRecetasScreen({super.key});

  @override
  GestionarRecetasScreenState createState() => GestionarRecetasScreenState();
}

class GestionarRecetasScreenState extends State<GestionarRecetasScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestionar Recetas'),
        backgroundColor: Colors.amber,
      ),
      drawer: const CustomDrawer(),
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
          Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    labelText: 'Buscar Recetas',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value.toLowerCase();
                    });
                  },
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('recetas')
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final recetas = snapshot.data!.docs.where((receta) {
                      return receta['titulo']
                          .toString()
                          .toLowerCase()
                          .contains(_searchQuery);
                    }).toList();
                    return ListView.builder(
                      itemCount: recetas.length,
                      itemBuilder: (context, index) {
                        final receta = recetas[index];
                        return ListTile(
                          title: Text(receta['titulo']),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              IconButton(
                                icon: const Icon(Icons.edit),
                                onPressed: () {
                                  _showEditDialog(context, receta);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete),
                                onPressed: () {
                                  _deleteReceta(receta.id);
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showCreateDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateDialog(BuildContext context) {
    final TextEditingController tituloController = TextEditingController();
    final TextEditingController ingredientesController =
        TextEditingController();
    final TextEditingController preparacionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Crear Nueva Receta'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: ingredientesController,
                  decoration: const InputDecoration(labelText: 'Ingredientes'),
                ),
                TextField(
                  controller: preparacionController,
                  decoration: const InputDecoration(labelText: 'Preparación'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _createReceta(
                  tituloController.text,
                  ingredientesController.text,
                  preparacionController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Crear'),
            ),
          ],
        );
      },
    );
  }

  void _showEditDialog(BuildContext context, QueryDocumentSnapshot receta) {
    final TextEditingController tituloController =
        TextEditingController(text: receta['titulo']);
    final TextEditingController ingredientesController =
        TextEditingController(text: receta['ingredientes']);
    final TextEditingController preparacionController =
        TextEditingController(text: receta['preparacion']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar Receta'),
          content: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                TextField(
                  controller: tituloController,
                  decoration: const InputDecoration(labelText: 'Título'),
                ),
                TextField(
                  controller: ingredientesController,
                  decoration: const InputDecoration(labelText: 'Ingredientes'),
                ),
                TextField(
                  controller: preparacionController,
                  decoration: const InputDecoration(labelText: 'Preparación'),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _updateReceta(
                  receta.id,
                  tituloController.text,
                  ingredientesController.text,
                  preparacionController.text,
                );
                Navigator.of(context).pop();
              },
              child: const Text('Actualizar'),
            ),
          ],
        );
      },
    );
  }

  void _createReceta(String titulo, String ingredientes, String preparacion) {
    FirebaseFirestore.instance.collection('recetas').add({
      'titulo': titulo,
      'ingredientes': ingredientes,
      'preparacion': preparacion,
    });
  }

  void _updateReceta(
      String id, String titulo, String ingredientes, String preparacion) {
    FirebaseFirestore.instance.collection('recetas').doc(id).update({
      'titulo': titulo,
      'ingredientes': ingredientes,
      'preparacion': preparacion,
    });
  }

  void _deleteReceta(String id) {
    FirebaseFirestore.instance.collection('recetas').doc(id).delete();
  }
}
