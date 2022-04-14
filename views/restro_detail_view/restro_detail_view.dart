import 'dart:async';

import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/model/transaction/transaction_detail.dart';
import 'package:com_goodtakes/service/convertor/latlng.dart';
import 'package:com_goodtakes/service/database/database_c.dart';
import 'package:com_goodtakes/service/database/database_r.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/firebase_ref_path.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/payment_view/payment_view.dart';
import 'package:com_goodtakes/views/restro_map_view/restro_map_view.dart';
import 'package:com_goodtakes/widgets/display/basket/basket_info.dart';
import 'package:com_goodtakes/widgets/display/decorated_title.dart';
import 'package:com_goodtakes/widgets/display/restro/restro_info.dart';
import 'package:com_goodtakes/widgets/display/restro/widget_restro_during_time_tag.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/gt_icon_button.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class RestroDetailView extends StatefulWidget {
  final Restro restro;
  const RestroDetailView({required this.restro, Key? key}) : super(key: key);

  @override
  _RestroDetailViewState createState() => _RestroDetailViewState();
}

class _RestroDetailViewState extends State<RestroDetailView> {
  late Basket basket = widget.restro.baskets.first;
  late final backgroundImageHeight = MediaQuery.of(context).size.height * 0.25;
  late final backgroundImageWidth = MediaQuery.of(context).size.width;

  late TransactionDetail transactionDetail =
      buildTransaction(basket.availableStock > 0 ? 1 : 0);

  bool transactionHolding = false;

  TransactionDetail buildTransaction(int count) {
    return TransactionDetail.build({
      "basket_name": basket.name,
      "sub_count": count,
      "sub_amount": count * basket.originalPrice,
      "sub_payable": count * basket.promotionPrice,
      "basket_description": basket.description,
      "sub_discount":
          (count * basket.originalPrice) - (count * basket.promotionPrice)
    }, basket.id);
  }

  Widget _layoutBuilder(Widget child) {
    return Card(
        margin: EdgeInsets.only(
            left: StandardSize.generalViewPadding.left,
            right: StandardSize.generalViewPadding.right),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: StandardSize.generalChipBorderRadius),
        child: child);
  }

  late final StreamSubscription<DatabaseEvent> subscription;
  void monitoringStock() {
    subscription = DatabaseRoot.restroProfile.standardReference
        .child([widget.restro.id, DatabaseRoot.basket.name].join("/"))
        .onChildChanged
        .listen((event) {
      if (!transactionHolding) {
        basket = Basket.build(
            event.snapshot.value as Map, event.snapshot.key!, basket.restroId);
        setState(() {});
        debugPrint("${widget.restro.id} on change ::: ${event.snapshot.value}");
      }
    });
  }

  void onClick() async {
    if (basket.availableStock > 0) {
      transactionHolding = true;
      final paymentSession =
          await requestPaymentSession(transactionDetail, basket);
      if (paymentSession != null) {
        await Navigator.of(context).push(CupertinoPageRoute(
            builder: (_) =>
                PaymentView(session: paymentSession, restro: widget.restro)));
        transactionHolding = false;
      } else {
        transactionHolding = false;
      }
    }
  }

  @override
  void initState() {
    monitoringStock();
    super.initState();
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: StaticAppBar(
            background: Colors.transparent,
            iconBackground: StandardColor.white,
            leading: Container(
                margin: const EdgeInsets.only(left: 10),
                child: GTIconButton(
                    buttonSize: 32,
                    backgroundColor: StandardColor.white,
                    iconSize: 17,
                    padding: const EdgeInsets.all(0),
                    foregroundColor: StandardColor.yellow,
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () {
                      Navigator.of(context).pop();
                    })),
            actions: [
              Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: GTIconButton(
                      buttonSize: 32,
                      backgroundColor: StandardColor.white,
                      iconSize: 17,
                      padding: const EdgeInsets.all(0),
                      foregroundColor: StandardColor.yellow,
                      icon: const ImageIcon(
                          AssetImage(StandardAssetImage.iconShare)),
                      onPressed: () {
                        final message =
                            "宜家用Goodtakes App買${widget.restro.name}嘅嘢食有低至{3折}嘅優惠！福袋數目唔多，等緊你火速拎佢返去～救救剩食！即刻用至抵價救美食福袋返屋企🔗🔗https://message.goodtakes.co/restro/${widget.restro.id}";
                        Share.share(message);
                      }))
            ]),
        bottomNavigationBar: ElevatedButton(
            style: StandardButtonStyle.purchaseButtonStyle,
            onPressed: basket.availableStock > 0 ? onClick : null,
            child: Align(
                alignment: Alignment.topCenter,
                child: basket.availableStock > 0
                    ? RichText(
                        text: TextSpan(
                            style: StandardTextStyle.black18B,
                            children: [
                            TextSpan(
                                text: StandardInteractionTextType
                                    .generalPurchaseCTALabel.label),
                            const TextSpan(text: " ‧ "),
                            TextSpan(
                                text: StandardInappContentType
                                    .generalAmountWithCurrencyStatement.label
                                    .replaceFirst(
                                        valueReplacementTag,
                                        transactionDetail.subPayable
                                            .ceil()
                                            .toString())),
                          ]))
                    : const Text("暫時缺貨"))),
        body: Stack(children: [
          Positioned(
              top: 0,
              left: 0,
              width: backgroundImageWidth,
              height: backgroundImageHeight,
              child: DecoratedBox(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          alignment: Alignment.center,
                          image: NetworkImage(widget.restro.image)),
                      color: StandardColor.white))),
          Positioned(
              top: 0,
              left: 0,
              width: backgroundImageWidth,
              height: MediaQuery.of(context).size.height,
              child: CustomScrollView(slivers: [
                SliverToBoxAdapter(
                    child: SizedBox(height: backgroundImageHeight - 60)),
                SliverToBoxAdapter(
                    child: Container(
                        margin: EdgeInsets.only(
                            right: StandardSize.generalViewPadding.right,
                            bottom: 7),
                        alignment: Alignment.centerRight,
                        child: RestroDuringTimeTag(
                            start: basket.pickUpStartTimeOfDay!,
                            close: basket.pickUpCloseTimeOfDay!))),
                SliverToBoxAdapter(
                  child: _layoutBuilder(
                      RestroInfo(showNavigation: true, restro: widget.restro)),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 17)),
                SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Padding(
                          padding: StandardSize.generalChipBorderPadding
                              .copyWith(top: 0, bottom: 11),
                          child: DecoratedTitle(
                              title: StandardInappContentType
                                  .restroDetailAvailableBasketAtDayTitle
                                  .label)),
                      _layoutBuilder(BasketInfo(
                          selected: transactionDetail.subCount,
                          onAdd: () {
                            if (basket.availableStock >
                                transactionDetail.subCount) {
                              transactionDetail = buildTransaction(
                                  transactionDetail.subCount + 1);
                              setState(() {});
                            }
                          },
                          onRemove: () {
                            if (transactionDetail.subCount > 1) {
                              transactionDetail = buildTransaction(
                                  transactionDetail.subCount - 1);
                              setState(() {});
                            }
                          },
                          basket: basket)),
                      const SizedBox(height: 80)
                    ])),
                const SliverToBoxAdapter(child: SizedBox(height: 11))
              ]))
        ])
        // Positioned(
        //     bottom: 0,
        //     left: 0,
        //     width: MediaQuery.of(context).size.width,
        //     child: ElevatedButton(
        //         style: StandardButtonStyle.purchaseButtonStyle,
        //         onPressed: basket.availableStock > 0
        //             ? () async {
        //                 transactionHolding = true;
        //                 final paymentSession = await requestPaymentSession(
        //                     transactionDetail, basket);
        //                 if (paymentSession != null) {
        //                   await Navigator.of(context).push(PageTransition(
        //                       child: PaymentView(
        //                           session: paymentSession,
        //                           restro: widget.restro),
        //                       type: standardTransiontionType));
        //                   transactionHolding = false;
        //                 } else {
        //                   transactionHolding = false;
        //                 }
        //               }
        //             : null,
        //         child: Row(
        //             mainAxisAlignment: MainAxisAlignment.center,
        //             children: basket.availableStock > 0
        //                 ? [
        //                     Text(StandardInteractionTextType
        //                         .generalPurchaseCTALabel.label),
        //                     const Padding(
        //                         padding: EdgeInsets.symmetric(horizontal: 5),
        //                         child: Icon(Icons.circle,
        //                             size: 6,
        //                             color: StandardColor.closeToBlack)),
        //                     Text(StandardInappContentType
        //                         .generalAmountWithCurrencyStatement.label
        //                         .replaceFirst(
        //                             valueReplacementTag,
        //                             transactionDetail.subPayable
        //                                 .ceil()
        //                                 .toString()))
        //                   ]
        //                 : [Text("暫時缺貨")]))

        );
  }
}
