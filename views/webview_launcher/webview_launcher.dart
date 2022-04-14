import 'package:com_goodtakes/static/content/standard_inapp_content.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/widgets/interaction/appbar/static_appbar.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

void showEdgedWebView(
    {required BuildContext context,
    required String url,
    required String title,
    final Color backgroundColor = Colors.black38,
    final BoxDecoration decoration = const BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(10.0))),
    final EdgeInsets margin =
        const EdgeInsets.only(top: 40, left: 10, right: 10)}) {
  Scaffold.of(context).showBottomSheet(
      (context) => Material(
          color: backgroundColor,
          elevation: 10,
          child: Container(
              clipBehavior: Clip.antiAlias,
              decoration: decoration,
              alignment: Alignment.center,
              margin: margin,
              child: WebViewLauncher(url: url, title: title))),
      backgroundColor: Colors.transparent);
}

class WebViewLauncher extends StatelessWidget {
  final String url;
  final String title;
  const WebViewLauncher({
    Key? key,
    required this.url,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: StaticAppBar(title: title),
        body: WebView(backgroundColor: StandardColor.white, initialUrl: url));
  }
}
