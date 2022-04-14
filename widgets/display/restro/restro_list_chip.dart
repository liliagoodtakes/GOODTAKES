import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/service/convertor/datetime.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/restro_detail_view/restro_detail_empty_basket_view.dart';
import 'package:com_goodtakes/views/restro_detail_view/restro_detail_view.dart';
import 'package:com_goodtakes/widgets/display/gt_chip.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class RestroListChip extends StatelessWidget {
  final Restro restro;
  // final String name;

  const RestroListChip({required this.restro, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final available = restro.baskets.isEmpty
        ? false
        : (restro.baskets.first.availableStock) > 0;
    String chipMessage = available
        ? StandardInappContentType.basketChipPriceTag.label
        : StandardInappContentType.generalBasketStatusUnlisted.label;

    if (available) {
      chipMessage = chipMessage.replaceFirst(
          valueReplacementTag, restro.baskets.first.availableStock.toString());
      chipMessage = chipMessage.replaceFirst(valueReplacementTag,
          restro.baskets.first.promotionPrice.ceil().toString());
    }
    return GestureDetector(
        onTap: () {
          debugPrint("restro.id : ${restro.id}");
          Navigator.of(context).push(CupertinoPageRoute(
              builder: (_) => available
                  ? RestroDetailView(restro: restro)
                  : RestroDetailEmptyBasketView(restro: restro)));
        },
        child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: StandardColor.white),
            clipBehavior: Clip.antiAlias,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 150,
                      child: Stack(fit: StackFit.expand, children: [
                        Image(
                            color: available
                                ? null
                                : Colors.white.withOpacity(0.3),
                            colorBlendMode:
                                available ? null : BlendMode.modulate,
                            image: NetworkImage(restro.image),
                            fit: BoxFit.cover),
                        Positioned(
                            // height: 28,
                            right: 5,
                            bottom: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Offstage(
                                    offstage: !available,
                                    child: GTChip(
                                        backgroundColor: available
                                            ? StandardColor.yellow
                                            : StandardColor.darkGrey,
                                        foregroundColor: StandardColor.white,
                                        leading: const ImageIcon(
                                            AssetImage(
                                                StandardAssetImage.iconShopbag),
                                            color: StandardColor.white,
                                            size: 16),
                                        message: chipMessage)),
                                const SizedBox(height: 5),
                                GTChip(
                                    backgroundColor: available
                                        ? StandardColor.green
                                        : StandardColor.darkGrey,
                                    foregroundColor: StandardColor.white,
                                    leading: available
                                        ? const ImageIcon(
                                            AssetImage(
                                                StandardAssetImage.iconClock),
                                            color: StandardColor.white,
                                            size: 16)
                                        : null,
                                    message: available
                                        ? "${restro.baskets.first.pickUpStartTimeOfDay!.formatAsTwoDigit()}-${restro.baskets.first.pickUpCloseTimeOfDay!.formatAsTwoDigit()}"
                                        : chipMessage)
                              ],
                            ))
                      ])),
                  Container(
                      padding: EdgeInsets.fromLTRB(15, 11, 15, 11),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(restro.name,
                                style: StandardTextStyle.black18R),
                            Row(children: [
                              Icon(
                                Icons.location_on_outlined,
                                color: StandardColor.yellow,
                                size: 14,
                              ),
                              Text(
                                  restro.displayDistrict +
                                      "‧" +
                                      restro.distanceFromAnchor,
                                  style: StandardTextStyle.grey12R),
                              SizedBox(width: 12),
                              Icon(
                                Icons.local_offer_outlined,
                                color: StandardColor.yellow,
                                size: 14,
                              ),
                              Text(restro.displayTypes.join("‧"),
                                  style: StandardTextStyle.grey12R)
                            ])
                          ]))
                ])));
  }
}
