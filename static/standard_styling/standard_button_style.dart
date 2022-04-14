import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:com_goodtakes/static/standard_styling/standard_text_style.dart';
import 'package:flutter/material.dart';

const minimumSize = Size(0, 0);
const buttonAnimationDuration = Duration(microseconds: 100);
const splashFactory = InkRipple.splashFactory;

class StandardButtonStyle {
  static final buttonStyleInTesting = [
    // StandardButtonStyle.sampleButtonStyle,
    StandardButtonStyle.confirmButtonStyle,
    StandardButtonStyle.regularYellowButtonStyle,
    StandardButtonStyle.regularGreenButtonStyle,
    StandardButtonStyle.regularRedButtonStyle,
    StandardButtonStyle.purchaseButtonStyle,
    StandardButtonStyle.numberKeyboardButtonStyle,
    StandardButtonStyle.functionKeyboardButtonStyle,
    StandardButtonStyle.pickupTimeSelectButtonStyle,
    StandardButtonStyle.pickupTimeUnselectButtonStyle,
    StandardButtonStyle.countButtonStyle
  ];

  /// For 17 Notice:
  /// ButtonStyle => resolveWith => Some ConditionR
  ///   EG: MaterialState.disabled , 當按鈕不能按時
  ///       MaterialState.hovered , 當按鈕按著時
  ///
  /// ButtonStyle => all => In All Condition
  /// MaterialState.focused = 按下去的動畫
  /// MaterialState.pressed = 按下去的一刻
  /// MaterialState.hovered = 滑鼠移到按鈕上
  ///
  ///
  // static final ButtonStyle sampleButtonStyle = ButtonStyle(
  //     backgroundColor: MaterialStateProperty.resolveWith<Color>(//文字或icon
  //         (Set<MaterialState> states) {
  //       if (states.contains(MaterialState.hovered)) {
  //         return StandardColor.black;
  //       } else if (states.contains(MaterialState.focused)) {
  //         return StandardColor.green;
  //       } else {
  //         return StandardColor.lightYellow;
  //       }
  //     }),
  //     overlayColor: MaterialStateProperty.all(
  //         Colors.red), // 我錯了，這裡設定按下去的顏色，不是 background Color
  //     foregroundColor: MaterialStateProperty.resolveWith<Color>(//文字或icon
  //         (Set<MaterialState> states) => states.contains(MaterialState.disabled)
  //             ? Colors.grey //disable
  //             : StandardColor.sample), //
  //     fixedSize: MaterialStateProperty.all(
  //         const Size(44, 100)), // 如果只想設定高度，可用 Size.fromHeight()
  //     minimumSize: MaterialStateProperty.all(const Size(0, 0)),
  //     padding: MaterialStateProperty.all(
  //         const EdgeInsets.symmetric(horizontal: 24, vertical: 2)),
  //     textStyle: MaterialStateProperty.all(
  //         const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  //     shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
  //         (Set<MaterialState> states) => RoundedRectangleBorder(
  //             borderRadius: BorderRadius.circular(8),
  //             side: const BorderSide(color: Colors.grey, width: 3))),
  //     //elevation: MaterialStateProperty.all(10),
  //     tapTargetSize: MaterialTapTargetSize.shrinkWrap,
  //     splashFactory: InkSplash.splashFactory);

  static final confirmButtonStyle = ButtonStyle(
    elevation: MaterialStateProperty.all(0),
    shadowColor: MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 0.06)),
    splashFactory: splashFactory,
    animationDuration: buttonAnimationDuration,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    fixedSize: MaterialStateProperty.all(const Size.fromHeight(44)),
    minimumSize: MaterialStateProperty.all(const Size(0, 0)),
    textStyle: MaterialStateProperty.all(StandardTextStyle.black16R),
    foregroundColor: MaterialStateProperty.all(StandardColor.closeToBlack),
    backgroundColor: MaterialStateProperty.all(StandardColor.yellow),
    overlayColor: MaterialStateProperty.all(StandardColor.darkyellow),
    shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
        (Set<MaterialState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0),
            )),
  );

  static final cancelButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      shadowColor:
          MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 0.06)),
      animationDuration: buttonAnimationDuration,
      splashFactory: splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(44)),
      minimumSize: MaterialStateProperty.all(const Size(0, 0)),
      textStyle: MaterialStateProperty.all(StandardTextStyle.black16R),
      foregroundColor: MaterialStateProperty.all(StandardColor.closeToBlack),
      backgroundColor: MaterialStateProperty.all(StandardColor.grey),
      overlayColor: MaterialStateProperty.all(StandardColor.darkGrey),
      shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (Set<MaterialState> states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              )));

  static final regularYellowButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      shadowColor:
          MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 0.06)),
      animationDuration: buttonAnimationDuration,
      splashFactory: splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(44)),
      minimumSize: MaterialStateProperty.all(const Size(0, 0)),
      textStyle: MaterialStateProperty.all(StandardTextStyle.black16R),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? StandardColor.darkGrey //disable
              : StandardColor.closeToBlack),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? StandardColor.grey //disable
              : StandardColor.yellow),
      overlayColor: MaterialStateProperty.all(StandardColor.darkyellow),
      shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (Set<MaterialState> states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              )));

  static final regularGreenButtonStyle = ButtonStyle(
      elevation: MaterialStateProperty.all(0),
      shadowColor:
          MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 0.06)),
      animationDuration: buttonAnimationDuration,
      splashFactory: splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(44)),
      minimumSize: MaterialStateProperty.all(const Size(0, 0)),
      textStyle: MaterialStateProperty.all(StandardTextStyle.black16R),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? StandardColor.darkGrey //disable
              : StandardColor.lightGrey),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? StandardColor.grey //disable
              : StandardColor.green),
      overlayColor: MaterialStateProperty.all(StandardColor.darkgreen),
      shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (Set<MaterialState> states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              )));

  static final regularRedButtonStyle = ButtonStyle(
      animationDuration: buttonAnimationDuration,
      splashFactory: splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(44)),
      minimumSize: MaterialStateProperty.all(const Size(0, 0)),
      textStyle: MaterialStateProperty.all(StandardTextStyle.black16R),
      foregroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? StandardColor.darkGrey //disable
              : StandardColor.lightGrey),
      backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) => states.contains(MaterialState.disabled)
              ? StandardColor.grey //disable
              : StandardColor.red),
      overlayColor: MaterialStateProperty.all(StandardColor.red),
      shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (Set<MaterialState> states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              )),
      elevation: MaterialStateProperty.all(0));

  static final purchaseButtonStyle = ButtonStyle(
      animationDuration: buttonAnimationDuration,
      splashFactory: splashFactory,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      fixedSize: MaterialStateProperty.all(const Size.fromHeight(80)),
      // minimumSize: MaterialStateProperty.all(const Size(0, 0)),
      padding: MaterialStateProperty.all(const EdgeInsets.only(top: 15.0)),
      textStyle: MaterialStateProperty.all(StandardTextStyle.black18B),
      foregroundColor: MaterialStateProperty.all(StandardColor.closeToBlack),
      backgroundColor: MaterialStateProperty.resolveWith((states) {
        if (states.contains(MaterialState.disabled)) {
          return StandardColor.grey;
        } else {
          return StandardColor.yellow;
        }
      }),
      shadowColor:
          MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 0.06)),
      overlayColor: MaterialStateProperty.all(StandardColor.darkyellow),
      shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
          (Set<MaterialState> states) => RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0),
              )),
      elevation: MaterialStateProperty.all(0));

  static final numberKeyboardButtonStyle = ButtonStyle(
    animationDuration: buttonAnimationDuration,
    splashFactory: splashFactory,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: MaterialStateProperty.all(const Size(52, 52)),
    textStyle: MaterialStateProperty.all(StandardTextStyle.black24R),
    foregroundColor: MaterialStateProperty.all(StandardColor.closeToBlack),
    backgroundColor: MaterialStateProperty.all(StandardColor.white),
    overlayColor: MaterialStateProperty.all(StandardColor.lightGrey),
    shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
        (Set<MaterialState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
    elevation: MaterialStateProperty.all(0),
    shadowColor: MaterialStateProperty.all(const Color.fromRGBO(0, 0, 0, 0.06)),
  );

  static final functionKeyboardButtonStyle = ButtonStyle(
    animationDuration: buttonAnimationDuration,
    splashFactory: splashFactory,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: MaterialStateProperty.all(const Size(52, 52)),
    textStyle: MaterialStateProperty.all(StandardTextStyle.black24R),
    foregroundColor: MaterialStateProperty.all(StandardColor.yellow),
    backgroundColor: MaterialStateProperty.all(StandardColor.white),
    overlayColor: MaterialStateProperty.all(StandardColor.lightGrey),
    shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
        (Set<MaterialState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            )),
    elevation: MaterialStateProperty.all(0.0),
  );

  static final pickupTimeUnselectButtonStyle = ButtonStyle(
    animationDuration: buttonAnimationDuration, splashFactory: splashFactory,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0)),
    minimumSize: MaterialStateProperty.all(const Size(0, 0)),
    textStyle: MaterialStateProperty.all(StandardTextStyle.yellow14SB),
    foregroundColor: MaterialStateProperty.all(StandardColor.yellow),
    backgroundColor: MaterialStateProperty.all(StandardColor.white),
    //overlayColor: MaterialStateProperty.all(StandardColor.yellow),
    shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
        (Set<MaterialState> states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
            side: const BorderSide(color: StandardColor.yellow, width: 1))),
    elevation: MaterialStateProperty.all(0.0),
  );

  static final pickupTimeSelectButtonStyle = ButtonStyle(
    animationDuration: buttonAnimationDuration, splashFactory: splashFactory,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    padding: MaterialStateProperty.all(
        const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0)),
    minimumSize: MaterialStateProperty.all(const Size(0, 0)),
    textStyle: MaterialStateProperty.all(StandardTextStyle.yellow14SB),
    foregroundColor: MaterialStateProperty.all(StandardColor.white),
    backgroundColor: MaterialStateProperty.all(StandardColor.yellow),
    //overlayColor: MaterialStateProperty.all(StandardColor.yellow),
    shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
        (Set<MaterialState> states) => RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
            side: const BorderSide(color: StandardColor.yellow, width: 1))),
    elevation: MaterialStateProperty.all(0.0),
  );

  static final countButtonStyle = ButtonStyle(
    animationDuration: buttonAnimationDuration,
    splashFactory: splashFactory,
    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    minimumSize: MaterialStateProperty.all(const Size(21.9, 21.9)),
    padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
    textStyle: MaterialStateProperty.all(StandardTextStyle.white14SB),
    foregroundColor: MaterialStateProperty.all(StandardColor.white),
    backgroundColor: MaterialStateProperty.resolveWith<Color>(
        (Set<MaterialState> states) => states.contains(MaterialState.disabled)
            ? StandardColor.darkGrey //disable
            : StandardColor.yellow),
    overlayColor: MaterialStateProperty.all(StandardColor.yellow),
    shape: MaterialStateProperty.resolveWith<RoundedRectangleBorder>(
        (Set<MaterialState> states) => RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            )),
    elevation: MaterialStateProperty.all(0),
  );
}
