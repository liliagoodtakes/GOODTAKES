import 'package:com_goodtakes/model/base/transaction_summary/transaction_summary.dart';
import 'package:com_goodtakes/model/transaction/transaction.dart' as gt;
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/double_layer_display_icon.dart';
import 'package:flutter/material.dart';

class TransactionAchievementSummary extends StatelessWidget {
  final TransactionSummary summary;
  const TransactionAchievementSummary({required this.summary, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    const colMainAxisSize = MainAxisSize.min;
    const colCrossAligment = CrossAxisAlignment.center;
    const iconBackgroundColor = StandardColor.yellow;
    return Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
            color: StandardColor.white,
            boxShadow: [
              BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.05), offset: Offset(0, 3))
            ],
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        padding: StandardSize.generalViewPadding
            .copyWith(left: 28, right: 28, bottom: 12),
        margin: const EdgeInsets.only(top: 12),
        child: SafeArea(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
              Column(
                  crossAxisAlignment: colCrossAligment,
                  mainAxisSize: colMainAxisSize,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const DoubleLayerDisplayIcon(
                          backgroundColor: iconBackgroundColor,
                          child: ImageIcon(
                            AssetImage(StandardAssetImage.iconSpoonAndFork),
                            size: 20,
                          )),
                      const SizedBox(width: 2),
                      Text(StandardInappContentType.generalFoodSavedTitle.label,
                          style: StandardTextStyle.yellow14SB)
                    ]),
                    Text(
                        StandardInappContentType.generalFoodSavedValue.label
                            .replaceFirst(valueReplacementTag,
                                summary.foodSaved.toString()),
                        style: StandardTextStyle.black18B)
                  ]),
              Column(
                  crossAxisAlignment: colCrossAligment,
                  mainAxisSize: colMainAxisSize,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const DoubleLayerDisplayIcon(
                          backgroundColor: iconBackgroundColor,
                          child: ImageIcon(
                            AssetImage(StandardAssetImage.iconDollorCircle),
                            size: 20,
                          )),
                      const SizedBox(width: 2),
                      Text(
                          StandardInappContentType.generalMoneySavedTitle.label,
                          style: StandardTextStyle.yellow14SB)
                    ]),
                    Text(
                        StandardInappContentType.generalMoneySavedValue.label
                            .replaceFirst(valueReplacementTag,
                                summary.moneySaved.ceil().toString()),
                        style: StandardTextStyle.black18B)
                  ]),
              Column(
                  crossAxisAlignment: colCrossAligment,
                  mainAxisSize: colMainAxisSize,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      const DoubleLayerDisplayIcon(
                          backgroundColor: iconBackgroundColor,
                          child: ImageIcon(
                            AssetImage(StandardAssetImage.iconLeaf),
                            size: 20,
                          )),
                      const SizedBox(width: 2),
                      Text(
                          StandardInappContentType
                              .generalCarbonReductionTitle.label,
                          style: StandardTextStyle.yellow14SB)
                    ]),
                    Text(
                        StandardInappContentType
                            .generalCarbonReductionValue.label
                            .replaceFirst(valueReplacementTag,
                                summary.carbonEmissionReduction.toString()),
                        style: StandardTextStyle.black18B)
                  ])
            ])));
  }
}
