
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../models/member.dart';

class ApiUserService {
  final String baseUrl = "http://ec2-18-193-77-180.eu-central-1.compute.amazonaws.com/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();


  Future<bool> uploadImage(XFile imageFile) async {
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) {
        print('No token found');
        return false;
      }

      final imageRequest = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/user/info/upload-image/'),
      )
        ..headers['Authorization'] = 'Token $token'
        ..files.add(await http.MultipartFile.fromPath('profile_picture', imageFile.path));
      final imageResponse = await imageRequest.send();
      return imageResponse.statusCode == 200; // Check if the image upload was successful
    } catch (e) {
      return false;
    }
  }

  Future<String?> fetchUserPicture(int? user_id) async {
    try {
      String? token = await storage.read(key: 'auth_token');

      if (token == null) {
        print('No token found');
        return null;
      }

      final url = user_id == null
          ? Uri.parse('$baseUrl/user/info/profile-picture/')
          : Uri.parse('$baseUrl/user/info/profile-picture/?user_id=$user_id');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        print('Fetched JSON data: $jsonData');

        return jsonData['profile_picture'] as String?;
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }


  Future<Member?> fetchUserData(int? user_id) async {
    try {
      String? token = await storage.read(key: 'auth_token');

      if (token == null) {
        print('No token found');
        return null;
      }

      final url = user_id == null
          ? Uri.parse('$baseUrl/user/info/')
          : Uri.parse('$baseUrl/user/info/?user_id=$user_id');

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $token',
        },
      );

      if (response.statusCode == 200) {
        final decodedResponse = utf8.decode(response.bodyBytes);
        final Map<String, dynamic> jsonData = json.decode(decodedResponse);
        print('Fetched JSON data: $jsonData');
        return Member.fromJson(jsonData);
      } else {
        print('Failed to load user data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
    return null;
  }
}