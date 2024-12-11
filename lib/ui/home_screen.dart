import 'package:flutter/material.dart';

import '../models/detail_model.dart';
import '../services/recipe_services.dart';
import 'add_recipe_screen.dart';
import 'edit_recipe_screen.dart';// Tambahkan ini untuk screen tambah resep

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  late Future<List<RecipeModel>> futureRecipes;

  @override
  void initState() {
    super.initState();
    futureRecipes = _recipeService.getAllRecipes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Fungsi logout
            },
          ),
        ],
      ),
      body: FutureBuilder<List<RecipeModel>>(
        future: futureRecipes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        futureRecipes = _recipeService.getAllRecipes();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No recipes available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final recipe = snapshot.data![index];
                return ListTile(
                  leading: recipe.photoUrl.isNotEmpty
                      ? Image.network(
                          recipe.photoUrl,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : const Icon(Icons.image, size: 50),
                  title: Text(recipe.title),
                  subtitle: Text(recipe.description),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditRecipeScreen(
                                recipeId: recipe.id,
                                initialTitle: recipe.title,
                                initialDescription: recipe.description,
                                initialCookingMethod: recipe.cookingMethod,
                                initialIngredients: recipe.ingredients,
                                initialPhotoUrl: recipe.photoUrl,
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              setState(() {
                                futureRecipes = _recipeService.getAllRecipes();
                              });
                            }
                          });
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmed = await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Delete Recipe'),
                              content: const Text(
                                  'Are you sure you want to delete this recipe?'),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, false),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, true),
                                  child: const Text('Delete'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true) {
                            try {
                              await _recipeService.deleteRecipe(recipe.id);
                              setState(() {
                                futureRecipes = _recipeService.getAllRecipes();
                              });
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Failed to delete: $e')),
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddRecipeScreen()),
          ).then((value) {
            if (value == true) {
              setState(() {
                futureRecipes = _recipeService.getAllRecipes();
              });
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
