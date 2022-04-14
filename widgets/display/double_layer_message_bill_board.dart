import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/double_layer_display_board.dart';
import 'package:com_goodtakes/widgets/display/double_layer_display_icon.dart';
import 'package:flutter/material.dart';

class DoubleLayerMessageBillBoard extends StatelessWidget {
  final String title;
  final String message;
  final Widget icon;
  const DoubleLayerMessageBillBoard(
      {required this.icon,
      required this.message,
      required this.title,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DoubleLayerDisplayBoard(
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DoubleLayerDisplayIcon(child: icon),
              Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                    Text(title, style: StandardTextStyle.white14SB),
                    Text(message, style: StandardTextStyle.black18B)
                  ])),
              const SizedBox(height: 10)
            ],
          )),
    );
  }
}
