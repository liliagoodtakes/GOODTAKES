import 'package:com_goodtakes/static/content/standard_asset_image.dart';
import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class EmptyListReplacement extends StatelessWidget {
  const EmptyListReplacement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Image(
                image: AssetImage(StandardAssetImage.emptyListReplacement)),
            const SizedBox(height: 5),
            Text(
                StandardInappContentType.generalEmptyListReplacementLabel.label,
                style: StandardTextStyle.grey18R)
          ],
        ));
  }
}
