import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/workout.dart';

class ApiWorkoutService {
  final String baseUrl = "http://ec2-18-193-77-180.eu-central-1.compute.amazonaws.com/api";
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
        workouts = jsonData.map((item) => Workout.fromJson(item)).toList();
      } else {
        print('No workouts found');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
    }

    return workouts;
  }

  Future<bool> addWorkout(String title, DateTime date, XFile imageFile) async {
    try {
      String? token = await storage.read(key: 'auth_token');
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
      final imageResponse = await imageRequest.send();
      final response = await http.Response.fromStream(imageResponse);
      return imageResponse.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<void> toggleLike(int workoutId) async {
    String? token = await storage.read(key: 'auth_token');
    final response = await http.post(
      Uri.parse('$baseUrl/workout/$workoutId/toggle_like/'),
      headers: {
        'Authorization': 'Token $token',
        'Content-Type': 'application/json',
      },
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to toggle like');
    }
  }

  Future<List<Workout>> fetchLastWeekWorkouts(int? user_id) async {
    List<Workout> workouts = [];

    try {
      String? token = await storage.read(key: 'auth_token');

      if (token == null) {
        print('No token found');
        return workouts;
      }
      final url = user_id == null
          ? Uri.parse('$baseUrl/workout/last-week-workouts/')
          : Uri.parse('$baseUrl/workout/last-week-workouts/?user_id=$user_id');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',
        },
      );


      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final List<dynamic> jsonData = json.decode(decodedResponse);
        workouts = jsonData.map((item) => Workout.fromJson(item)).toList();
      } else {
        print('Failed to load workouts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching workouts: $e');
    }
    return workouts;
  }

}
