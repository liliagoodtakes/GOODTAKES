import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class OrderHeader extends StatelessWidget {
  final String orderNumber;
  final bool completed;
  final int fixWidth;
  const OrderHeader(
      {required this.completed,
      required this.orderNumber,
      Key? key,
      this.fixWidth = 60})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(25, 10, 25, 10),
        decoration: const BoxDecoration(
            borderRadius: StandardSize.generalChipBorderRadius,
            color: StandardColor.white),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(StandardInappContentType.orderRefNumberLabel.label,
                  style: StandardTextStyle.grey12R),
              Row(children: [
                Expanded(
                    child: Text("#" + orderNumber,
                        style: StandardTextStyle.yellow18B)),
                completed
                    ? Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: StandardColor.yellow),
                        padding: const EdgeInsets.fromLTRB(14, 3, 14, 3),
                        child: Text(
                          StandardInappContentType.orderHeadinCompleted.label,
                          style: StandardTextStyle.black14SB,
                        ))
                    : Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: StandardColor.green),
                        padding: const EdgeInsets.fromLTRB(14, 3, 14, 3),
                        child: Text(
                            StandardInappContentType
                                .orderHeadinOnProgress.label,
                            style: StandardTextStyle.white14SB))
              ])
            ]));
  }
}
