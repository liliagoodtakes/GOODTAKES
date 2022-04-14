import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class BasketEditorAlertStatement extends StatelessWidget {
  const BasketEditorAlertStatement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(style: StandardTextStyle.black12R, children: [
      const TextSpan(text: "*"),
      TextSpan(text: "上架時間", style: StandardTextStyle.yellow12R),
      const TextSpan(text: "至少早於"),
      TextSpan(text: "開始提取時間", style: StandardTextStyle.yellow12R),
      const TextSpan(text: "  1 小時"),
      const TextSpan(text: "\n*"),
      TextSpan(text: "提取時間", style: StandardTextStyle.yellow12R),
      const TextSpan(text: "為至少 1 小時"),
      const TextSpan(text: "\n*"),
      const TextSpan(text: "福袋只限"),
      TextSpan(text: "今日內提取", style: StandardTextStyle.yellow12R),
      const TextSpan(text: "\n*"),
      const TextSpan(text: "福袋"),
      TextSpan(text: "上架期間", style: StandardTextStyle.yellow12R),
      const TextSpan(text: "資料不能更改"),
      const TextSpan(text: "\n*"),
      const TextSpan(text: "上架後如需更改資料，須將福袋落架並修改資料後再上架"),
    ]));
  }
}
