import 'package:com_goodtakes/model/receipt/user_receipt.dart';
import 'package:com_goodtakes/model/restro/restro_extension.dart';
import 'package:com_goodtakes/model/transaction/transaction.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/service/database/database_r.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class MyTransactionChip extends StatelessWidget {
  final UserReceipt receipt;

  const MyTransactionChip({required this.receipt, Key? key}) : super(key: key);

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
                  const ImageIcon(AssetImage(StandardAssetImage.iconShop),
                      color: StandardColor.yellow, size: 18),
                  inlineSeprator,
                  SizedBox(
                      height: 22,
                      child: Text(receipt.restroName,
                          style: StandardTextStyle.black14SB))
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
