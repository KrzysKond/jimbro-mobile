import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AuthService {
  final String baseUrl = "http://ec2-18-193-77-180.eu-central-1.compute.amazonaws.com";
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(); // Secure storage instance
  String? _token;

  Future<bool> signUp(String name, String email, String password) async {
    try {
      final url = Uri.parse('$baseUrl/api/user/create/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 201) {
        print('User created successfully: ${response.body}');
        return true;
      } else {
        print('Sign-up failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Sign-up error: $e');
      return false;
    }
  }

  Future<bool> login(String email, String password) async {

    String? deviceToken = await FirebaseMessaging.instance.getToken();

    try {
      final url = Uri.parse('$baseUrl/api/user/token/');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
          'device_token': deviceToken,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _token = data['token'];

        await _secureStorage.write(key: 'auth_token', value: _token);
        return true;
      } else {
        print('Login failed: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> isLoggedIn() async {
    _token = await _secureStorage.read(key: 'auth_token');
    return  _token != null;
  }
  Future<void> logout() async {
    _token = null;

    await _secureStorage.delete(key: 'auth_token');
  }

  Future<http.Response> getProtectedData(String endpoint) async {
    if ( _token == null) {
      throw Exception('User is not authenticated.');
    }

    final url = Uri.parse('$baseUrl$endpoint');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return response;
      } else {
        print('Failed to fetch data: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch data.');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Error fetching data.');
    }
  }

  Future<bool> deleteAccount() async{
    final url = Uri.parse('$baseUrl/api/user/info/delete-account/');
    try {
      final response = await http.delete(
        url,
        headers: {
          'Authorization': 'Token $_token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        print('Failed to fetch data: ${response.statusCode} ${response.body}');
        throw Exception('Failed to fetch data.');
      }
    } catch (e) {
      print('Error fetching data: $e');
      throw Exception('Error fetching data.');
    }
  }
}

final AuthService authService = AuthService();
