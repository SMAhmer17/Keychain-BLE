// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ble_scan_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BleScanState {

 List<BleDevice> get devices; bool get isScanning; String? get errorMessage;
/// Create a copy of BleScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleScanStateCopyWith<BleScanState> get copyWith => _$BleScanStateCopyWithImpl<BleScanState>(this as BleScanState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleScanState&&const DeepCollectionEquality().equals(other.devices, devices)&&(identical(other.isScanning, isScanning) || other.isScanning == isScanning)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(devices),isScanning,errorMessage);

@override
String toString() {
  return 'BleScanState(devices: $devices, isScanning: $isScanning, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class $BleScanStateCopyWith<$Res>  {
  factory $BleScanStateCopyWith(BleScanState value, $Res Function(BleScanState) _then) = _$BleScanStateCopyWithImpl;
@useResult
$Res call({
 List<BleDevice> devices, bool isScanning, String? errorMessage
});




}
/// @nodoc
class _$BleScanStateCopyWithImpl<$Res>
    implements $BleScanStateCopyWith<$Res> {
  _$BleScanStateCopyWithImpl(this._self, this._then);

  final BleScanState _self;
  final $Res Function(BleScanState) _then;

/// Create a copy of BleScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? devices = null,Object? isScanning = null,Object? errorMessage = freezed,}) {
  return _then(_self.copyWith(
devices: null == devices ? _self.devices : devices // ignore: cast_nullable_to_non_nullable
as List<BleDevice>,isScanning: null == isScanning ? _self.isScanning : isScanning // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [BleScanState].
extension BleScanStatePatterns on BleScanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BleScanState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BleScanState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BleScanState value)  $default,){
final _that = this;
switch (_that) {
case _BleScanState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BleScanState value)?  $default,){
final _that = this;
switch (_that) {
case _BleScanState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<BleDevice> devices,  bool isScanning,  String? errorMessage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BleScanState() when $default != null:
return $default(_that.devices,_that.isScanning,_that.errorMessage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<BleDevice> devices,  bool isScanning,  String? errorMessage)  $default,) {final _that = this;
switch (_that) {
case _BleScanState():
return $default(_that.devices,_that.isScanning,_that.errorMessage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<BleDevice> devices,  bool isScanning,  String? errorMessage)?  $default,) {final _that = this;
switch (_that) {
case _BleScanState() when $default != null:
return $default(_that.devices,_that.isScanning,_that.errorMessage);case _:
  return null;

}
}

}

/// @nodoc


class _BleScanState implements BleScanState {
  const _BleScanState({final  List<BleDevice> devices = const [], this.isScanning = false, this.errorMessage}): _devices = devices;
  

 final  List<BleDevice> _devices;
@override@JsonKey() List<BleDevice> get devices {
  if (_devices is EqualUnmodifiableListView) return _devices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_devices);
}

@override@JsonKey() final  bool isScanning;
@override final  String? errorMessage;

/// Create a copy of BleScanState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BleScanStateCopyWith<_BleScanState> get copyWith => __$BleScanStateCopyWithImpl<_BleScanState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BleScanState&&const DeepCollectionEquality().equals(other._devices, _devices)&&(identical(other.isScanning, isScanning) || other.isScanning == isScanning)&&(identical(other.errorMessage, errorMessage) || other.errorMessage == errorMessage));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_devices),isScanning,errorMessage);

@override
String toString() {
  return 'BleScanState(devices: $devices, isScanning: $isScanning, errorMessage: $errorMessage)';
}


}

/// @nodoc
abstract mixin class _$BleScanStateCopyWith<$Res> implements $BleScanStateCopyWith<$Res> {
  factory _$BleScanStateCopyWith(_BleScanState value, $Res Function(_BleScanState) _then) = __$BleScanStateCopyWithImpl;
@override @useResult
$Res call({
 List<BleDevice> devices, bool isScanning, String? errorMessage
});




}
/// @nodoc
class __$BleScanStateCopyWithImpl<$Res>
    implements _$BleScanStateCopyWith<$Res> {
  __$BleScanStateCopyWithImpl(this._self, this._then);

  final _BleScanState _self;
  final $Res Function(_BleScanState) _then;

/// Create a copy of BleScanState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? devices = null,Object? isScanning = null,Object? errorMessage = freezed,}) {
  return _then(_BleScanState(
devices: null == devices ? _self._devices : devices // ignore: cast_nullable_to_non_nullable
as List<BleDevice>,isScanning: null == isScanning ? _self.isScanning : isScanning // ignore: cast_nullable_to_non_nullable
as bool,errorMessage: freezed == errorMessage ? _self.errorMessage : errorMessage // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
