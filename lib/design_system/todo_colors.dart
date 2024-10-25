import 'package:flutter/cupertino.dart';

class TodoColors {
  final Color backgroundColor;
  final Color textColor;

  final Color cardBackgroundColor;

  // Constructor for color themes
  const TodoColors({
    required this.backgroundColor,
    required this.textColor,
    required this.cardBackgroundColor,
  });

  // Light theme color palette
  static const light = TodoColors(
    backgroundColor: CupertinoColors.extraLightBackgroundGray,
    textColor: CupertinoColors.black,
    cardBackgroundColor: CupertinoColors.lightBackgroundGray,
  );

  // Dark theme color palette
  static const dark = TodoColors(
    backgroundColor: CupertinoColors.darkBackgroundGray,
    textColor: CupertinoColors.white,
    cardBackgroundColor: CupertinoColors.darkBackgroundGray,
  );

  // Method to get colors based on brightness
  static TodoColors getPalette(Brightness brightness) {
    return brightness == Brightness.dark ? TodoColors.dark : TodoColors.light;
  }
}
