import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';  // Import the MainMenu from main.dart

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String username = ''; // To hold username input
  String password = ''; // To hold password input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.lightBlue],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.lock_outline,
                      size: 100,
                      color: Colors.white,
                    ),
                    SizedBox(height: 20),

                    // Title
                    Text(
                      'Welcome Back!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Please enter your username and password to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white70,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 40),

                    // Username Text Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          onChanged: (value) {
                            username = value; // Capture username input
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Username',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),

                    // Password Text Field
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 8.0,
                            spreadRadius: 1.0,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: TextField(
                          onChanged: (value) {
                            password = value; // Capture password input
                          },
                          obscureText: true, // Hide password input
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Enter Password',
                            hintStyle: TextStyle(color: Colors.black38),
                          ),
                          style: TextStyle(color: Colors.black87),
                        ),
                      ),
                    ),
                    SizedBox(height: 30),

                    // Login Button
                    ElevatedButton(
                      onPressed: () async {
                        // For now, the password field is not being validated or used further
                        if (username.isNotEmpty && password.isNotEmpty) {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.setString('username', username);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => MainMenu(username: username),
                            ),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        'LOGIN',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
