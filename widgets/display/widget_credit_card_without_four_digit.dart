import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class CreditCardWithoutFourDigit extends StatelessWidget {
  const CreditCardWithoutFourDigit({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: StandardColor.white),
      child: Row(
        children: [
          Expanded(
            child: Text("VISA", style: StandardTextStyle.black14SB),
          ),
          Text("HK\$ 45", style: StandardTextStyle.black14SB)
        ],
      ),
    );
  }
}
