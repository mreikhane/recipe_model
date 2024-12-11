import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import '../services/recipe_services.dart';


class EditRecipeScreen extends StatefulWidget {
  final int recipeId;
  final String initialTitle;
  final String initialDescription;
  final String initialCookingMethod;
  final String initialIngredients;
  final String initialPhotoUrl;

  EditRecipeScreen({
    required this.recipeId,
    required this.initialTitle,
    required this.initialDescription,
    required this.initialCookingMethod,
    required this.initialIngredients,
    required this.initialPhotoUrl,
  });

  @override
  _EditRecipeScreenState createState() => _EditRecipeScreenState();
}

class _EditRecipeScreenState extends State<EditRecipeScreen> {
  final _formKey = GlobalKey<FormState>();
  final RecipeService _recipeService = RecipeService();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _cookingMethodController;
  late TextEditingController _ingredientsController;
  XFile? _selectedImage;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.initialTitle);
    _descriptionController = TextEditingController(text: widget.initialDescription);
    _cookingMethodController = TextEditingController(text: widget.initialCookingMethod);
    _ingredientsController = TextEditingController(text: widget.initialIngredients);
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImage = image;
      });
    }
  }

  Future<void> _updateRecipe() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _recipeService.updateRecipe(
          id: widget.recipeId,
          title: _titleController.text,
          description: _descriptionController.text,
          cookingMethod: _cookingMethodController.text,
          ingredients: _ingredientsController.text,
          photoPath: _selectedImage?.path ?? '',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Recipe updated successfully')),
        );
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update recipe: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Recipe'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _titleController,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the title' : null,
                  decoration: InputDecoration(labelText: 'Title'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _descriptionController,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the description' : null,
                  decoration: InputDecoration(labelText: 'Description'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _cookingMethodController,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the cooking method' : null,
                  decoration: InputDecoration(labelText: 'Cooking Method'),
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _ingredientsController,
                  validator: (value) => value == null || value.isEmpty ? 'Please enter the ingredients' : null,
                  decoration: InputDecoration(labelText: 'Ingredients'),
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: _pickImage,
                  child: _selectedImage == null
                      ? Image.network(widget.initialPhotoUrl, height: 150, fit: BoxFit.cover)
                      : Image.file(File(_selectedImage!.path), height: 150, fit: BoxFit.cover),
                ),
                SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _updateRecipe,
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
