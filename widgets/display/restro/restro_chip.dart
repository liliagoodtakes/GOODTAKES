import 'package:com_goodtakes/model/restro/restro.dart';
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

class RestroChip extends StatelessWidget {
  final Restro restro;

  const RestroChip({required this.restro, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final basket = restro.baskets.isNotEmpty ? restro.baskets.first : null;
    final available = (basket?.availableStock ?? 0) > 0;
    String chipMessage = available
        ? StandardInappContentType.basketChipPriceTag.label
        : StandardInappContentType.generalBasketStatusUnlisted.label;

    if (basket != null) {
      chipMessage = chipMessage.replaceFirst(
          valueReplacementTag, basket.availableStock.toString());
      chipMessage = chipMessage.replaceFirst(
          valueReplacementTag, basket.promotionPrice.ceil().toString());
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
            width: 189,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: StandardColor.white),
            clipBehavior: Clip.antiAlias,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                      height: 99,
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
                            height: 28,
                            right: 5,
                            bottom: 5,
                            child: GTChip(
                                backgroundColor: available
                                    ? StandardColor.yellow
                                    : StandardColor.grey,
                                foregroundColor: StandardColor.white,
                                leading: const ImageIcon(
                                    AssetImage(StandardAssetImage.iconShopbag),
                                    color: StandardColor.white,
                                    size: 16),
                                message: chipMessage))
                      ])),
                  Expanded(
                      child: Padding(
                          padding: const EdgeInsets.fromLTRB(10, 7, 10, 7),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(restro.name,
                                    style: StandardTextStyle.black14R,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis),
                                Row(children: [
                                  const Icon(Icons.location_on_outlined,
                                      color: StandardColor.yellow, size: 14),
                                  Text(restro.displayDistrict,
                                      style: StandardTextStyle.grey12R),
                                  const SizedBox(width: 12),
                                  const Icon(Icons.local_offer_outlined,
                                      color: StandardColor.yellow, size: 14),
                                  Expanded(
                                      child: Text(restro.displayTypes.join("."),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: StandardTextStyle.grey12R))
                                ])
                              ])))
                ])));
  }
}

class HomePageRestroClose extends StatelessWidget {
  //final Restro restro;
  final String name;

  const HomePageRestroClose(
      {required this.name,
      //required this.restro,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 189,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: StandardColor.white),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image(
                image: AssetImage("assets/images/application/test123.jpg"),
                fit: BoxFit.cover,
                height: 99,
                color: Colors.white.withOpacity(0.3),
                colorBlendMode: BlendMode.modulate),
            Container(
                padding: EdgeInsets.fromLTRB(10, 7, 10, 7),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(name, style: StandardTextStyle.black14R),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: StandardColor.yellow,
                          size: 14,
                        ),
                        Text("旺角", style: StandardTextStyle.grey12R),
                        SizedBox(width: 12),
                        Icon(
                          Icons.local_offer_outlined,
                          color: StandardColor.yellow,
                          size: 14,
                        ),
                        Text("冰店.餐廳", style: StandardTextStyle.grey12R)
                      ],
                    )
                  ],
                ))
          ],
        ));
  }
}
