import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_layout_builder.dart/standard_size.dart';
import 'package:com_goodtakes/static/standard_styling/standard_button_style.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/widgets/display/decorated_title.dart';
import 'package:com_goodtakes/widgets/display/restro/restro_info.dart';
import 'package:com_goodtakes/widgets/display/restro/widget_restro_close_tag.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:com_goodtakes/widgets/interaction/gt_icon_button.dart';
import 'package:flutter/material.dart';

class RestroDetailEmptyBasketView extends StatelessWidget {
  final Restro restro;
  const RestroDetailEmptyBasketView({required this.restro, Key? key})
      : super(key: key);

  Widget _layoutBuilder(Widget child) {
    return Card(
        margin: EdgeInsets.only(
            left: StandardSize.generalChipBorderPadding.left,
            right: StandardSize.generalChipBorderPadding.right),
        clipBehavior: Clip.antiAlias,
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: StandardSize.generalChipBorderRadius),
        child: child);
  }

  @override
  Widget build(BuildContext context) {
    final backgroundImageHeight = MediaQuery.of(context).size.height * 0.3;
    final backgroundImageWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: StaticAppBar(
            background: Colors.transparent,
            iconBackground: StandardColor.white,
            actions: [
              GTIconButton(
                  backgroundColor: StandardColor.white,
                  iconSize: 24,
                  foregroundColor: StandardColor.yellow,
                  icon: const Icon(Icons.share),
                  onPressed: () {})
            ]),
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
                          image: NetworkImage(restro.image)),
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
                        child: const RestroCloseTag())),
                SliverToBoxAdapter(
                    child: _layoutBuilder(RestroInfo(restro: restro))),
                const SliverToBoxAdapter(child: SizedBox(height: 17)),
                SliverToBoxAdapter(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Padding(
                          padding: StandardSize.generalChipBorderPadding
                              .copyWith(top: 11, bottom: 11),
                          child: DecoratedTitle(
                              title: StandardInappContentType
                                  .restroDetailAvailableBasketAtDayTitle
                                  .label)),
                      _layoutBuilder(Container(
                          height: 211,
                          alignment: Alignment.center,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  StandardAssetImage.emptyBoxReplacement,
                                  width: 130,
                                ),
                                const SizedBox(height: 11),
                                Text(
                                    StandardInappContentType
                                        .generalEmptyBasketStatement.label,
                                    style: StandardTextStyle.grey18R)
                              ]))),
                      const SizedBox(height: 100)
                    ])),
                const SliverToBoxAdapter(child: SizedBox(height: 11))
              ])),
          Positioned(
              bottom: 0,
              left: 0,
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton(
                  style: StandardButtonStyle.purchaseButtonStyle,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(StandardInappContentType
                            .restroDetailEmptyBasketCTAStatement.label)
                      ])))
        ]));
  }
}
