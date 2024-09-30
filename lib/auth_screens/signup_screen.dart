import 'package:flutter/material.dart';
import 'package:jimbro_mobile/service/auth_service.dart';

import '../routes.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  String? _errorText;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.height * 0.05;
    final double textFieldHeight = size.height * 0.07;
    final double buttonHeight = size.height * 0.08;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 30)),
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: SizedBox(
                height: MediaQuery.of(context).size.height - 150,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                       Text(
                          'Create a New Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: padding),

                        _buildTextField(_nameController, 'Name', TextInputType.name),
                        SizedBox(height: padding * 0.3),
                        _buildTextField(_emailController, 'Email', TextInputType.emailAddress),
                        SizedBox(height: padding * 0.3),
                        _buildTextField(_passwordController, 'Password', TextInputType.visiblePassword, obscureText: true),
                        SizedBox(height: padding * 0.3),
                        _buildTextField(_confirmPasswordController, 'Confirm Password', TextInputType.visiblePassword, obscureText: true),

                        if (_errorText != null)
                          Text(
                            _errorText!,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                        SizedBox(height: padding),

                        SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: () async {
                              try {
                                if (await AuthService().signUp(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                ) == true) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Successfully created the account!')),
                                  );
                                  Navigator.pushReplacementNamed(context, Routes.login);
                                } else {
                                  setState(() {
                                    _errorText = 'Signup failed';
                                  });
                                }
                              } catch (e) {
                                print(e);
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).colorScheme.primary,
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: padding * 0.3),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, Routes.login);
                          },
                          child: const Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Colors.purpleAccent),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType keyboardType, {bool obscureText = false}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: const OutlineInputBorder(),
          filled: true,
          fillColor: Colors.black54,
        ),
        style: const TextStyle(color: Colors.white),
        keyboardType: keyboardType,
        obscureText: obscureText,
      ),
    );
  }
}
