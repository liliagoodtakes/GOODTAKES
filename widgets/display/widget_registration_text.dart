import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/views/webview_launcher/webview_launcher.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:page_transition/page_transition.dart';

class RegistText extends StatelessWidget {
  const RegistText({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: RichText(
          text: TextSpan(children: [
            TextSpan(
                text: StandardInappContentType.registerPhoneInputTitle.label,
                style: StandardTextStyle.black18B),
            const TextSpan(text: "\n"),
            TextSpan(
              text: StandardInappContentType.registerPhoneInputContent1.label,
              style: StandardTextStyle.grey12R,
            ),
            TextSpan(
                text: StandardInappContentType.registerPhoneInputContent2.label,
                style: StandardTextStyle.yellow12U,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => showEdgedWebView(
                      context: context,
                      url: StandardInappContentType
                          .generalUserRegulationURL.label,
                      title: StandardInappContentType
                          .registerPhoneInputContent2.label)),
            TextSpan(
                text: StandardInappContentType.registerPhoneInputContent3.label,
                style: StandardTextStyle.grey12R),
            TextSpan(
                text: StandardInappContentType.registerPhoneInputContent4.label,
                style: StandardTextStyle.yellow12U,
                recognizer: TapGestureRecognizer()
                  ..onTap = () => showEdgedWebView(
                      context: context,
                      url: StandardInappContentType
                          .generalPrivacyStatementURL.label,
                      title: StandardInappContentType
                          .registerPhoneInputContent4.label))
          ]),
        ));
  }
}
