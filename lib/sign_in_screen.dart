import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; 
import 'auth_service.dart';
import 'home_screen.dart';
import 'forgot_password_screen.dart';



class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool isSignIn = true;
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  bool termsAccepted = false;
  bool _obscureText = true;

  void _toggleTerms() {
    setState(() {
      termsAccepted = !termsAccepted;
    });
  }

  void _updateEmail(String val) {
    setState(() {
      _email = val;
    });
  }

  void _updatePassword(String val) {
    setState(() {
      _password = val;
    });
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0E8059),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/Grocery.png', height: 150),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFF5F5DC),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignIn = true;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: isSignIn ? Colors.white : Colors.grey[200],
                              ),
                              child: Center(
                                child: Text(
                                  'Sign in',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignIn ? Colors.black : Colors.grey,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isSignIn = false;
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.35,
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: isSignIn ? Colors.grey[200] : Colors.white,
                              ),
                              child: Center(
                                child: Text(
                                  'Register',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: isSignIn ? Colors.grey : Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      isSignIn ? SignInForm(formKey: _formKey, updateEmail: _updateEmail, updatePassword: _updatePassword, obscureText: _obscureText, togglePasswordVisibility: _togglePasswordVisibility) : RegisterForm(formKey: _formKey, updateEmail: _updateEmail, updatePassword: _updatePassword, termsAccepted: termsAccepted, toggleTerms: _toggleTerms, password: _password, obscureText: _obscureText, togglePasswordVisibility: _togglePasswordVisibility),
                      SizedBox(height: 20),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF0E8059),
                          foregroundColor: Colors.white,
                          minimumSize: Size(double.infinity, 50),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            if (isSignIn) {
                              User? user = await _auth.signInWithEmailAndPassword(_email, _password);
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => HomeScreen(message: 'Login Successful')),
                                );
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Login Failed')),
                                );
                              }
                            } else {
                              if (termsAccepted) {
                                User? user = await _auth.registerWithEmailAndPassword(_email, _password);
                                if (user != null) {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (context) => HomeScreen(message: 'Registration Successful')),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Registration Failed')),
                                  );
                                }
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Please accept the terms and privacy policy')),
                                );
                              }
                            }
                          }
                        },
                        icon: Icon(Icons.login),
                        label: Text(isSignIn ? 'Sign in' : 'Register'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
                          );
                        },
                        child: Text(
                          isSignIn ? 'Forgot password?' : '',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
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


// signin form

class SignInForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) updateEmail;
  final Function(String) updatePassword;
  final bool obscureText;
  final Function() togglePasswordVisibility;

  SignInForm({required this.formKey, required this.updateEmail, required this.updatePassword, required this.obscureText, required this.togglePasswordVisibility});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email address',
              border: OutlineInputBorder(),
            ),
            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            onChanged: updateEmail,
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: 'Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: togglePasswordVisibility,
              ),
            ),
            validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
            onChanged: updatePassword,
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }
}


// Registeration form

class RegisterForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final Function(String) updateEmail;
  final Function(String) updatePassword;
  final bool termsAccepted;
  final Function() toggleTerms;
  final String password;
  final bool obscureText;
  final Function() togglePasswordVisibility;

  RegisterForm({required this.formKey, required this.updateEmail, required this.updatePassword, required this.termsAccepted, required this.toggleTerms, required this.password, required this.obscureText, required this.togglePasswordVisibility});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          SizedBox(height: 10),
          TextFormField(
            decoration: InputDecoration(
              labelText: 'Email address',
              border: OutlineInputBorder(),
            ),
            validator: (val) => val!.isEmpty ? 'Enter an email' : null,
            onChanged: updateEmail,
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: 'Create Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: togglePasswordVisibility,
              ),
            ),
            validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
            onChanged: updatePassword,
          ),
          SizedBox(height: 10),
          TextFormField(
            obscureText: obscureText,
            decoration: InputDecoration(
              labelText: 'Confirm Password',
              border: OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                onPressed: togglePasswordVisibility,
              ),
            ),
            validator: (val) => val != password ? 'Passwords do not match' : null,
          ),
          SizedBox(height: 10),
          Row(
            children: [
              Checkbox(
                value: termsAccepted,
                onChanged: (value) {
                  toggleTerms();
                },
              ),
              Expanded(child: Text('I accept the terms and privacy policy')),
            ],
          ),
        ],
      ),
    );
  }
}