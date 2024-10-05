import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/workout.dart';

class ApiWorkoutService {
  final String baseUrl = "http://10.0.2.2:8000/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<List<Workout>> fetchWorkouts(String date) async {
    String formattedDate = date.substring(0, 10);
    List<Workout> workouts = [];

    try {
      String? token = await storage.read(key: 'auth_token');

      if (token == null) {
        print('No token found');
        return workouts;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/workout/get-by-date/?date=$formattedDate'),
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonData = json.decode(decodedResponse);
        print('Fetched JSON data: $jsonData');
        workouts = jsonData.map((item) => Workout.fromJson(item)).toList();
      } else {
        print('Failed to load workouts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
    }

    return workouts;
  }

  Future<bool> addWorkout(String title, DateTime date, XFile imageFile) async {
    try {
      String? token = await storage.read(key: 'auth_token');
      print('Stored token: $token');
      if (token == null) {
        print('No token found');
        return false;
      }
      final response = await http.post(
        Uri.parse('$baseUrl/workout/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'title': title,
          'date': '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        }),
      );

      if (response.statusCode == 201) {
        final workoutId = json.decode(response.body)['id'];
        await uploadWorkoutImage(workoutId, imageFile);
        return true; // Workout added successfully
      } else {
        print('Failed to add workout: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error adding workout: $e');
      return false;
    }
  }

  Future<bool> uploadWorkoutImage(int workoutId, XFile imageFile) async {
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) {
        print('No token found');
        return false;
      }

      final imageRequest = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/workout/$workoutId/upload-image/'),
      )
        ..headers['Authorization'] = 'Token $token'
        ..files.add(await http.MultipartFile.fromPath('image', imageFile.path));
      print('Request Headers: ${imageRequest.headers}');
      final imageResponse = await imageRequest.send();
      final response = await http.Response.fromStream(imageResponse);
      print('Response body: ${response.body}');
      print('Image upload response status: ${imageResponse.statusCode}');
      return imageResponse.statusCode == 200; // Check if the image upload was successful
    } catch (e) {
      print('Error uploading image: $e');
      return false;
    }
  }
}
