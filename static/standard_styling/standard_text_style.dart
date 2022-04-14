import 'package:com_goodtakes/static/standard_styling/standard_color.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final textStyleInTesting = [
  StandardTextStyle.heading28R,
];

class StandardTextStyle {
  // ---- 這是這一組參數的分割線, Code 放到這線下 ----
  static final sample = TextStyle(
      fontFamily: GoogleFonts.aBeeZee().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w100, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1, // Ratio Of Font
      color: StandardColor.sample);

  static const sample2 = TextStyle(
      fontFamily: "輸入字體名稱", // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w100, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX，沒必要不需設定
      wordSpacing: 1, // PX，沒必要不需設定he
      height: 1, // Ratio Of Font，沒必要不需設定
      shadows: [
        Shadow(
            color: StandardColor.sample, offset: Offset(1, -3), blurRadius: 2),
        Shadow(color: StandardColor.lightYellow, offset: Offset(0, -2))
      ], // list內可以設定多組shadow
      overflow: TextOverflow.ellipsis, // 超過字數如何顯示
      decoration: TextDecoration.underline, //可以設定底線或刪除線等等，color.style也要設定
      decorationColor: StandardColor.lightYellow,
      decorationStyle: TextDecorationStyle.double);

  static final heading28R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 28, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final black24R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 24, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final black22SB = TextStyle(
      //entry標題
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 22, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final grey22SB = TextStyle(
      //空白頁面
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 22, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1, // Ratio Of Font
      color: StandardColor.grey);

  static final black18B = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 18, // PX
      fontWeight: FontWeight
          .w700, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final yellow18B = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 18, // PX
      fontWeight: FontWeight
          .w700, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.yellow);

  static final yellow18R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 18, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.yellow);

  static final black18R = TextStyle(
      //注意一下weight
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 18, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final grey18R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 18, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.grey);

  static final lightGrey18R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 18, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.lightGrey);

  static final grey16B = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w700, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.grey);

  static final green16B = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w700, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.green);

  static final yellow16B = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w700, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.yellow);

  static final black16B = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w700, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final black16R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final darkGrey16R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.darkGrey);

  static final tureBlack16R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.black);

  static final yellow16R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.yellow);

  static final lightGrey16R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.lightGrey);

  static final darkGrey16U = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      shadows: const [
        Shadow(color: StandardColor.darkGrey, offset: Offset(0, -2))
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline, //可以設定底線或刪除線等等，color.style也要設定
      decorationColor: StandardColor.darkGrey,
      decorationStyle: TextDecorationStyle.solid);

  static final yellow16U = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 16, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      decoration: TextDecoration.underline,
      shadows: const [
        Shadow(color: StandardColor.yellow, offset: Offset(0, -2))
      ],
      color: Colors.transparent,
      decorationColor: StandardColor.yellow,
      decorationStyle: TextDecorationStyle.solid);

  static final black14SB = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final white14SB = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.white);

  static final yellow14SB = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.yellow);

  static final green14SB = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.green);

  static final grey14SB = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.grey);

  static final lightGrey14SB = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.lightGrey);

  static final black14R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final grey14R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.grey);

  static final yellow14R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.yellow);

  static final yellow14U = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      decoration: TextDecoration.underline,
      shadows: const [
        Shadow(color: StandardColor.yellow, offset: Offset(0, -2))
      ],
      color: Colors.transparent,
      decorationColor: StandardColor.yellow,
      decorationStyle: TextDecorationStyle.solid);

  static final black14U = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      shadows: const [
        Shadow(color: StandardColor.closeToBlack, offset: Offset(0, -2))
      ],
      color: Colors.transparent,
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      decoration: TextDecoration.underline,
      decorationColor: StandardColor.closeToBlack,
      decorationStyle: TextDecorationStyle.solid);

  static final darkGrey14C = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 14, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      decoration: TextDecoration.lineThrough,
      decorationColor: StandardColor.darkGrey,
      decorationStyle: TextDecorationStyle.solid,
      color: StandardColor.darkGrey);

  static final body12SB = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w600, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final black12R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final grey12R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.grey);

  static final yellow12R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.yellow);

  static final darkGrey12R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.darkGrey);

  static final red12R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.red);

  static final yellow12U = TextStyle(
      //註冊linkout
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      shadows: const [
        Shadow(color: StandardColor.yellow, offset: Offset(0, -2))
      ],
      color: Colors.transparent,
      decoration: TextDecoration.underline,
      decorationColor: StandardColor.yellow,
      decorationStyle: TextDecorationStyle.solid);

  static final darkGrey12U = TextStyle(
      //註冊linkout
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      decoration: TextDecoration.underline,
      shadows: const [
        Shadow(color: StandardColor.darkGrey, offset: Offset(0, -2))
      ],
      color: Colors.transparent,
      decorationColor: StandardColor.darkGrey,
      decorationStyle: TextDecorationStyle.solid);

  static final grey10R = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 12, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.5, // Ratio Of Font
      color: StandardColor.grey);

  static final nub24 = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 24, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.closeToBlack);

  static final errorAlert10 = TextStyle(
      fontFamily: GoogleFonts.montserrat().fontFamily, // Or Name
      fontSize: 24, // PX
      fontWeight: FontWeight
          .w400, // w100, w200, w300, w400, w500, w600, w700, w800, w900
      letterSpacing: 1, // PX
      wordSpacing: 1, // PX
      height: 1.3, // Ratio Of Font
      color: StandardColor.red);

  // ---- 這是這一組參數的分割線, Code 放到這線上 ----

  static const textLink = TextStyle(

      /// Styling
      );
}
