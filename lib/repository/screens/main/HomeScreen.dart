import 'package:flutter/material.dart';
import 'package:madeq/domain/constants/appprefs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: AppPrefs.getAccessToken(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final accessToken = snapshot.data ?? "No token found";

          return Center(
            child: Text("Access Token: $accessToken"),
          );
        },
      ),
    );
  }
}
