import 'package:flutter/material.dart';
import 'package:madeq/repository/providers/auth_provider.dart';
import 'package:provider/provider.dart';
import 'package:madeq/repository/screens/splash/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splashscreen(),
      ),
    );
  }
}

