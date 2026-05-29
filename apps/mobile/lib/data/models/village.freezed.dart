// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'village.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Village {

 String get id; String get name; String get governorate; String get markaz;
/// Create a copy of Village
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VillageCopyWith<Village> get copyWith => _$VillageCopyWithImpl<Village>(this as Village, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Village&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.markaz, markaz) || other.markaz == markaz));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,governorate,markaz);

@override
String toString() {
  return 'Village(id: $id, name: $name, governorate: $governorate, markaz: $markaz)';
}


}

/// @nodoc
abstract mixin class $VillageCopyWith<$Res>  {
  factory $VillageCopyWith(Village value, $Res Function(Village) _then) = _$VillageCopyWithImpl;
@useResult
$Res call({
 String id, String name, String governorate, String markaz
});




}
/// @nodoc
class _$VillageCopyWithImpl<$Res>
    implements $VillageCopyWith<$Res> {
  _$VillageCopyWithImpl(this._self, this._then);

  final Village _self;
  final $Res Function(Village) _then;

/// Create a copy of Village
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? governorate = null,Object? markaz = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,governorate: null == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String,markaz: null == markaz ? _self.markaz : markaz // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Village].
extension VillagePatterns on Village {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Village value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Village() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Village value)  $default,){
final _that = this;
switch (_that) {
case _Village():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Village value)?  $default,){
final _that = this;
switch (_that) {
case _Village() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String governorate,  String markaz)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Village() when $default != null:
return $default(_that.id,_that.name,_that.governorate,_that.markaz);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String governorate,  String markaz)  $default,) {final _that = this;
switch (_that) {
case _Village():
return $default(_that.id,_that.name,_that.governorate,_that.markaz);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String governorate,  String markaz)?  $default,) {final _that = this;
switch (_that) {
case _Village() when $default != null:
return $default(_that.id,_that.name,_that.governorate,_that.markaz);case _:
  return null;

}
}

}

/// @nodoc


class _Village implements Village {
  const _Village({required this.id, required this.name, required this.governorate, required this.markaz});
  

@override final  String id;
@override final  String name;
@override final  String governorate;
@override final  String markaz;

/// Create a copy of Village
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VillageCopyWith<_Village> get copyWith => __$VillageCopyWithImpl<_Village>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Village&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.governorate, governorate) || other.governorate == governorate)&&(identical(other.markaz, markaz) || other.markaz == markaz));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,governorate,markaz);

@override
String toString() {
  return 'Village(id: $id, name: $name, governorate: $governorate, markaz: $markaz)';
}


}

/// @nodoc
abstract mixin class _$VillageCopyWith<$Res> implements $VillageCopyWith<$Res> {
  factory _$VillageCopyWith(_Village value, $Res Function(_Village) _then) = __$VillageCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String governorate, String markaz
});




}
/// @nodoc
class __$VillageCopyWithImpl<$Res>
    implements _$VillageCopyWith<$Res> {
  __$VillageCopyWithImpl(this._self, this._then);

  final _Village _self;
  final $Res Function(_Village) _then;

/// Create a copy of Village
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? governorate = null,Object? markaz = null,}) {
  return _then(_Village(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,governorate: null == governorate ? _self.governorate : governorate // ignore: cast_nullable_to_non_nullable
as String,markaz: null == markaz ? _self.markaz : markaz // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
