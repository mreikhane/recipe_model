import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/recipe_services.dart';


class AddRecipeScreen extends StatefulWidget {
  const AddRecipeScreen({super.key});

  @override
  _AddRecipeScreenState createState() => _AddRecipeScreenState();
}

class _AddRecipeScreenState extends State<AddRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecipeService _recipeService = RecipeService();

  String title = '';
  String description = '';
  String cookingMethod = '';
  String ingredients = '';
  XFile? _selectedImage;

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  void _submitRecipe() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      try {
        final success = await _recipeService.createRecipe(
          title: title,
          description: description,
          cookingMethod: cookingMethod,
          ingredients: ingredients,
          photoPath: _selectedImage?.path ?? '',
        );

        if (success) {
          Navigator.pop(context, true);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to add recipe')),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Recipe')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Title'),
                  onSaved: (value) => title = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a title' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => description = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a description' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Cooking Method'),
                  onSaved: (value) => cookingMethod = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter cooking method' : null,
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: 'Ingredients'),
                  onSaved: (value) => ingredients = value!,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter ingredients' : null,
                ),
                const SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImage == null
                      ? const Icon(Icons.add_a_photo, size: 100)
                      : Image.file(
                          File(_selectedImage!.path),
                          height: 150,
                          fit: BoxFit.cover,
                        ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _submitRecipe,
                  child: const Text('Add Recipe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
