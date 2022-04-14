import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:flutter/material.dart';

class TextFormFieldSuffix extends StatelessWidget {
  final TextEditingController controller;

  const TextFormFieldSuffix({required this.controller, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          debugPrint("TextFormFieldSuffix click");
          controller.clear();
        },
        child: Container(
            width: 13,
            height: 13,
            margin: const EdgeInsets.only(right: 10),
            decoration: const BoxDecoration(
                shape: BoxShape.circle, color: StandardColor.red),
            child: const Icon(
              Icons.close_rounded,
              color: Colors.white,
              size: 12,
            )));
  }
}
