import 'package:keychain_ble/core/constants/icons/app_icons.dart';

class DarkThemeIcons implements AppIcons {
  final String _iconPath = 'assets/icons/dark/';

  @override
  String get refresh => '${_iconPath}refresh.svg';

  @override
  String get visible => '${_iconPath}visible.svg';

  @override
  String get invisible => '${_iconPath}invisible.svg';

  //----- sori ----

  @override
  String get appName => '${_iconPath}app_name.svg';
  @override
  String get bottomLeftDots => '${_iconPath}bottom_left_dots.svg';
  @override
  String get bottomRightDots => '${_iconPath}bottom_right_dots.svg';
  @override
  String get centerCircleDots => '${_iconPath}center_circle_dots.svg';
  @override
  String get centerDots => '${_iconPath}center_dots.svg';
  @override
  String get heartBeads => '${_iconPath}heart_beads.svg';
  @override
  String get starBeads => '${_iconPath}star_beads.svg';
  @override
  String get plusBeads => '${_iconPath}plus_beads.svg';
  @override
  String get braceletTab => '${_iconPath}bracelt_tab.svg';
  @override
  String get settingsTab => '${_iconPath}settings_tab.svg';
  @override
  String get uploadTab => '${_iconPath}upload_tab.svg';
  @override
  String get homeTab => '${_iconPath}home_tab.svg';
  @override
  String get avatarBgDots => '${_iconPath}avatar_bg_dots.svg';
}
