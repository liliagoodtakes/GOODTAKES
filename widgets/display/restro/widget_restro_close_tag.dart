import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class RestroCloseTag extends StatelessWidget {
  //final Basket basket;

  const RestroCloseTag(
      {
      //required this.basket,

      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 28,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: StandardColor.darkGrey),
        child: Text(
          "暫無提供",
          style: StandardTextStyle.white14SB,
          textAlign: TextAlign.center,
        ));
  }
}
