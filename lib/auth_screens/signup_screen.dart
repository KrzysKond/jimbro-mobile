import 'package:flutter/material.dart';
import 'package:jimbro_mobile/service/auth_service.dart';

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
        title: const Text("Sign Up"),
        backgroundColor: Colors.purpleAccent,
        centerTitle: true,
      ),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height-150,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: EdgeInsets.all(padding),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const Text(
                          'Create a New Account',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.purpleAccent,
                          ),
                        ),
                        SizedBox(height: padding),

                        SizedBox(
                          height: textFieldHeight,
                          child: TextField(
                            controller: _nameController,
                            decoration: const InputDecoration(
                              labelText: 'Name',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.black54,
                            ),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.name,
                          ),
                        ),
                        SizedBox(height: padding*0.3),

                        SizedBox(
                          height: textFieldHeight,
                          child: TextField(
                            controller: _emailController,
                            decoration: const InputDecoration(
                              labelText: 'Email',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.black54,
                            ),
                            style: const TextStyle(color: Colors.white),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),
                        SizedBox(height: padding*0.3),

                        SizedBox(
                          height: textFieldHeight,
                          child: TextField(
                            controller: _passwordController,
                            decoration: const InputDecoration(
                              labelText: 'Password',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.black54,
                            ),
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                          ),
                        ),
                        SizedBox(height: padding*0.3),

                        SizedBox(
                          height: textFieldHeight,
                          child: TextField(
                            controller: _confirmPasswordController,
                            decoration: const InputDecoration(
                              labelText: 'Confirm Password',
                              labelStyle: TextStyle(color: Colors.white70),
                              border: OutlineInputBorder(),
                              filled: true,
                              fillColor: Colors.black54,
                            ),
                            style: const TextStyle(color: Colors.white),
                            obscureText: true,
                          ),
                        ),
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
                                if(await AuthService().signUp(
                                  _nameController.text,
                                  _emailController.text,
                                  _passwordController.text,
                                ) == true){
                                  Navigator.pushReplacementNamed(context, '/login');
                                }else{
                                  setState(() {
                                  _errorText = 'Signup failed';
                                  });
                                }
                              }
                              catch(e){
                                print(e);
                              }
                           },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.purpleAccent,
                            ),
                            child: const Text(
                              'Sign Up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                        SizedBox(height: padding*0.3),

                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/login');
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
}
