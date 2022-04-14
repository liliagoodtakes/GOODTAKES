import 'package:com_goodtakes/model/transaction/transaction_detail.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/interaction/alert/basket_detail_dialog.dart';
import 'package:flutter/material.dart';

class TransactionAmountSummary extends StatelessWidget {
  final TransactionDetail detail;
  const TransactionAmountSummary({required this.detail, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: StandardSize.generalViewPadding,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: StandardColor.white),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(children: [
            Text(detail.subCount.toString() + "x",
                style: StandardTextStyle.black14R),
            const SizedBox(width: 10),
            Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width - 120),
                child: Text(detail.basketName,
                    style: StandardTextStyle.black14SB,
                    overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: () {
                showBasketDetailDialog(
                    context: context, basketDetail: detail.basketDescription);
              },
              child: Container(
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: const Icon(Icons.info_outline,
                      color: StandardColor.grey, size: 20)),
            ),
            const Expanded(child: SizedBox()),
            Text(
                StandardInappContentType
                    .generalAmountWithCurrencyStatement.label
                    .replaceFirst(valueReplacementTag,
                        detail.subAmount.ceil().toString()),
                style: StandardTextStyle.black14R)
          ]),
          Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              height: 1,
              color: StandardColor.lightGrey),
          Row(children: [
            Expanded(
                child: Text(StandardInappContentType.orderSubAmountLabel.label,
                    style: StandardTextStyle.black14R)),
            Text(
                StandardInappContentType
                    .generalAmountWithCurrencyStatement.label
                    .replaceFirst(valueReplacementTag,
                        detail.subAmount.ceil().toString()),
                style: StandardTextStyle.black14R)
          ]),
          const SizedBox(height: 5),
          Row(children: [
            Expanded(
                child: Text(StandardInappContentType.orderDiscountLabel.label,
                    style: StandardTextStyle.black14R)),
            Container(
                height: 24,
                padding: const EdgeInsets.only(left: 5, right: 5),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: StandardColor.yellow),
                child: Text(
                    StandardInappContentType
                        .generalAmountWithCurrencyStatement.label
                        .replaceFirst(valueReplacementTag,
                            "-" + detail.subDiscount.ceil().toString()),
                    style: StandardTextStyle.black14SB))
          ]),
          Column(children: [
            Container(
              margin: const EdgeInsets.only(top: 15, bottom: 15),
              height: 1,
              color: StandardColor.lightGrey,
            ),
            Row(children: [
              Expanded(
                  child: Text(
                      StandardInappContentType.orderTotalAmountLabel.label,
                      style: StandardTextStyle.black14SB)),
              Text(
                  StandardInappContentType
                      .generalAmountWithCurrencyStatement.label
                      .replaceFirst(valueReplacementTag,
                          detail.subPayable.ceil().toString()),
                  style: StandardTextStyle.black14SB)
            ])
          ])
        ]));
  }
}
