import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:madeq/domain/constants/appcolors.dart';
import 'package:madeq/domain/constants/appprefs.dart';
import 'package:madeq/repository/providers/auth_provider.dart';
import 'package:madeq/repository/screens/auth/LoginScreen.dart';
import 'package:madeq/repository/screens/main/HomeScreen.dart';
import 'package:madeq/repository/widgets/uihelper.dart'
    show UiHelper, ToastType;
import 'package:provider/provider.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();
  late final authState = Provider.of<AuthProvider>(context, listen: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Top blue section
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
                  "Enter OTP",
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
                    "We have sent a 6-digit verification code to your phone number.",
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

          // Bottom white card section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.all(25),
              height: 300,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(50)),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 20),

                    // ***** SINGLE OTP FIELD *****
                    TextFormField(
                      controller: _otpController,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        counterText: "",
                        hintText: "Enter 6-digit OTP",
                        prefixIcon: const Icon(Icons.numbers_outlined),
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
                          return "OTP is required";
                        }

                        final otpRegex = RegExp(r"^[0-9]{6}$");
                        if (!otpRegex.hasMatch(value)) {
                          return "Enter a valid 6-digit OTP";
                        }

                        return null;
                      },
                    ),

                    const SizedBox(height: 25),

                    // ***** VERIFY OTP BUTTON *****
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
                            print(authState.email);
                            try {
                              final result = await authService.vefiyEmail(
                                  authState.email, _otpController.text);
                              if (result["status"] == true) {
                                await AppPrefs.saveAccessToken(
                                    result["access_token"]);
                                UiHelper.showToast(
                                  context,
                                  type: ToastType.success,
                                  description: result["message"],
                                );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const HomeScreen()),
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
                          "VERIFY OTP",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    // ***** RESEND OTP BUTTON *****
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        UiHelper.CustomText(text: "OTP Not Received?", color: Colors.black, fontweight: FontWeight.normal, fontsize: 15),
                        TextButton(
                          onPressed: () async {
                            try {
                              final result = await authService.resendOtp(
                                  authState.email);
                              if (result["status"] == true) {
                                UiHelper.showToast(
                                  context,
                                  type: ToastType.success,
                                  description: result["message"],
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
                          },
                          child: const Text(
                            "Resend OTP",
                            style: TextStyle(
                              color: Color(0xFF003B84),
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
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
