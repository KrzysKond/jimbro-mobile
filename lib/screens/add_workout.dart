import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/api_workout_service.dart';

class AddWorkoutForm extends StatefulWidget {
  const AddWorkoutForm({super.key});

  @override
  _AddWorkoutFormState createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();
  XFile? _imageFile; // To store the selected image
  final ImagePicker _picker = ImagePicker(); // For selecting images

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      final success = await ApiWorkoutService().addWorkout(_titleController.text, _selectedDate, _imageFile!);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout Added')));
        Navigator.pop(context); // Navigate back after adding
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add workout')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Today's Workout", style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height - 120,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Date: ${"${_selectedDate.toLocal()}".split(' ')[0]}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 40),
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Workout Title',
                        labelStyle: TextStyle(color: Theme.of(context).colorScheme.primary),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).colorScheme.secondary),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _pickImageFromCamera,
                          icon: Icon(Icons.camera_alt, color: Colors.grey[300]),
                          label: Text(
                            "Take a Selfie!",
                            style: TextStyle(color: Colors.grey[300]),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Theme.of(context).colorScheme.primary,
                            minimumSize: const Size(200, 60),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    if (_imageFile != null)
                      Center(
                        child: Container(
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).colorScheme.secondary, width: 2),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(_imageFile!.path),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: _addWorkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text(
                        'Add Workout',
                        style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
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
