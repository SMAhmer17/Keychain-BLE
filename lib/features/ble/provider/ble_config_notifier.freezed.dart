// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ble_config_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BleConfig {

 String get serviceUuid; String get characteristicUuid;
/// Create a copy of BleConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleConfigCopyWith<BleConfig> get copyWith => _$BleConfigCopyWithImpl<BleConfig>(this as BleConfig, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleConfig&&(identical(other.serviceUuid, serviceUuid) || other.serviceUuid == serviceUuid)&&(identical(other.characteristicUuid, characteristicUuid) || other.characteristicUuid == characteristicUuid));
}


@override
int get hashCode => Object.hash(runtimeType,serviceUuid,characteristicUuid);

@override
String toString() {
  return 'BleConfig(serviceUuid: $serviceUuid, characteristicUuid: $characteristicUuid)';
}


}

/// @nodoc
abstract mixin class $BleConfigCopyWith<$Res>  {
  factory $BleConfigCopyWith(BleConfig value, $Res Function(BleConfig) _then) = _$BleConfigCopyWithImpl;
@useResult
$Res call({
 String serviceUuid, String characteristicUuid
});




}
/// @nodoc
class _$BleConfigCopyWithImpl<$Res>
    implements $BleConfigCopyWith<$Res> {
  _$BleConfigCopyWithImpl(this._self, this._then);

  final BleConfig _self;
  final $Res Function(BleConfig) _then;

/// Create a copy of BleConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? serviceUuid = null,Object? characteristicUuid = null,}) {
  return _then(_self.copyWith(
serviceUuid: null == serviceUuid ? _self.serviceUuid : serviceUuid // ignore: cast_nullable_to_non_nullable
as String,characteristicUuid: null == characteristicUuid ? _self.characteristicUuid : characteristicUuid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BleConfig].
extension BleConfigPatterns on BleConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BleConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BleConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BleConfig value)  $default,){
final _that = this;
switch (_that) {
case _BleConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BleConfig value)?  $default,){
final _that = this;
switch (_that) {
case _BleConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String serviceUuid,  String characteristicUuid)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BleConfig() when $default != null:
return $default(_that.serviceUuid,_that.characteristicUuid);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String serviceUuid,  String characteristicUuid)  $default,) {final _that = this;
switch (_that) {
case _BleConfig():
return $default(_that.serviceUuid,_that.characteristicUuid);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String serviceUuid,  String characteristicUuid)?  $default,) {final _that = this;
switch (_that) {
case _BleConfig() when $default != null:
return $default(_that.serviceUuid,_that.characteristicUuid);case _:
  return null;

}
}

}

/// @nodoc


class _BleConfig implements BleConfig {
  const _BleConfig({required this.serviceUuid, required this.characteristicUuid});
  

@override final  String serviceUuid;
@override final  String characteristicUuid;

/// Create a copy of BleConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BleConfigCopyWith<_BleConfig> get copyWith => __$BleConfigCopyWithImpl<_BleConfig>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BleConfig&&(identical(other.serviceUuid, serviceUuid) || other.serviceUuid == serviceUuid)&&(identical(other.characteristicUuid, characteristicUuid) || other.characteristicUuid == characteristicUuid));
}


@override
int get hashCode => Object.hash(runtimeType,serviceUuid,characteristicUuid);

@override
String toString() {
  return 'BleConfig(serviceUuid: $serviceUuid, characteristicUuid: $characteristicUuid)';
}


}

/// @nodoc
abstract mixin class _$BleConfigCopyWith<$Res> implements $BleConfigCopyWith<$Res> {
  factory _$BleConfigCopyWith(_BleConfig value, $Res Function(_BleConfig) _then) = __$BleConfigCopyWithImpl;
@override @useResult
$Res call({
 String serviceUuid, String characteristicUuid
});




}
/// @nodoc
class __$BleConfigCopyWithImpl<$Res>
    implements _$BleConfigCopyWith<$Res> {
  __$BleConfigCopyWithImpl(this._self, this._then);

  final _BleConfig _self;
  final $Res Function(_BleConfig) _then;

/// Create a copy of BleConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? serviceUuid = null,Object? characteristicUuid = null,}) {
  return _then(_BleConfig(
serviceUuid: null == serviceUuid ? _self.serviceUuid : serviceUuid // ignore: cast_nullable_to_non_nullable
as String,characteristicUuid: null == characteristicUuid ? _self.characteristicUuid : characteristicUuid // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
