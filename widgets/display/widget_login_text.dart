import 'package:flutter/material.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';

class LoginText extends StatelessWidget {
  final String title;
  final String content;

  const LoginText({required this.title, required this.content, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(text: title, style: StandardTextStyle.black18B),
            TextSpan(text: "\n" + content, style: StandardTextStyle.grey12R),
          ]),
        ));
  }
}
