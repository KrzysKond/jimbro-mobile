import 'package:flutter/material.dart';
import 'package:jimbro_mobile/service/auth_service.dart';
import 'package:url_launcher/url_launcher.dart';
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
  bool _isPrivacyPolicyAccepted = false;
  final String _privacyPolicyUrl = 'https://privacy-policy-jimbro.tiiny.site/';

  void _launchPrivacyPolicy() async {
    final Uri privacyPolicyUri = Uri.parse(_privacyPolicyUrl);

    if (await canLaunchUrl(privacyPolicyUri)) {
      await launchUrl(privacyPolicyUri);
    } else {
      throw 'Could not launch $_privacyPolicyUrl';
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.height * 0.05;
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
                height: MediaQuery.of(context).size.height - 100,
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
                        SizedBox(height: padding * 0.3),

                        Theme(
                          data: Theme.of(context).copyWith(
                            checkboxTheme: CheckboxThemeData(
                              fillColor: WidgetStateProperty.all(Colors.white),
                              checkColor: WidgetStateProperty.all(Colors.black),
                              side: const BorderSide(color: Colors.white, width: 2),
                            ),
                          ),
                          child: CheckboxListTile(
                            title: const Text(
                              "I accept the privacy policy",
                              style: TextStyle(color: Colors.white70),
                            ),
                            value: _isPrivacyPolicyAccepted,
                            onChanged: (bool? value) {
                              setState(() {
                                _isPrivacyPolicyAccepted = value ?? false;
                              });
                            },
                            controlAffinity: ListTileControlAffinity.leading,
                            activeColor: Theme.of(context).colorScheme.primary,
                            checkColor: Colors.white,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: TextButton(
                            onPressed: _launchPrivacyPolicy,
                            child: const Text(
                              "Read privacy policy here",
                              style: TextStyle(color: Colors.blue), // Style the link
                            ),
                          ),
                        ),

                        SizedBox(
                          height: buttonHeight,
                          child: ElevatedButton(
                            onPressed: _isPrivacyPolicyAccepted ? _signUp : null,
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
                          child: Text(
                            'Already have an account? Login',
                            style: TextStyle(color: Theme.of(context).primaryColor),
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

  Future<void> _signUp() async {
    try {
      if (await AuthService().signUp(
        _nameController.text,
        _emailController.text,
        _passwordController.text,
      )) {
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
  }

  Widget _buildTextField(TextEditingController controller, String label, TextInputType keyboardType, {bool obscureText = false}) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white70, width: 2),
          ),
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
