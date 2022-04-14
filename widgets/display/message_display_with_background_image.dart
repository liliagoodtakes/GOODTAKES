import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class MessageDisplayWithBackgroundImage extends StatelessWidget {
  final String imagePath;
  final String title;
  final String content;
  final Alignment messageAlignment;
  const MessageDisplayWithBackgroundImage(
      {required this.title,
      required this.content,
      required this.imagePath,
      this.messageAlignment = Alignment.topLeft,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                alignment: Alignment.topCenter,
                image: AssetImage(imagePath),
                fit: BoxFit.fitWidth)),
        child: Container(
          margin: StandardSize.generalChipBorderPadding.copyWith(
              // top: MediaQuery.of(context).size.height *
              //     StandardSize.onBoardingMessageAlignmentTopRatio,
              // bottom:
              ),
          alignment: messageAlignment,
          child: RichText(
              text: TextSpan(children: [
            TextSpan(text: title, style: StandardTextStyle.black22SB),
            TextSpan(text: "\n" + content, style: StandardTextStyle.black14R),
          ])),
        ));
  }
}
