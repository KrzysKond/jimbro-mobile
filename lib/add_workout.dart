import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images from the gallery or camera

class AddWorkoutForm extends StatefulWidget {
  const AddWorkoutForm({super.key});

  @override
  _AddWorkoutFormState createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final DateTime _selectedDate = DateTime.now(); // Automatically set to today's date
  XFile? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker(); // For selecting images

  // Function to select image from the camera
  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Today's Workout", style: TextStyle(color: Colors.white, fontSize: 25)),
        backgroundColor: Colors.purpleAccent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height-120,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Display the current date
                    Text(
                      "Today's Date:  ${"${_selectedDate.toLocal()}".split(' ')[0]}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 40),

                    // Workout title input
                    TextFormField(
                      controller: _titleController,
                      decoration: const InputDecoration(
                        labelText: 'Workout Title',
                        labelStyle: TextStyle(color: Colors.purpleAccent),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purpleAccent),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.purple),
                        ),
                      ),
                      style: const TextStyle(color: Colors.white70),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 40),

                    // Image picker buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImageFromCamera,
                          icon: const IconTheme(
                            data: IconThemeData(size: 24.0), // Adjust the icon size
                            child: Icon(Icons.camera_alt),
                          ),
                          label: const Text(
                            "Take a Selfie!",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold, // Make the label bold
                              fontSize: 16, // Adjust font size for better readability
                              letterSpacing: 1.2, // Increase space between letters
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purpleAccent, // Button color
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20), // Padding for more button space
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8), // Rounded corners for button
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Display selected image
                    if (_imageFile != null)
                      Center(
                        child: Container(

                          height: 300, // Set a fixed height for the image container
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.purpleAccent, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit.cover, // Ensures the image fits inside the box without overflow
                            ),
                          ),
                        ),
                      ),

                    const Spacer(),

                    // Submit button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Handle form submission
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Workout Added')),
                          );
                          // You can add functionality to save the form data here
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purpleAccent,
                        minimumSize: const Size(double.infinity, 50), // Full width button// More padding for a larger button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8), // Rounded corners for the submit button
                        ),
                      ),
                      child: const Text(
                        'Add Workout',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold, // Bold the text for better emphasis
                          letterSpacing: 1.2, // Increase space between letters
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
