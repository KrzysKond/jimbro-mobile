import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../models/member.dart';
import '../../service/auth_service.dart';
import '../../service/api_user_data.dart';  // Import your ApiUserService

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? profilePictureUrl;
  String username = "";  // Placeholder for username
  String email = "";     // Placeholder for email
  final picker = ImagePicker();
  final ApiUserService apiUserService = ApiUserService();

  Future<void> _changeProfilePicture() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        profilePictureUrl = pickedFile.path;
      });

      bool uploadSuccess = await apiUserService.uploadImage(pickedFile);

      if (uploadSuccess) {
        print('Image uploaded successfully');
      } else {
        print('Failed to upload image');
      }
    }
  }

  Future<void> _fetchUserData() async {
    Member? memberData = await apiUserService.fetchUserData(null);
    if (memberData != null) {
      setState(() {
        profilePictureUrl = memberData.profilePicture;
        username = memberData.name;
      });
    } else {
      print("Failed to fetch user data");
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUserData(); // Fetch user data when the screen is initialized
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Settings",
          style: TextStyle(color: Colors.white, fontSize: 24),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    color: (profilePictureUrl == null)
                        ? Colors.blue
                        : Colors.transparent,
                    shape: BoxShape.circle,
                  ),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.transparent,
                    backgroundImage: (profilePictureUrl != null)
                        ? NetworkImage(profilePictureUrl!)
                        : null,
                    child: (profilePictureUrl == null)
                        ? const Icon(Icons.person, size: 60, color: Colors.white) // Default icon
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  username,
                  style: const TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 80),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _changeProfilePicture,
                    child: const Text("Change Profile Picture", style: TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 40),
                SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () async {
                      try {
                        await AuthService().logout();
                      } catch (e) {
                        print(e);
                      }
                      Navigator.pushNamedAndRemoveUntil(context, '/splash', (Route<dynamic> route) => false);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    child: const Text("Logout", style: TextStyle(fontSize: 18, color: Colors.white)),
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
