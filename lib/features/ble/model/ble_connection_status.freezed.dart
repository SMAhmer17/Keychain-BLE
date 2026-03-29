// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ble_connection_status.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BleConnectionStatus {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleConnectionStatus);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BleConnectionStatus()';
}


}

/// @nodoc
class $BleConnectionStatusCopyWith<$Res>  {
$BleConnectionStatusCopyWith(BleConnectionStatus _, $Res Function(BleConnectionStatus) __);
}


/// Adds pattern-matching-related methods to [BleConnectionStatus].
extension BleConnectionStatusPatterns on BleConnectionStatus {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( BleIdle value)?  idle,TResult Function( BleConnecting value)?  connecting,TResult Function( BleConnected value)?  connected,TResult Function( BleDisconnected value)?  disconnected,TResult Function( BleError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case BleIdle() when idle != null:
return idle(_that);case BleConnecting() when connecting != null:
return connecting(_that);case BleConnected() when connected != null:
return connected(_that);case BleDisconnected() when disconnected != null:
return disconnected(_that);case BleError() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( BleIdle value)  idle,required TResult Function( BleConnecting value)  connecting,required TResult Function( BleConnected value)  connected,required TResult Function( BleDisconnected value)  disconnected,required TResult Function( BleError value)  error,}){
final _that = this;
switch (_that) {
case BleIdle():
return idle(_that);case BleConnecting():
return connecting(_that);case BleConnected():
return connected(_that);case BleDisconnected():
return disconnected(_that);case BleError():
return error(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( BleIdle value)?  idle,TResult? Function( BleConnecting value)?  connecting,TResult? Function( BleConnected value)?  connected,TResult? Function( BleDisconnected value)?  disconnected,TResult? Function( BleError value)?  error,}){
final _that = this;
switch (_that) {
case BleIdle() when idle != null:
return idle(_that);case BleConnecting() when connecting != null:
return connecting(_that);case BleConnected() when connected != null:
return connected(_that);case BleDisconnected() when disconnected != null:
return disconnected(_that);case BleError() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function( BleDevice device)?  connecting,TResult Function( BleDevice device,  BluetoothCharacteristic characteristic,  String serviceUuid,  String characteristicUuid,  int? rssi)?  connected,TResult Function( BleDevice? lastDevice)?  disconnected,TResult Function( String message,  BleDevice? device)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case BleIdle() when idle != null:
return idle();case BleConnecting() when connecting != null:
return connecting(_that.device);case BleConnected() when connected != null:
return connected(_that.device,_that.characteristic,_that.serviceUuid,_that.characteristicUuid,_that.rssi);case BleDisconnected() when disconnected != null:
return disconnected(_that.lastDevice);case BleError() when error != null:
return error(_that.message,_that.device);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function( BleDevice device)  connecting,required TResult Function( BleDevice device,  BluetoothCharacteristic characteristic,  String serviceUuid,  String characteristicUuid,  int? rssi)  connected,required TResult Function( BleDevice? lastDevice)  disconnected,required TResult Function( String message,  BleDevice? device)  error,}) {final _that = this;
switch (_that) {
case BleIdle():
return idle();case BleConnecting():
return connecting(_that.device);case BleConnected():
return connected(_that.device,_that.characteristic,_that.serviceUuid,_that.characteristicUuid,_that.rssi);case BleDisconnected():
return disconnected(_that.lastDevice);case BleError():
return error(_that.message,_that.device);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function( BleDevice device)?  connecting,TResult? Function( BleDevice device,  BluetoothCharacteristic characteristic,  String serviceUuid,  String characteristicUuid,  int? rssi)?  connected,TResult? Function( BleDevice? lastDevice)?  disconnected,TResult? Function( String message,  BleDevice? device)?  error,}) {final _that = this;
switch (_that) {
case BleIdle() when idle != null:
return idle();case BleConnecting() when connecting != null:
return connecting(_that.device);case BleConnected() when connected != null:
return connected(_that.device,_that.characteristic,_that.serviceUuid,_that.characteristicUuid,_that.rssi);case BleDisconnected() when disconnected != null:
return disconnected(_that.lastDevice);case BleError() when error != null:
return error(_that.message,_that.device);case _:
  return null;

}
}

}

/// @nodoc


class BleIdle implements BleConnectionStatus {
  const BleIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'BleConnectionStatus.idle()';
}


}




/// @nodoc


class BleConnecting implements BleConnectionStatus {
  const BleConnecting({required this.device});
  

 final  BleDevice device;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleConnectingCopyWith<BleConnecting> get copyWith => _$BleConnectingCopyWithImpl<BleConnecting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleConnecting&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode => Object.hash(runtimeType,device);

@override
String toString() {
  return 'BleConnectionStatus.connecting(device: $device)';
}


}

/// @nodoc
abstract mixin class $BleConnectingCopyWith<$Res> implements $BleConnectionStatusCopyWith<$Res> {
  factory $BleConnectingCopyWith(BleConnecting value, $Res Function(BleConnecting) _then) = _$BleConnectingCopyWithImpl;
@useResult
$Res call({
 BleDevice device
});


$BleDeviceCopyWith<$Res> get device;

}
/// @nodoc
class _$BleConnectingCopyWithImpl<$Res>
    implements $BleConnectingCopyWith<$Res> {
  _$BleConnectingCopyWithImpl(this._self, this._then);

  final BleConnecting _self;
  final $Res Function(BleConnecting) _then;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,}) {
  return _then(BleConnecting(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as BleDevice,
  ));
}

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BleDeviceCopyWith<$Res> get device {
  
  return $BleDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

/// @nodoc


class BleConnected implements BleConnectionStatus {
  const BleConnected({required this.device, required this.characteristic, required this.serviceUuid, required this.characteristicUuid, this.rssi});
  

 final  BleDevice device;
 final  BluetoothCharacteristic characteristic;
 final  String serviceUuid;
 final  String characteristicUuid;
 final  int? rssi;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleConnectedCopyWith<BleConnected> get copyWith => _$BleConnectedCopyWithImpl<BleConnected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleConnected&&(identical(other.device, device) || other.device == device)&&(identical(other.characteristic, characteristic) || other.characteristic == characteristic)&&(identical(other.serviceUuid, serviceUuid) || other.serviceUuid == serviceUuid)&&(identical(other.characteristicUuid, characteristicUuid) || other.characteristicUuid == characteristicUuid)&&(identical(other.rssi, rssi) || other.rssi == rssi));
}


@override
int get hashCode => Object.hash(runtimeType,device,characteristic,serviceUuid,characteristicUuid,rssi);

@override
String toString() {
  return 'BleConnectionStatus.connected(device: $device, characteristic: $characteristic, serviceUuid: $serviceUuid, characteristicUuid: $characteristicUuid, rssi: $rssi)';
}


}

/// @nodoc
abstract mixin class $BleConnectedCopyWith<$Res> implements $BleConnectionStatusCopyWith<$Res> {
  factory $BleConnectedCopyWith(BleConnected value, $Res Function(BleConnected) _then) = _$BleConnectedCopyWithImpl;
@useResult
$Res call({
 BleDevice device, BluetoothCharacteristic characteristic, String serviceUuid, String characteristicUuid, int? rssi
});


$BleDeviceCopyWith<$Res> get device;

}
/// @nodoc
class _$BleConnectedCopyWithImpl<$Res>
    implements $BleConnectedCopyWith<$Res> {
  _$BleConnectedCopyWithImpl(this._self, this._then);

  final BleConnected _self;
  final $Res Function(BleConnected) _then;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? device = null,Object? characteristic = null,Object? serviceUuid = null,Object? characteristicUuid = null,Object? rssi = freezed,}) {
  return _then(BleConnected(
device: null == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as BleDevice,characteristic: null == characteristic ? _self.characteristic : characteristic // ignore: cast_nullable_to_non_nullable
as BluetoothCharacteristic,serviceUuid: null == serviceUuid ? _self.serviceUuid : serviceUuid // ignore: cast_nullable_to_non_nullable
as String,characteristicUuid: null == characteristicUuid ? _self.characteristicUuid : characteristicUuid // ignore: cast_nullable_to_non_nullable
as String,rssi: freezed == rssi ? _self.rssi : rssi // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BleDeviceCopyWith<$Res> get device {
  
  return $BleDeviceCopyWith<$Res>(_self.device, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

/// @nodoc


class BleDisconnected implements BleConnectionStatus {
  const BleDisconnected({this.lastDevice});
  

 final  BleDevice? lastDevice;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleDisconnectedCopyWith<BleDisconnected> get copyWith => _$BleDisconnectedCopyWithImpl<BleDisconnected>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleDisconnected&&(identical(other.lastDevice, lastDevice) || other.lastDevice == lastDevice));
}


@override
int get hashCode => Object.hash(runtimeType,lastDevice);

@override
String toString() {
  return 'BleConnectionStatus.disconnected(lastDevice: $lastDevice)';
}


}

/// @nodoc
abstract mixin class $BleDisconnectedCopyWith<$Res> implements $BleConnectionStatusCopyWith<$Res> {
  factory $BleDisconnectedCopyWith(BleDisconnected value, $Res Function(BleDisconnected) _then) = _$BleDisconnectedCopyWithImpl;
@useResult
$Res call({
 BleDevice? lastDevice
});


$BleDeviceCopyWith<$Res>? get lastDevice;

}
/// @nodoc
class _$BleDisconnectedCopyWithImpl<$Res>
    implements $BleDisconnectedCopyWith<$Res> {
  _$BleDisconnectedCopyWithImpl(this._self, this._then);

  final BleDisconnected _self;
  final $Res Function(BleDisconnected) _then;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? lastDevice = freezed,}) {
  return _then(BleDisconnected(
lastDevice: freezed == lastDevice ? _self.lastDevice : lastDevice // ignore: cast_nullable_to_non_nullable
as BleDevice?,
  ));
}

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BleDeviceCopyWith<$Res>? get lastDevice {
    if (_self.lastDevice == null) {
    return null;
  }

  return $BleDeviceCopyWith<$Res>(_self.lastDevice!, (value) {
    return _then(_self.copyWith(lastDevice: value));
  });
}
}

/// @nodoc


class BleError implements BleConnectionStatus {
  const BleError({required this.message, this.device});
  

 final  String message;
 final  BleDevice? device;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleErrorCopyWith<BleError> get copyWith => _$BleErrorCopyWithImpl<BleError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleError&&(identical(other.message, message) || other.message == message)&&(identical(other.device, device) || other.device == device));
}


@override
int get hashCode => Object.hash(runtimeType,message,device);

@override
String toString() {
  return 'BleConnectionStatus.error(message: $message, device: $device)';
}


}

/// @nodoc
abstract mixin class $BleErrorCopyWith<$Res> implements $BleConnectionStatusCopyWith<$Res> {
  factory $BleErrorCopyWith(BleError value, $Res Function(BleError) _then) = _$BleErrorCopyWithImpl;
@useResult
$Res call({
 String message, BleDevice? device
});


$BleDeviceCopyWith<$Res>? get device;

}
/// @nodoc
class _$BleErrorCopyWithImpl<$Res>
    implements $BleErrorCopyWith<$Res> {
  _$BleErrorCopyWithImpl(this._self, this._then);

  final BleError _self;
  final $Res Function(BleError) _then;

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? device = freezed,}) {
  return _then(BleError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,device: freezed == device ? _self.device : device // ignore: cast_nullable_to_non_nullable
as BleDevice?,
  ));
}

/// Create a copy of BleConnectionStatus
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BleDeviceCopyWith<$Res>? get device {
    if (_self.device == null) {
    return null;
  }

  return $BleDeviceCopyWith<$Res>(_self.device!, (value) {
    return _then(_self.copyWith(device: value));
  });
}
}

// dart format on
