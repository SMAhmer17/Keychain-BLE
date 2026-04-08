import 'package:flutter/material.dart';
import 'package:keychain_ble/core/constants/colors/dark_theme_colors.dart';
import 'package:keychain_ble/core/constants/colors/light_theme_colors.dart';
import 'package:keychain_ble/core/themes/app_typography.dart';
import 'package:keychain_ble/core/themes/dark_theme.dart';
import 'package:keychain_ble/core/themes/light_theme.dart';
import 'package:keychain_ble/core/utils/utils.dart';

final ThemeData soriLightTheme = lightTheme.copyWith(
  textTheme: lightTheme.textTheme.apply(fontFamily: Utils.kPuntoFontFamily),
  extensions: [
    AppTypography(
      interBase: TextStyle(
        fontFamily: Utils.kPuntoFontFamily,
        color: LightThemeColors.textPrimary,
      ),
    ),
  ],
);

final ThemeData soriDarkTheme = darkTheme.copyWith(
  textTheme: darkTheme.textTheme.apply(fontFamily: Utils.kPuntoFontFamily),
  extensions: [
    AppTypography(
      interBase: TextStyle(
        fontFamily: Utils.kPuntoFontFamily,
        color: DarkThemeColors.textPrimary,
      ),
    ),
  ],
);
