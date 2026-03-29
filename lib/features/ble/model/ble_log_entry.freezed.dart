// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ble_log_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BleLogEntry {

 DateTime get timestamp; BleLogDirection get direction; String get payload;
/// Create a copy of BleLogEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BleLogEntryCopyWith<BleLogEntry> get copyWith => _$BleLogEntryCopyWithImpl<BleLogEntry>(this as BleLogEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BleLogEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.payload, payload) || other.payload == payload));
}


@override
int get hashCode => Object.hash(runtimeType,timestamp,direction,payload);

@override
String toString() {
  return 'BleLogEntry(timestamp: $timestamp, direction: $direction, payload: $payload)';
}


}

/// @nodoc
abstract mixin class $BleLogEntryCopyWith<$Res>  {
  factory $BleLogEntryCopyWith(BleLogEntry value, $Res Function(BleLogEntry) _then) = _$BleLogEntryCopyWithImpl;
@useResult
$Res call({
 DateTime timestamp, BleLogDirection direction, String payload
});




}
/// @nodoc
class _$BleLogEntryCopyWithImpl<$Res>
    implements $BleLogEntryCopyWith<$Res> {
  _$BleLogEntryCopyWithImpl(this._self, this._then);

  final BleLogEntry _self;
  final $Res Function(BleLogEntry) _then;

/// Create a copy of BleLogEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? timestamp = null,Object? direction = null,Object? payload = null,}) {
  return _then(_self.copyWith(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as BleLogDirection,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [BleLogEntry].
extension BleLogEntryPatterns on BleLogEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BleLogEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BleLogEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BleLogEntry value)  $default,){
final _that = this;
switch (_that) {
case _BleLogEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BleLogEntry value)?  $default,){
final _that = this;
switch (_that) {
case _BleLogEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime timestamp,  BleLogDirection direction,  String payload)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BleLogEntry() when $default != null:
return $default(_that.timestamp,_that.direction,_that.payload);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime timestamp,  BleLogDirection direction,  String payload)  $default,) {final _that = this;
switch (_that) {
case _BleLogEntry():
return $default(_that.timestamp,_that.direction,_that.payload);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime timestamp,  BleLogDirection direction,  String payload)?  $default,) {final _that = this;
switch (_that) {
case _BleLogEntry() when $default != null:
return $default(_that.timestamp,_that.direction,_that.payload);case _:
  return null;

}
}

}

/// @nodoc


class _BleLogEntry implements BleLogEntry {
  const _BleLogEntry({required this.timestamp, required this.direction, required this.payload});
  

@override final  DateTime timestamp;
@override final  BleLogDirection direction;
@override final  String payload;

/// Create a copy of BleLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BleLogEntryCopyWith<_BleLogEntry> get copyWith => __$BleLogEntryCopyWithImpl<_BleLogEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BleLogEntry&&(identical(other.timestamp, timestamp) || other.timestamp == timestamp)&&(identical(other.direction, direction) || other.direction == direction)&&(identical(other.payload, payload) || other.payload == payload));
}


@override
int get hashCode => Object.hash(runtimeType,timestamp,direction,payload);

@override
String toString() {
  return 'BleLogEntry(timestamp: $timestamp, direction: $direction, payload: $payload)';
}


}

/// @nodoc
abstract mixin class _$BleLogEntryCopyWith<$Res> implements $BleLogEntryCopyWith<$Res> {
  factory _$BleLogEntryCopyWith(_BleLogEntry value, $Res Function(_BleLogEntry) _then) = __$BleLogEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime timestamp, BleLogDirection direction, String payload
});




}
/// @nodoc
class __$BleLogEntryCopyWithImpl<$Res>
    implements _$BleLogEntryCopyWith<$Res> {
  __$BleLogEntryCopyWithImpl(this._self, this._then);

  final _BleLogEntry _self;
  final $Res Function(_BleLogEntry) _then;

/// Create a copy of BleLogEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? timestamp = null,Object? direction = null,Object? payload = null,}) {
  return _then(_BleLogEntry(
timestamp: null == timestamp ? _self.timestamp : timestamp // ignore: cast_nullable_to_non_nullable
as DateTime,direction: null == direction ? _self.direction : direction // ignore: cast_nullable_to_non_nullable
as BleLogDirection,payload: null == payload ? _self.payload : payload // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
