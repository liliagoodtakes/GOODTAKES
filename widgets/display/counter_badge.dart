import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

class CounterBadge extends StatelessWidget {
  final int count;
  final bool alwayShowBadge;
  const CounterBadge(
      {this.alwayShowBadge = false, required this.count, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Offstage(
        offstage: count == 0 && alwayShowBadge == false,
        child: Container(
            margin: const EdgeInsets.only(left: 6),
            alignment: Alignment.center,
            width: 17,
            height: 19,
            decoration: const BoxDecoration(
                color: StandardColor.darkgreen,
                borderRadius: BorderRadius.all(Radius.circular(3))),
            child: Text(count.toString(),
                style: StandardTextStyle.black12R.copyWith(
                    color: Colors.white, fontWeight: FontWeight.w600))));
  }
}
