import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/group.dart';

class ApiGroupService {
  final String baseUrl = "http://ec2-18-193-77-180.eu-central-1.compute.amazonaws.com/api";
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<bool> createGroup(String groupName) async {
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) {
        print('No token found');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/user/group/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'name': groupName,
        }),
      );

      if (response.statusCode == 201) {
        print('Successfully created group: $groupName');
        return true;
      } else {
        print('Failed to create group: ${response.statusCode} ${response.body}');
        return false;
      }
    } catch (e) {
      print('Error creating group: $e');
      return false;
    }
  }


  Future<bool> joinGroup(int groupId) async {
    try {
      String? token = await storage.read(key: 'auth_token');
      if (token == null) {
        print('No token found');
        return false;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/user/group/$groupId/join/'),
        headers: {
          'Authorization': 'Token $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        return true;
      } else if (response.statusCode == 409) {
        throw Exception('User already is a member of the group');
      } else {
        final responseBody = json.decode(response.body);
        String detail = responseBody['detail'] ?? 'Unknown error occurred';
        throw Exception(detail);
      }
    } catch (e) {
      throw Exception('Error joining group: ${e.toString()}');
    }
  }

  Future<List<Group>> fetchUserGroups() async {
    String? token = await storage.read(key: 'auth_token');
    final response = await http.get(
      Uri.parse('$baseUrl/user/group/my_groups/'),
      headers: {
        'Authorization': 'Token $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> body = jsonDecode(response.body);
      return body.map((dynamic item) => Group.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load groups');
    }
  }

  Future<List<Group>> fetchAllGroups() async {
    String? token = await storage.read(key: 'auth_token');
    final response = await http.get(
        Uri.parse('$baseUrl/user/group'),
        headers: {
          'Authorization': 'Token $token'
        }
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((groupJson) => Group.fromJson(groupJson)).toList();
    } else {
      throw Exception('Failed to load groups');
    }
  }

  Future<bool> leaveGroup(groupId) async{
    String? token = await storage.read(key: 'auth_token');
    final response = await http.post(
        Uri.parse('$baseUrl/user/group/$groupId/leave/'),
        headers: {
          'Authorization': 'Token $token'
        }
    );
    if(response.statusCode ==200){
      return true;
    }else{
      throw Exception(response.statusCode);
    }
  }

  Future<Group> fetchGroupByCode(String inviteCode) async {
    final String? token = await storage.read(key: 'auth_token');
    final response = await http.get(
        Uri.parse('$baseUrl/user/group/group-by-invite-code/?invite_code=$inviteCode'),
        headers: {
          'Authorization': 'Token $token',
        }
    );


    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Group.fromJson(data);
    } else {
      throw Exception('Failed to fetch group');
    }
  }


}
