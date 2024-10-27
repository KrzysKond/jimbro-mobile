import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../models/comment.dart';

class ApiCommentService {
  final String baseUrl = 'http://10.0.2.2:8000/api/workout';
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<List<Comment>> fetchComments(int workoutId) async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.get(
        Uri.parse('$baseUrl/$workoutId/comments/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',

        },
    );
    print(response.body);
    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      List<dynamic> jsonData = json.decode(decodedResponse);
      return jsonData.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load comments');
    }
  }

  Future<void> addComment(int workoutId, String text) async {
    String? token = await _storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/$workoutId/comments/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',

      },
      body: json.encode({
        'text': text,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add comment');
    }
  }
}
