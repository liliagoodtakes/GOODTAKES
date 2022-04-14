import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/basket/basket_extension.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/basket_editor_view/basket_editor_view.dart';
import 'package:com_goodtakes/widgets/display/gt_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class MyRestroBasketChip extends StatelessWidget {
  final Basket basket;
  const MyRestroBasketChip({required this.basket, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => BasketEditorView(basket: basket)));
        },
        child: Container(
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: StandardSize.generalChipBorderRadius),
            alignment: Alignment.center,
            padding: StandardSize.generalChipBorderPadding,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(children: [
                Expanded(
                    child: Text(
                  basket.generalPickUpTimeRangeStatement ?? "",
                  style: StandardTextStyle.green14SB,
                )),
                if (basket.stock > 0 &&
                    (basket.pickupTime?.end.isAfter(DateTime.now()) ?? false) &&
                    basket.status == BasketStatus.available)
                  GTChip(
                      backgroundColor: StandardColor.yellow,
                      message: StandardInappContentType
                          .generalBasketStatusOnShell.label)
                else
                  GTChip(
                      message: StandardInappContentType
                          .generalBasketStatusUnlisted.label)
              ]),
              const SizedBox(height: 15),
              SizedBox(
                  height: 65,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                            width: 65,
                            height: 65,
                            margin: const EdgeInsets.only(right: 14),
                            decoration: const BoxDecoration(
                                borderRadius:
                                    StandardSize.generalChipBorderRadius),
                            clipBehavior: Clip.antiAlias,
                            child: Image(
                                fit: BoxFit.cover,
                                image: NetworkImage(basket.image))),
                        Expanded(
                            child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                              Text(basket.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: StandardTextStyle.black18B),
                              GTChip(
                                  backgroundColor: StandardColor.green,
                                  message: StandardInappContentType
                                      .generalBasketStockStatement.label
                                      .replaceAll(valueReplacementTag,
                                          basket.stock.toString()),
                                  leading: const ImageIcon(
                                    AssetImage(StandardAssetImage.iconShopbag),
                                    size: 16,
                                    color: StandardColor.white,
                                  ))
                            ])),
                        const Icon(Icons.arrow_forward_ios,
                            size: 12, color: StandardColor.grey)
                      ]))
            ])));
  }
}
