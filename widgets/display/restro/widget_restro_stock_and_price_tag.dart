import 'package:com_goodtakes/model/basket/basket.dart';
import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class RestroStockAndPriceTag extends StatelessWidget {
  //final Basket basket;

  const RestroStockAndPriceTag(
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
          borderRadius: BorderRadius.circular(5), color: StandardColor.yellow),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_basket_outlined,
            color: StandardColor.white,
            size: 15,
          ),
          Text(
            "5 · \$28 起",
            style: StandardTextStyle.white14SB,
          )
        ],
      ),
    );
  }
}
