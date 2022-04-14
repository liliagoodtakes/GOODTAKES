import 'package:flutter/material.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';

class VerifiText extends StatelessWidget {
  final String phoneNumber;
  final String title;
  final String content;

  const VerifiText(
      {required this.title,
      required this.content,
      required this.phoneNumber,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(text: title, style: StandardTextStyle.black18B),
            TextSpan(text: "\n" + content, style: StandardTextStyle.grey12R),
            TextSpan(text: phoneNumber, style: StandardTextStyle.yellow12R),
          ]),
        ));
  }
}
