// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ble_device.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BleDevice {

 String get remoteId; String get name; int get rssi; BluetoothDevice get rawDevice;
/// Create a copy of BleDevice
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleDeviceCopyWith<BleDevice> get copyWith => _$BleDeviceCopyWithImpl<BleDevice>(this as BleDevice, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleDevice&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.name, name) || other.name == name)&&(identical(other.rssi, rssi) || other.rssi == rssi)&&(identical(other.rawDevice, rawDevice) || other.rawDevice == rawDevice));
}


@override
int get hashCode => Object.hash(runtimeType,remoteId,name,rssi,rawDevice);

@override
String toString() {
  return 'BleDevice(remoteId: $remoteId, name: $name, rssi: $rssi, rawDevice: $rawDevice)';
}


}

/// @nodoc
abstract mixin class $BleDeviceCopyWith<$Res>  {
  factory $BleDeviceCopyWith(BleDevice value, $Res Function(BleDevice) _then) = _$BleDeviceCopyWithImpl;
@useResult
$Res call({
 String remoteId, String name, int rssi, BluetoothDevice rawDevice
});




}
/// @nodoc
class _$BleDeviceCopyWithImpl<$Res>
    implements $BleDeviceCopyWith<$Res> {
  _$BleDeviceCopyWithImpl(this._self, this._then);

  final BleDevice _self;
  final $Res Function(BleDevice) _then;

/// Create a copy of BleDevice
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? remoteId = null,Object? name = null,Object? rssi = null,Object? rawDevice = null,}) {
  return _then(_self.copyWith(
remoteId: null == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rssi: null == rssi ? _self.rssi : rssi // ignore: cast_nullable_to_non_nullable
as int,rawDevice: null == rawDevice ? _self.rawDevice : rawDevice // ignore: cast_nullable_to_non_nullable
as BluetoothDevice,
  ));
}

}


/// Adds pattern-matching-related methods to [BleDevice].
extension BleDevicePatterns on BleDevice {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BleDevice value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BleDevice() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BleDevice value)  $default,){
final _that = this;
switch (_that) {
case _BleDevice():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BleDevice value)?  $default,){
final _that = this;
switch (_that) {
case _BleDevice() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String remoteId,  String name,  int rssi,  BluetoothDevice rawDevice)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BleDevice() when $default != null:
return $default(_that.remoteId,_that.name,_that.rssi,_that.rawDevice);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String remoteId,  String name,  int rssi,  BluetoothDevice rawDevice)  $default,) {final _that = this;
switch (_that) {
case _BleDevice():
return $default(_that.remoteId,_that.name,_that.rssi,_that.rawDevice);case _:
  throw StateError('Unexpected subclass');

}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String remoteId,  String name,  int rssi,  BluetoothDevice rawDevice)?  $default,) {final _that = this;
switch (_that) {
case _BleDevice() when $default != null:
return $default(_that.remoteId,_that.name,_that.rssi,_that.rawDevice);case _:
  return null;

}
}

}

/// @nodoc


class _BleDevice implements BleDevice {
  const _BleDevice({required this.remoteId, required this.name, required this.rssi, required this.rawDevice});
  

@override final  String remoteId;
@override final  String name;
@override final  int rssi;
@override final  BluetoothDevice rawDevice;

/// Create a copy of BleDevice
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BleDeviceCopyWith<_BleDevice> get copyWith => __$BleDeviceCopyWithImpl<_BleDevice>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BleDevice&&(identical(other.remoteId, remoteId) || other.remoteId == remoteId)&&(identical(other.name, name) || other.name == name)&&(identical(other.rssi, rssi) || other.rssi == rssi)&&(identical(other.rawDevice, rawDevice) || other.rawDevice == rawDevice));
}


@override
int get hashCode => Object.hash(runtimeType,remoteId,name,rssi,rawDevice);

@override
String toString() {
  return 'BleDevice(remoteId: $remoteId, name: $name, rssi: $rssi, rawDevice: $rawDevice)';
}


}

/// @nodoc
abstract mixin class _$BleDeviceCopyWith<$Res> implements $BleDeviceCopyWith<$Res> {
  factory _$BleDeviceCopyWith(_BleDevice value, $Res Function(_BleDevice) _then) = __$BleDeviceCopyWithImpl;
@override @useResult
$Res call({
 String remoteId, String name, int rssi, BluetoothDevice rawDevice
});




}
/// @nodoc
class __$BleDeviceCopyWithImpl<$Res>
    implements _$BleDeviceCopyWith<$Res> {
  __$BleDeviceCopyWithImpl(this._self, this._then);

  final _BleDevice _self;
  final $Res Function(_BleDevice) _then;

/// Create a copy of BleDevice
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? remoteId = null,Object? name = null,Object? rssi = null,Object? rawDevice = null,}) {
  return _then(_BleDevice(
remoteId: null == remoteId ? _self.remoteId : remoteId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,rssi: null == rssi ? _self.rssi : rssi // ignore: cast_nullable_to_non_nullable
as int,rawDevice: null == rawDevice ? _self.rawDevice : rawDevice // ignore: cast_nullable_to_non_nullable
as BluetoothDevice,
  ));
}


}

// dart format on
