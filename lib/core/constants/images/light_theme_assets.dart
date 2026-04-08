import 'package:keychain_ble/core/constants/images/app_images.dart';

class LightThemeImages implements AppImages {
  final String _imagePath = 'assets/images/light/';

  @override
  String get compass => '${_imagePath}compass.png';

  //----- sori ----


  @override
  String get centerAvatar => '${_imagePath}center_avatar.png';
  @override
  String get charmConnectedAvatar => '${_imagePath}charm_connected_avatar.png';
  @override
  String get charmConnectedTail => '${_imagePath}charm_connected_tail.png';
}
