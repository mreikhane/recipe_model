import 'dart:convert';
import 'package:food_receipe/services/session_services.dart';
import 'package:http/http.dart' as http;

import '../models/detail_model.dart';

const String baseUrl = 'https://recipe.incube.id/api';

class RecipeService {
  final SessionService _sessionService = SessionService();

  // Mendapatkan semua resep
Future<List<RecipeModel>> getAllRecipes() async {
  final token = await _sessionService.getToken(); // Mendapatkan token untuk autentikasi
  final response = await http.get(
    Uri.parse('$baseUrl/recipes'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body)['data']['data'];
    return data.map((json) => RecipeModel.fromJson(json)).toList();
  } else {
    throw Exception("Failed to load recipes");
  }
}


  // Menambah resep baru
  Future<bool> createRecipe({
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required String photoPath,
  }) async {
    final token = await _sessionService.getToken();

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/recipes'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['cooking_method'] = cookingMethod;
    request.fields['ingredients'] = ingredients;
    request.files.add(await http.MultipartFile.fromPath('photo', photoPath));

    final response = await request.send();

    return response.statusCode == 201;
  }

  // Memperbarui resep
  Future<bool> updateRecipe({
    required int id,
    required String title,
    required String description,
    required String cookingMethod,
    required String ingredients,
    required String photoPath,
  }) async {
    final token = await _sessionService.getToken();

    var request = http.MultipartRequest(
      'PUT',
      Uri.parse('$baseUrl/recipes/$id'),
    );

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['title'] = title;
    request.fields['description'] = description;
    request.fields['cooking_method'] = cookingMethod;
    request.fields['ingredients'] = ingredients;
    request.files.add(await http.MultipartFile.fromPath('photo', photoPath));

    final response = await request.send();

    return response.statusCode == 200;
  }

  // Menghapus resep
  Future<bool> deleteRecipe(int id) async {
    final token = await _sessionService.getToken();

    final response = await http.delete(
      Uri.parse('$baseUrl/recipes/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );

    return response.statusCode == 200;
  }

  
}
