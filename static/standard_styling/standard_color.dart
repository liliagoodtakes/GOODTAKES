import 'package:flutter/material.dart';

class StandardColor {
  /// ---- 這是這一組參數的分割線, Code 放到這線下 ----

  /// SAMPLE
  static const sample = Color(0xFF7789C4);
  static const green = Color(0xFF2E6857);
  static const lightGreen = Color(0xFFACBF84);
  static const darkgreen = Color(0xFF20453A);
  static const yellow = Color(0xFFFCC11A);
  static const darkyellow = Color(0xFFD19F11);
  static const lightYellow = Color(0xFFFFF5DA);
  static const red = Color(0xFFF35001);
  static const lightGrey = Color(0xFFFAF9F7);
  static const darkGrey = Color(0xFF75726C);
  static const white = Color(0xFFFFFFFF);
  static const black = Color(0xFF000000);
  static const closeToBlack = Color(0xFF383734);
  static const grey = Color(0xFFBAB7B0);

  /// For YICHI's Notice:
  /// sample < 這個參數的名字，要改，不能用底線
  /// static const 是參數狀態，不用改，也不能少
  /// Color(xxxxxxxx) < 不要改
  /// 0x是必要的,
  /// 1-2 順位的 FF 是 透明度, 一般需言 用FF 就好
  /// 7789C4 是色碼, #7789C4, 所以一般來說只要換這組就好

  /// ---- 這是這一組參數的分割線, Code 放到這線上 ----
}

/// --- 以下不用動 ----
extension HexColor on Color {
  /// String is in the format "aabbcc" or "ffaabbcc" with an optional leading "#".
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Prefixes a hash sign if [leadingHashSign] is set to `true` (default is `true`).
  String toHex({bool leadingHashSign = true}) => '${leadingHashSign ? '#' : ''}'
      '${alpha.toRadixString(16).padLeft(2, '0')}'
      '${red.toRadixString(16).padLeft(2, '0')}'
      '${green.toRadixString(16).padLeft(2, '0')}'
      '${blue.toRadixString(16).padLeft(2, '0')}';
}
