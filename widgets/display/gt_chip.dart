import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class GTChip extends StatelessWidget {
  final String message;
  final Color foregroundColor;
  final Color backgroundColor;
  final TextStyle? textStyle;
  final Widget? leading;
  final VoidCallback? onTap;

  const GTChip(
      {Key? key,
      this.onTap,
      required this.message,
      this.leading,
      this.backgroundColor = StandardColor.grey,
      this.foregroundColor = StandardColor.white,
      this.textStyle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(5)),
                color: backgroundColor),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            child: leading == null
                ? Text(message,
                    style: textStyle ??
                        StandardTextStyle.white14SB
                            .copyWith(color: foregroundColor))
                : Row(mainAxisSize: MainAxisSize.min, children: [
                    leading!,
                    const SizedBox(width: 6),
                    Text(message,
                        style: textStyle ??
                            StandardTextStyle.white14SB
                                .copyWith(color: foregroundColor))
                  ])));
  }
}
