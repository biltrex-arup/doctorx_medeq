import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:madeq/domain/constants/appcolors.dart';
import 'package:madeq/repository/providers/auth_provider.dart' show AuthProvider;
import 'package:madeq/repository/screens/auth/LoginScreen.dart';
import 'package:madeq/repository/screens/auth/OtpScreen.dart';
import 'package:madeq/repository/widgets/uihelper.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  late final authState = Provider.of<AuthProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top blue area
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFF003B84),
            child: Column(
              children: [
                const SizedBox(height: 160),
                UiHelper.CustomImage(img: "doctor.png", size: 160),
                const SizedBox(height: 20),
                const Text(
                  "Create Your Account",
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
                    "Register to start booking doctor appointments easily.",
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

          // Bottom form card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25),
              height: 330,
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

                    const SizedBox(height: 20),

                    // NAME FIELD
                    TextFormField(
                      controller: _nameController,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: "Enter your full name",
                        prefixIcon: const Icon(Icons.person_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: AppColors.brand500,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Name is required";
                        }

                        final nameRegex = RegExp(r"^[a-zA-Z ]+$");
                        if (!nameRegex.hasMatch(value)) {
                          return "Name can only contain letters";
                        }

                        return null;
                      },
                    ),


                    const SizedBox(height: 20),

                    /// PHONE NUMBER FIELD
                    TextFormField(
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        hintText: "Enter your phone number",
                        prefixIcon: const Icon(Icons.phone_android_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(100),
                          borderSide: const BorderSide(
                            color: AppColors.brand500,
                            width: 2,
                          ),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Phone number is required";
                        }

                        final phoneRegex = RegExp(r"^[0-9]{10}$");
                        if (!phoneRegex.hasMatch(value)) {
                          return "Enter a valid 10-digit phone number";
                        }

                        return null;
                      },
                    ),


                    const SizedBox(height: 25),

                    /// BUTTON
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
                            try {
                              final result = await authService.register(
                                  _nameController.text,
                                  authState.email, _phoneController.text);
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
                          "REGISTER",
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
