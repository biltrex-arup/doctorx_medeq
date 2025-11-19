import 'package:audioplayers/audioplayers.dart' show AudioPlayer, AssetSource;
import 'package:flutter/material.dart';
import 'package:toastification/toastification.dart';

enum ToastType { success, error , warning}

class UiHelper {
  static Widget CustomImage({
    required String img,
    double? size,
  }) {
    return Image.asset(
      "assets/images/$img",
      height: size,
      width: size,
    );
  }


  static CustomText(
      {required String text,
        required Color color,
        required FontWeight fontweight,
        String? fontfamily,
        required double fontsize}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: fontsize,
          fontFamily: fontfamily ?? "regular",
          fontWeight: fontweight,
          color: color),
    );
  }
  static CustomTextField({required TextEditingController controller}){
    return Container(
      height: 40,
      width: 360,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              color: const Color(0XFFC5C5C5)
          )
      ),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
            hintText: "Search 'ice-cream'",
            prefixIcon: Image.asset("assets/images/search.png"),
            suffixIcon: Image.asset("assets/images/mic 1.png"),
            border: InputBorder.none
        ),
      ),
    );
  }

  static CustomButton(VoidCallback callback){
    return Container(
      height: 18,
      width: 30,
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: const Color(0XFF27AF34)
          ),
          borderRadius: BorderRadius.circular(4)
      ),
      child: const Center(child: Text("Add",style: TextStyle(fontSize: 8,color: Color(0XFF27AF34)),),),
    );
  }

  static final AudioPlayer _player = AudioPlayer();

  static Future<void> showToast(
      BuildContext context, {
        required ToastType type,
        required String description,
      }) async {
    // Play sound
    if (type == ToastType.error) {
      await _player.play(AssetSource('sounds/error.mp3'));
    } else if (type == ToastType.success) {
      await _player.play(AssetSource('sounds/success.mp3'));
    } else if (type == ToastType.warning) {
      await _player.play(AssetSource('sounds/success.mp3'));
    }

    // Define colors and titles
    String title = "";
    Color color = Colors.blue;

    if (type == ToastType.error) {
      title = "Error";
      color = Colors.red;
    } else if (type == ToastType.success) {
      title = "Success";
      color = Colors.green;
    } else if (type == ToastType.warning) {
      title = "Warning";
      color = Colors.orange;
    }

    // Show toast UI
    toastification.show(
      context: context,
      title: Text(title),
      description: Text(description),
      autoCloseDuration: const Duration(seconds: 4),
      icon: Icon(
        type == ToastType.error
            ? Icons.error_outline
            : type == ToastType.success
            ? Icons.check_circle_outline
            : Icons.warning_amber_rounded,
      ),
      style: ToastificationStyle.flatColored,
      primaryColor: color,
      foregroundColor: color,
    );
  }



}