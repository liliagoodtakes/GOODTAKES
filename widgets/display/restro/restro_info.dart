import 'package:com_goodtakes/model/restro/restro.dart';
import 'package:com_goodtakes/service/launcher_service.dart';
import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:com_goodtakes/views/restro_map_view/restro_map_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class RestroInfo extends StatelessWidget {
  final Restro restro;
  final bool showNavigation;
  final bool trim;
  const RestroInfo(
      {this.showNavigation = false,
      this.trim = false,
      required this.restro,
      Key? key})
      : super(key: key);

  Widget get inlineSecperator => const SizedBox(height: 4, width: 5);
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: StandardColor.white),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                restro.name,
                style: StandardTextStyle.black18B,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Expanded(
                    child: Column(children: [
                  inlineSecperator,
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const ImageIcon(AssetImage(StandardAssetImage.iconTags),
                        size: 16, color: StandardColor.yellow),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(restro.displayTypes.join("・"),
                            style: StandardTextStyle.black14R
                                .copyWith(height: 1.2)))
                  ]),
                  inlineSecperator,
                  GestureDetector(
                      onTap: () async {
                        final s = await standardLauncher(
                            LauncherType.phone, restro.phone);
                      },
                      child: Row(children: [
                        const ImageIcon(
                            AssetImage(StandardAssetImage.iconPhone),
                            size: 16,
                            color: StandardColor.yellow),
                        const SizedBox(width: 6),
                        Expanded(
                            child: Text(restro.phone,
                                style: StandardTextStyle.black14U
                                    .copyWith(height: 1.2)))
                      ])),
                  inlineSecperator,
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    const ImageIcon(AssetImage(StandardAssetImage.iconLocatorL),
                        size: 16, color: StandardColor.yellow),
                    const SizedBox(width: 6),
                    Expanded(
                        child: Text(restro.address,
                            style: StandardTextStyle.black14R
                                .copyWith(height: 1.2)))
                  ])
                ])),
                Offstage(
                    offstage: !showNavigation,
                    child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(CupertinoPageRoute(
                              builder: (_) => RestroMapView(restro: restro)));
                        },
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(restro.distanceFromAnchor,
                                  style: StandardTextStyle.yellow14R.copyWith(
                                      letterSpacing: 0, wordSpacing: -1)),
                              const SizedBox(height: 5),
                              const Image(
                                  width: 68,
                                  image: AssetImage(StandardAssetImage
                                      .navigationServiceIndicator))
                            ])))
              ]),
              Offstage(
                  offstage: trim,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 15),
                        Container(height: 1.25, color: StandardColor.lightGrey),
                        const SizedBox(height: 15),
                        Text(restro.description,
                            textAlign: TextAlign.left,
                            style: StandardTextStyle.black14R)
                      ])),
            ]));
  }
}
