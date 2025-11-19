import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madeq/domain/constants/appcolors.dart';
import 'package:madeq/domain/services/auth_service.dart';
import 'package:madeq/repository/providers/auth_provider.dart';
import 'package:madeq/repository/screens/auth/OtpScreen.dart';
import 'package:madeq/repository/screens/auth/RegisterScreen.dart';
import 'package:madeq/repository/widgets/uihelper.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:audioplayers/audioplayers.dart';

final player = AudioPlayer();
final authService = AuthService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  late final authState = Provider.of<AuthProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Blue background area
          // Blue background area
          Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.brand600,
            child: Column(
              // ← CENTER CONTENT
              children: [
                const SizedBox(height: 160),
                UiHelper.CustomImage(img: "doctor.png", size: 160),
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Biltrex",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Text(
                    "Sign in or create an account to book your doctor appointment.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // White bottom card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25),
              height: 250,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        hintText: "Enter your email",
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(100),
                            borderSide: const BorderSide(
                                color: AppColors.brand500, width: 2)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Email is required";
                        }
                        final emailRegex = RegExp(
                            r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
                        if (!emailRegex.hasMatch(value)) {
                          return "Enter a valid email address";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 25),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF003B84),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            authState.setEmail(_emailController.text);
                            try {
                              final result = await authService
                                  .checkEmail(_emailController.text);
                              if (result["status"] == true) {
                                UiHelper.showToast(
                                  context,
                                  type: ToastType.success,
                                  description: result["message"],
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const OtpScreen()),
                                );
                              } else {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const RegisterScreen()),
                                );
                                UiHelper.showToast(
                                  context,
                                  type: ToastType.warning,
                                  description: result["message"],
                                );
                              }
                            } catch (e) {
                              print("Error: $e");

                              String message = e.toString();

                              // Try to extract JSON from the error
                              try {
                                // Remove exception prefix: "BadRequestException: Invalid Request:"
                                final cleaned =
                                    message.replaceAll(RegExp(r'^[^{]*'), '');
                                final data = jsonDecode(cleaned);

                                if (data is Map && data.containsKey("status")) {
                                  if (data["status"] == false) {
                                    message = data["message"] ??
                                        "Something went wrong";
                                  }
                                }
                              } catch (_) {
                                // Not JSON, ignore
                              }

                              UiHelper.showToast(
                                context,
                                type: ToastType.error,
                                description: message,
                              );
                            }
                          }
                        },
                        child: const Text(
                          "LOGIN / REGISTER",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
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
        ],
      ),
    );
  }
}
