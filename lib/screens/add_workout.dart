import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:image_picker/image_picker.dart';
import '../../service/api_workout_service.dart';
import '../../ads/banner.dart';
import '../ads/intersitial.dart';

class AddWorkoutForm extends StatefulWidget {
  const AddWorkoutForm({super.key});

  @override
  _AddWorkoutFormState createState() => _AddWorkoutFormState();
}

class _AddWorkoutFormState extends State<AddWorkoutForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final DateTime _selectedDate = DateTime.now();
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();
  bool _isLoading = false;
  late BannerAdManager _bannerAdManager;
  BannerAd? _largeBannerAd;
  late InterstitialAdManager _interstitialAdManager;

  @override
  void initState() {
    super.initState();
    _bannerAdManager = BannerAdManager();
    _interstitialAdManager = InterstitialAdManager();
    _loadLargeBannerAd();
    _loadInterstitialAd();
  }

  Future<void> _loadLargeBannerAd() async {
    _bannerAdManager.loadLargeBannerAd(() {
      setState(() {
        _largeBannerAd = _bannerAdManager.largeBannerAd;
        print("Large Banner Ad loaded successfully.");
      });
    }, (error) {
      print("Failed to load large banner ad: ${error.message}");
    });
  }

  Future<void> _loadInterstitialAd() async {
    _interstitialAdManager.loadInterstitialAd(() {
      print("Interstitial Ad loaded successfully.");
    }, (error) {
      print("Failed to load interstitial ad: ${error.message}");
    });
  }

  Future<void> _pickImageFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  Future<void> _addWorkout() async {
    if (_formKey.currentState!.validate()) {
      if (_imageFile == null) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please take a selfie before submitting.')));
        return;
      }

      setState(() {
        _isLoading = true;
      });

      try {
        final success = await ApiWorkoutService().addWorkout(
          _titleController.text,
          _selectedDate,
          _imageFile!,
        );

        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Workout Added')));
          _interstitialAdManager.showInterstitialAd();
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to add workout')));
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _bannerAdManager.dispose();
    _interstitialAdManager.dispose();
    _titleController.dispose(); // Dispose of the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Today's Workout", style: TextStyle(color: Colors.white, fontSize: 25)),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Today's Date: ${"${_selectedDate.toLocal()}".split(' ')[0]}",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 40),
                    Form(
                      key: _formKey,
                      child: TextFormField(
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
                    const SizedBox(height: 20),
                    if (_largeBannerAd != null)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: SizedBox(
                            height: _largeBannerAd!.size.height.toDouble(),
                            width: _largeBannerAd!.size.width.toDouble(),
                            child: AdWidget(ad: _largeBannerAd!),
                          ),
                        ),
                      ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
          // Circular Progress Indicator
          if (_isLoading)
            Container(
              color: Colors.black54, // Background color to dim the rest of the screen
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).colorScheme.primary),
                ),
              ),
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _isLoading ? null : _addWorkout, // Disable button when loading
        label: const Text('Add Workout'),
        icon: const Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
