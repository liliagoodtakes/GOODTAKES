import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class DecoratedTitle extends StatelessWidget {
  final String title;

  const DecoratedTitle({required this.title, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final logicalPx = ((StandardTextStyle.black18B.fontSize ?? 18) +
            (StandardTextStyle.black18B.letterSpacing ?? 2)) *
        title.length;
    return Stack(children: [
      Container(
          width: logicalPx,
          height: 8,
          margin: const EdgeInsets.only(left: 5, top: 16),
          decoration: const BoxDecoration(
              color: StandardColor.yellow, shape: BoxShape.rectangle)),
      Text(title, style: StandardTextStyle.black18B)
    ]);
  }
}
