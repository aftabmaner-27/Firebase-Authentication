import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_flutter_flow/View/auth_view.dart';
import '../Controller/auth_controller.dart';

class RegisterView extends StatelessWidget {
  final AuthController authController = Get.put(AuthController());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get screen dimensions
          var screenWidth = constraints.maxWidth;
          var screenHeight = constraints.maxHeight;

          // Adjust size based on screen width for responsiveness
          bool isSmallScreen = screenWidth < 600;
          bool isMediumScreen = screenWidth >= 600 && screenWidth < 1024;

          double containerWidth = isSmallScreen
              ? screenWidth * 0.9
              : isMediumScreen
              ? screenWidth * 0.6
              : screenWidth * 0.5;

          double containerHeight = isSmallScreen
              ? screenHeight * 0.7
              : screenHeight * 0.65;

          double fontSizeTitle = isSmallScreen ? 25 : 30;
          double fontSizeButton = isSmallScreen ? 18 : 20;
          double padding = isSmallScreen ? 15 : 20;

          return Stack(
            children: [
              // Background image or gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.blue.shade500, Colors.purple.shade900],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
              // Glassmorphism container
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Container(
                      width: containerWidth,
                      height: containerHeight,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2), // Semi-transparent white
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1.5,
                          color: Colors.white.withOpacity(0.3), // Border color for glass effect
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(padding),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Login title
                            Text(
                              'Register Page',
                              style: TextStyle(
                                fontSize: fontSizeTitle,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 20),
                            // Email input
                            TextField(
                              controller: emailController,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.3),
                                hintText: 'Create Your Email',
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 20),
                            // Password input
                            TextField(
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.white.withOpacity(0.3),
                                hintText: 'Create Your Password',
                                hintStyle: TextStyle(color: Colors.white),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                              style: TextStyle(color: Colors.white),
                            ),
                            SizedBox(height: 20),
                            // Login button
                            ElevatedButton(
                              onPressed: () {
                                authController.registerWithEmail(
                                  emailController.text.trim(),
                                  passwordController.text.trim(),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white.withOpacity(0.8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: isSmallScreen ? 30 : 40,
                                ),
                              ),
                              child: Text(
                                'Register',
                                style: TextStyle(
                                  color: Colors.blue.shade800,
                                  fontSize: fontSizeButton,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 20),
                            InkWell(
                              onTap: () {
                                // Navigate to the registration page (Replace `RegisterPage` with your actual page class)
                                Get.to(AuthView()); // Assuming you are using GetX for navigation
                              },
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  'Already existing Account ? Login',
                                  style: TextStyle(
                                    fontSize:15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
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
            ],
          );
        },
      ),
    );
  }
}
