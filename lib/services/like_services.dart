import 'dart:convert';
import 'package:food_receipe/services/session_services.dart';
import 'package:http/http.dart' as http;

class LikeService {
  static const String baseUrl = 'https://recipe.incube.id/api';
  final SessionService _sessionService = SessionService();

  Future<bool> toggleLike(int recipeId, bool isLiked) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.post(
      Uri.parse('$baseUrl/recipes/$recipeId/likes'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'liked': isLiked}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception("Gagal mengubah status like");
    }
  }
}
