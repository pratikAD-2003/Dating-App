import 'package:flutter/material.dart';

class MyColors {
  static const Color constTheme = Color(0xFFE94057);

  static const Color btmNavSelected = Color(0xFFE94057);
  static const Color btmNavUnSelected = Color(0xFFADAFBB);

  static const Color constWhite = Color(0xFFFFFFFF);
  static const Color constBlack = Color(0xFF000000);

  static const Color constOrg = Color(0xFFF27121);
  static const Color constBrinj = Color(0xFF8A2387);

  static const Color backgroundLight = Color(0xFFf5f5f5);
  static const Color backgroundDark = Color(0xFF1d1f21);

  static Color background(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? constBlack : constWhite;

  static Color textColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? constWhite : constBlack;

  static Color themeColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark ? constBlack : constWhite;

  static Color textLightColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Color(0xffF3F3F3)
      : Colors.black.withValues(alpha: 0.7);

  static Color textLight2Color(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Colors.white.withValues(alpha: 0.7)
      : Color(0xff323755);

  static Color bottomBarColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Color(0xff1E1E1E)
      : Color(0xffF3F3F3);

  static Color hintColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Color.fromARGB(218, 232, 230, 234)
      : Colors.black.withValues(alpha: 0.4);

  static Color borderColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Color.fromARGB(218, 232, 230, 234)
      : Color(0xffE8E6EA);

  static Color chatBoxColor(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark
      ? Color(0xff1E1E1E)
      : Color(0xffF3F3F3);
}
