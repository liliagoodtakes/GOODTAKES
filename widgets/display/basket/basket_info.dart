import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/service/database/database_r.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class BasketInfo extends StatelessWidget {
  final Basket basket;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final int selected;
  const BasketInfo(
      {required this.onAdd,
      required this.selected,
      required this.onRemove,
      required this.basket,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    String pickUpRange =
        StandardInappContentType.generalPickUpTimeRangeStatement.label;

    pickUpRange = pickUpRange.replaceFirst(valueReplacementTag,
        basket.pickUpStartTimeOfDay?.formatAsTwoDigit() ?? "");
    pickUpRange = pickUpRange.replaceFirst(valueReplacementTag,
        basket.pickUpCloseTimeOfDay?.formatAsTwoDigit() ?? "");

    return Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
            color: StandardColor.white,
            borderRadius: BorderRadius.circular(10)),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
                Expanded(
                    child: Text(
                  basket.name,
                  style: StandardTextStyle.black18B,
                  overflow: TextOverflow.ellipsis,
                )),
                Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                          StandardInappContentType
                              .basketInfoOriPriceStatement.label
                              .replaceAll(valueReplacementTag,
                                  basket.originalPrice.ceil().toString()),
                          style: StandardTextStyle.darkGrey14C
                              .copyWith(height: 1.2)),
                      Text(
                          StandardInappContentType
                              .basketInfoPromotePriceStatement.label
                              .replaceAll(valueReplacementTag,
                                  basket.promotionPrice.ceil().toString()),
                          style:
                              StandardTextStyle.green16B.copyWith(height: 1.2))
                    ])
              ]),
              const SizedBox(height: 5),
              Container(
                height: 1,
                color: StandardColor.lightGrey,
              ),
              const SizedBox(
                height: StandardSize.generalInlineSeperatorSize,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    width: 100,
                    height: 100,
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(15)),
                    clipBehavior: Clip.antiAlias,
                    child: Image(
                        image: NetworkImage(basket.image), fit: BoxFit.cover)),
                const SizedBox(width: 7),
                Expanded(
                    child: Text(basket.description,
                        style: StandardTextStyle.darkGrey12R))
              ]),
              const SizedBox(
                height: StandardSize.generalInlineSeperatorSize,
              ),
              RichText(
                  textAlign: TextAlign.left,
                  text: TextSpan(style: StandardTextStyle.white14SB, children: [
                    WidgetSpan(
                        child: Container(
                            height: 27,
                            padding: const EdgeInsets.only(left: 11, right: 11),
                            margin: const EdgeInsets.only(right: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(3),
                                color: basket.availableStock > 0
                                    ? StandardColor.green
                                    : StandardColor.grey),
                            child:
                                Row(mainAxisSize: MainAxisSize.min, children: [
                              const ImageIcon(
                                  AssetImage(StandardAssetImage.iconShopbag),
                                  size: 20,
                                  color: StandardColor.white),
                              const SizedBox(width: 4),
                              Text(
                                StandardInappContentType
                                    .generalBasketLimitStatement.label
                                    .replaceFirst(valueReplacementTag,
                                        basket.availableStock.toString()),
                                style: StandardTextStyle.white14SB,
                              )
                            ]))),
                    TextSpan(
                        children: basket.displayTags
                            .map(
                              (e) => WidgetSpan(
                                  child: Container(
                                      height: 27,
                                      padding: const EdgeInsets.only(
                                          left: 7, right: 7),
                                      margin: const EdgeInsets.only(
                                          right: 10, top: 4),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(3),
                                          color: StandardColor.yellow),
                                      child: Text(e,
                                          style: StandardTextStyle.white14SB))),
                            )
                            .toList())
                  ])),
              const SizedBox(
                height: StandardSize.generalInlineSeperatorSize,
              ),
              Container(
                height: 1,
                width: MediaQuery.of(context).size.width,
                color: StandardColor.lightGrey,
              ),
              const SizedBox(
                height: StandardSize.generalInlineSeperatorSize,
              ),
              Row(children: [
                Expanded(
                    child:
                        Text(pickUpRange, style: StandardTextStyle.green14SB)),
                Container(
                    height: 37.5,
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: StandardColor.lightGrey),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                              style: StandardButtonStyle.countButtonStyle,
                              onPressed: onRemove,
                              child: const Icon(Icons.remove, size: 16)),
                          const SizedBox(width: 15),
                          Container(
                              width: 16,
                              alignment: Alignment.center,
                              child: Text(selected.toString(),
                                  style: StandardTextStyle.black18B)),
                          const SizedBox(width: 15),
                          ElevatedButton(
                              style: StandardButtonStyle.countButtonStyle,
                              onPressed: onAdd,
                              child: const Icon(Icons.add, size: 16))
                        ]))
              ])
            ]));
  }
}
