import 'package:flutter/material.dart';
import 'package:jimbro_mobile/routes.dart';
import '../service/auth_service.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? _errorText; //TODO :: Add specific feedbacks
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double padding = size.height * 0.05;
    final double textFieldHeight = size.height * 0.07;
    final double buttonHeight = size.height * 0.08;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login", style: TextStyle(color: Colors.white, fontSize: 30)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height-200,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.all(padding),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                     Text(
                      'Login to JimBro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    SizedBox(height: padding),

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
                    SizedBox(height: padding*0.5),

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


                    if (_errorText != null)
                      Text(
                        _errorText!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    SizedBox(height:padding),
                    SizedBox(
                      height: buttonHeight,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() {
                          _errorText = null;
                          });
                          try {
                            if(await AuthService().login(
                              _emailController.text,
                              _passwordController.text) == true){
                              Navigator.pushNamedAndRemoveUntil(context, Routes.signup, (Route<dynamic> route) => false);
                            }
                            else{
                              setState(() {
                                _errorText = 'Login failed';
                              });
                            }
                          } catch (e) {
                            setState(() {
                              _errorText = 'Login failed ${e.toString()}';
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                        ),
                        child: const Text(
                          'Login',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(height: padding*0.5),

                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, Routes.signup);
                        },
                      child: Text(
                        'Create an account',
                        style: TextStyle(color: Theme.of(context).colorScheme.primary),
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
