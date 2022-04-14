import 'package:badges/badges.dart';
import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/service/database/database_u.dart';
import 'package:com_goodtakes/service/routing/paths.dart';
import 'package:com_goodtakes/states/my_restro_state.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/content/standard_interaction_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/basket_editor_view/basket_editor_view.dart';
import 'package:com_goodtakes/views/my_restro_profile/restro_notification_view.dart';
import 'package:com_goodtakes/views/my_restro_profile/restro_profile_editor_view.dart';
import 'package:com_goodtakes/views/my_restro_profile/restro_transaction_view.dart';
import 'package:com_goodtakes/widgets/display/basket/my_restro_basket_chip.dart';
import 'package:com_goodtakes/widgets/display/counter_badge.dart';
import 'package:com_goodtakes/widgets/display/decorated_title.dart';
import 'package:com_goodtakes/widgets/display/double_layer_display_box.dart';
import 'package:com_goodtakes/widgets/display/double_layer_message_bill_board.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/gt_icon_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:states_rebuilder/states_rebuilder.dart';

class MyRestroProfileView extends StatelessWidget {
  const MyRestroProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // debugPrint("MyRestroProfileView push and build");

    return OnBuilder<MyRestroState>(
        listenTo: RM.get<MyRestroState>(),
        builder: () {
          debugPrint('MyRestroState rebuild');
          final model = RM.get<MyRestroState>();
          final List<Basket> basket = model.state.restro!.baskets;

          return Scaffold(
              appBar: StaticAppBar(
                  title: StandardInteractionTextType.profileMyRestro.label,
                  foregroundColor: StandardColor.white,
                  background: StandardColor.green,
                  actions: [
                    Badge(
                        elevation: 0,
                        position: BadgePosition.topEnd(end: 10, top: 8),
                        showBadge: model.state.haveUnreadNotification,
                        padding: const EdgeInsets.all(5),
                        badgeColor: StandardColor.yellow,
                        child: GTIconButton(
                            foregroundColor: Colors.grey,
                            iconSize: 25,
                            icon: const ImageIcon(AssetImage(
                                StandardAssetImage.iconNotifiBellDefault)),
                            onPressed: () async {
                              await Navigator.of(context).push(
                                  CupertinoPageRoute(
                                      builder: (_) =>
                                          const RestroInAppNotificationView()));
                              updateRestroNotificationReadMd(
                                  model.state.restro!.id);
                            }))
                  ]),
              body: ListView(padding: EdgeInsets.zero, children: [
                const SizedBox(height: 20),
                Container(
                    margin: StandardSize.generalViewPadding,
                    clipBehavior: Clip.antiAlias,
                    decoration: const BoxDecoration(
                        color: StandardColor.white,
                        borderRadius: StandardSize.generalChipBorderRadius),
                    padding: StandardSize.generalViewPadding,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (_) => const RestorProfileEditor()));
                        },
                        child: Row(children: [
                          const ImageIcon(
                              AssetImage(StandardAssetImage.iconShop),
                              size: 20,
                              color: StandardColor.yellow),
                          const SizedBox(width: 10),
                          Expanded(
                              child: Text(model.state.restro!.name,
                                  style: StandardTextStyle.black18B)),
                          const Icon(Icons.chevron_right_rounded,
                              size: 12, color: StandardColor.grey)
                        ]))),
                const SizedBox(height: 20),
                Column(children: [
                  SizedBox(
                      height: 130,
                      child: Row(children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: StandardSize.generalViewPadding.left),
                                child: DoubleLayerMessageBillBoard(
                                  message: StandardInappContentType
                                      .myRestroMoneySavedValue.label
                                      .replaceAll(
                                          valueReplacementTag,
                                          model.state.restro!.summary.moneySaved
                                              .toString()),
                                  title: StandardInappContentType
                                      .myRestroMoneySavedTitle.label,
                                  icon: const ImageIcon(AssetImage(
                                      StandardAssetImage.iconDollorCircle)),
                                ))),
                        const SizedBox(width: 20),
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    right:
                                        StandardSize.generalViewPadding.right),
                                child: DoubleLayerMessageBillBoard(
                                    message: StandardInappContentType
                                        .myRestroFoodSavedValue.label
                                        .replaceAll(
                                            valueReplacementTag,
                                            model
                                                .state.restro!.summary.foodSaved
                                                .toString()),
                                    title: StandardInappContentType
                                        .myRestroFoodSavedTitle.label,
                                    icon: const ImageIcon(AssetImage(
                                        StandardAssetImage.iconSpoonAndFork)))))
                      ])),
                  const SizedBox(height: 30),
                  SizedBox(
                      height: 140,
                      child: Row(children: [
                        Expanded(
                            child: Padding(
                                padding: EdgeInsets.only(
                                    left: StandardSize.generalViewPadding.left,
                                    bottom: 20),
                                child: DoubleLayerMessageBillBoard(
                                    message: StandardInappContentType
                                        .myRestroCarbonReductionValue.label
                                        .replaceAll(
                                            valueReplacementTag,
                                            model
                                                .state.restro!.summary.foodSaved
                                                .toString()),
                                    title: StandardInappContentType
                                        .myRestroCarbonReductionTitle.label,
                                    icon: const ImageIcon(AssetImage(
                                        StandardAssetImage.iconLeaf))))),
                        const SizedBox(width: 20),
                        Expanded(
                            child: GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(CupertinoPageRoute(
                                      builder: (_) =>
                                          const MyRestroTransaction()));
                                },
                                child: DoubleLayerDisplayBox(
                                    image: const Image(
                                        image: AssetImage(StandardAssetImage
                                            .myRestroTransaction)),
                                    child: Align(
                                        alignment: Alignment.topCenter,
                                        child: Container(
                                            height: 50,
                                            // color: Colors.red,
                                            padding: const EdgeInsets.all(12),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  const ImageIcon(
                                                      AssetImage(
                                                          StandardAssetImage
                                                              .iconReceipt),
                                                      size: 19),
                                                  const SizedBox(width: 5),
                                                  Text(
                                                      StandardInteractionTextType
                                                          .myRestroTransactionStatement
                                                          .label,
                                                      style: StandardTextStyle
                                                          .black16B
                                                          .copyWith(
                                                              letterSpacing:
                                                                  0)),
                                                  CounterBadge(
                                                      count: model.state
                                                          .uncompletedCount,
                                                      alwayShowBadge: false)
                                                ]))))))
                      ]))
                ]),
                const SizedBox(height: 20),
                Padding(
                    padding: StandardSize.generalViewPadding,
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DecoratedTitle(
                              title: StandardInappContentType
                                  .restroDetailAvailableBasketAtDayTitle.label),
                          const SizedBox(height: 10),
                          if (basket.isEmpty)
                            Container(
                                alignment: Alignment.center,
                                padding: StandardSize.generalChipBorderPadding,
                                decoration: const BoxDecoration(
                                    color: StandardColor.white,
                                    borderRadius:
                                        StandardSize.generalChipBorderRadius),
                                clipBehavior: Clip.antiAlias,
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Image(
                                          image: AssetImage(StandardAssetImage
                                              .emptyBoxReplacement)),
                                      const SizedBox(height: 20),
                                      ElevatedButton(
                                          style: StandardButtonStyle
                                              .regularYellowButtonStyle
                                              .copyWith(
                                                  padding:
                                                      MaterialStateProperty.all(
                                                          const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 36))),
                                          onPressed: () {
                                            Navigator.of(context).push(
                                                CupertinoPageRoute(
                                                    builder: (_) =>
                                                        const BasketEditorView()));
                                          },
                                          child: Text(
                                              StandardInteractionTextType
                                                  .myRestroAddBasketButtonLabel
                                                  .label))
                                    ]))
                          else
                            MyRestroBasketChip(basket: basket.first)
                        ])),
                const SizedBox(
                    height: StandardSize.generalBottomEdgeWithBottomNavigator)
              ]));
        });
  }
}
