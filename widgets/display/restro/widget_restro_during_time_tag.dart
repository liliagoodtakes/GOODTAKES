import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class RestroDuringTimeTag extends StatelessWidget {
  final String text;
  final TimeOfDay start;
  final TimeOfDay close;

  const RestroDuringTimeTag(
      {required this.close,
      required this.start,
      this.text = "今日 $valueReplacementTag - $valueReplacementTag 提取",
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String _text = text;
    _text = _text.replaceFirst(valueReplacementTag, start.formatAsTwoDigit());
    _text = _text.replaceFirst(valueReplacementTag, close.formatAsTwoDigit());
    return Container(
      height: 28,
      padding: const EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5), color: StandardColor.green),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const ImageIcon(
            AssetImage(StandardAssetImage.iconClock),
            color: StandardColor.white,
            size: 16,
          ),
          const SizedBox(width: 5),
          Text(
            _text,
            style: StandardTextStyle.white14SB,
          )
        ],
      ),
    );
  }
}
