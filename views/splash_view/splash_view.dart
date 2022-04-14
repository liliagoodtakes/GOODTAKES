import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:flutter/material.dart';

class SplashView extends StatelessWidget {
  const SplashView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: StandardColor.green,
      body: Center(
          child: Image(
              width: 219, image: AssetImage(StandardAssetImage.splashImage))),
    );
  }
}
