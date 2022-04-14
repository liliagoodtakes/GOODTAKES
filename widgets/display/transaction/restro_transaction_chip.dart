import 'package:com_goodtakes/model/receipt/restro_receipt.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class RestroTransactionChip extends StatelessWidget {
  final RestroReceipt receipt;

  const RestroTransactionChip({required this.receipt, Key? key})
      : super(key: key);

  Widget get inlineSeprator => const SizedBox(height: 5, width: 5);
  @override
  Widget build(BuildContext context) {
    String summary = StandardInappContentType.transactionChipStatement.label;
    summary = summary.replaceFirst(
        valueReplacementTag, receipt.detail.subCount.toString());
    summary = summary.replaceFirst(
        valueReplacementTag, receipt.payable.ceil().toString());
    return Container(
        padding: StandardSize.generalChipBorderPadding,
        decoration: const BoxDecoration(
            borderRadius: StandardSize.generalChipBorderRadius,
            color: StandardColor.white),
        child: Row(children: [
          Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                Row(children: [
                  SizedBox(
                      width: 18,
                      height: 18,
                      child: Text("#",
                          style: StandardTextStyle.yellow18B,
                          textAlign: TextAlign.center)),
                  inlineSeprator,
                  Text(
                    receipt.id,
                    style: StandardTextStyle.black14SB,
                  )
                ]),
                inlineSeprator,
                Row(children: [
                  const ImageIcon(AssetImage(StandardAssetImage.iconClock),
                      color: StandardColor.yellow, size: 18),
                  inlineSeprator,
                  Text(receipt.pickupTime.generalPickUpTimeRangeStatement,
                      style: StandardTextStyle.black14R)
                ]),
                inlineSeprator,
                Text(summary, style: StandardTextStyle.grey14R)
              ])),
          const Icon(Icons.navigate_next, color: StandardColor.grey)
        ]));
  }
}
