import 'dart:convert';
import 'package:food_receipe/services/session_services.dart';
import 'package:http/http.dart' as http;

class CommentService {
  static const String baseUrl = 'https://recipe.incube.id/api';
  final SessionService _sessionService = SessionService();

  Future<bool> addComment(int recipeId, String comment) async {
    final token = await _sessionService.getToken();
    if (token == null || token.isEmpty) {
      throw Exception("Token tidak ditemukan");
    }

    final response = await http.post(
      Uri.parse('$baseUrl/recipes/$recipeId/comments'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'comment': comment}),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception("Gagal menambahkan komentar");
    }
  }
}
