// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Listing {

 String get id; ListingKind get kind; String get ownerId; String get villageId; String get categoryId; String get name; String get bio; String get phoneWhatsapp; String? get logoUrl; ListingStatus get status; bool get isVerified; bool get isFeatured; ListingPlan get plan; bool get isTemporarilyClosed; DateTime get createdAt;
/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingCopyWith<Listing> get copyWith => _$ListingCopyWithImpl<Listing>(this as Listing, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Listing&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.phoneWhatsapp, phoneWhatsapp) || other.phoneWhatsapp == phoneWhatsapp)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.isTemporarilyClosed, isTemporarilyClosed) || other.isTemporarilyClosed == isTemporarilyClosed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,ownerId,villageId,categoryId,name,bio,phoneWhatsapp,logoUrl,status,isVerified,isFeatured,plan,isTemporarilyClosed,createdAt);

@override
String toString() {
  return 'Listing(id: $id, kind: $kind, ownerId: $ownerId, villageId: $villageId, categoryId: $categoryId, name: $name, bio: $bio, phoneWhatsapp: $phoneWhatsapp, logoUrl: $logoUrl, status: $status, isVerified: $isVerified, isFeatured: $isFeatured, plan: $plan, isTemporarilyClosed: $isTemporarilyClosed, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ListingCopyWith<$Res>  {
  factory $ListingCopyWith(Listing value, $Res Function(Listing) _then) = _$ListingCopyWithImpl;
@useResult
$Res call({
 String id, ListingKind kind, String ownerId, String villageId, String categoryId, String name, String bio, String phoneWhatsapp, String? logoUrl, ListingStatus status, bool isVerified, bool isFeatured, ListingPlan plan, bool isTemporarilyClosed, DateTime createdAt
});




}
/// @nodoc
class _$ListingCopyWithImpl<$Res>
    implements $ListingCopyWith<$Res> {
  _$ListingCopyWithImpl(this._self, this._then);

  final Listing _self;
  final $Res Function(Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? kind = null,Object? ownerId = null,Object? villageId = null,Object? categoryId = null,Object? name = null,Object? bio = null,Object? phoneWhatsapp = null,Object? logoUrl = freezed,Object? status = null,Object? isVerified = null,Object? isFeatured = null,Object? plan = null,Object? isTemporarilyClosed = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ListingKind,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,villageId: null == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,phoneWhatsapp: null == phoneWhatsapp ? _self.phoneWhatsapp : phoneWhatsapp // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as ListingPlan,isTemporarilyClosed: null == isTemporarilyClosed ? _self.isTemporarilyClosed : isTemporarilyClosed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [Listing].
extension ListingPatterns on Listing {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Listing value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Listing value)  $default,){
final _that = this;
switch (_that) {
case _Listing():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Listing value)?  $default,){
final _that = this;
switch (_that) {
case _Listing() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  ListingKind kind,  String ownerId,  String villageId,  String categoryId,  String name,  String bio,  String phoneWhatsapp,  String? logoUrl,  ListingStatus status,  bool isVerified,  bool isFeatured,  ListingPlan plan,  bool isTemporarilyClosed,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.kind,_that.ownerId,_that.villageId,_that.categoryId,_that.name,_that.bio,_that.phoneWhatsapp,_that.logoUrl,_that.status,_that.isVerified,_that.isFeatured,_that.plan,_that.isTemporarilyClosed,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  ListingKind kind,  String ownerId,  String villageId,  String categoryId,  String name,  String bio,  String phoneWhatsapp,  String? logoUrl,  ListingStatus status,  bool isVerified,  bool isFeatured,  ListingPlan plan,  bool isTemporarilyClosed,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _Listing():
return $default(_that.id,_that.kind,_that.ownerId,_that.villageId,_that.categoryId,_that.name,_that.bio,_that.phoneWhatsapp,_that.logoUrl,_that.status,_that.isVerified,_that.isFeatured,_that.plan,_that.isTemporarilyClosed,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  ListingKind kind,  String ownerId,  String villageId,  String categoryId,  String name,  String bio,  String phoneWhatsapp,  String? logoUrl,  ListingStatus status,  bool isVerified,  bool isFeatured,  ListingPlan plan,  bool isTemporarilyClosed,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _Listing() when $default != null:
return $default(_that.id,_that.kind,_that.ownerId,_that.villageId,_that.categoryId,_that.name,_that.bio,_that.phoneWhatsapp,_that.logoUrl,_that.status,_that.isVerified,_that.isFeatured,_that.plan,_that.isTemporarilyClosed,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _Listing implements Listing {
  const _Listing({required this.id, required this.kind, required this.ownerId, required this.villageId, required this.categoryId, required this.name, required this.bio, required this.phoneWhatsapp, this.logoUrl, this.status = ListingStatus.active, this.isVerified = false, this.isFeatured = false, this.plan = ListingPlan.free, this.isTemporarilyClosed = false, required this.createdAt});
  

@override final  String id;
@override final  ListingKind kind;
@override final  String ownerId;
@override final  String villageId;
@override final  String categoryId;
@override final  String name;
@override final  String bio;
@override final  String phoneWhatsapp;
@override final  String? logoUrl;
@override@JsonKey() final  ListingStatus status;
@override@JsonKey() final  bool isVerified;
@override@JsonKey() final  bool isFeatured;
@override@JsonKey() final  ListingPlan plan;
@override@JsonKey() final  bool isTemporarilyClosed;
@override final  DateTime createdAt;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ListingCopyWith<_Listing> get copyWith => __$ListingCopyWithImpl<_Listing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Listing&&(identical(other.id, id) || other.id == id)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.ownerId, ownerId) || other.ownerId == ownerId)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.name, name) || other.name == name)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.phoneWhatsapp, phoneWhatsapp) || other.phoneWhatsapp == phoneWhatsapp)&&(identical(other.logoUrl, logoUrl) || other.logoUrl == logoUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.isVerified, isVerified) || other.isVerified == isVerified)&&(identical(other.isFeatured, isFeatured) || other.isFeatured == isFeatured)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.isTemporarilyClosed, isTemporarilyClosed) || other.isTemporarilyClosed == isTemporarilyClosed)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,kind,ownerId,villageId,categoryId,name,bio,phoneWhatsapp,logoUrl,status,isVerified,isFeatured,plan,isTemporarilyClosed,createdAt);

@override
String toString() {
  return 'Listing(id: $id, kind: $kind, ownerId: $ownerId, villageId: $villageId, categoryId: $categoryId, name: $name, bio: $bio, phoneWhatsapp: $phoneWhatsapp, logoUrl: $logoUrl, status: $status, isVerified: $isVerified, isFeatured: $isFeatured, plan: $plan, isTemporarilyClosed: $isTemporarilyClosed, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ListingCopyWith<$Res> implements $ListingCopyWith<$Res> {
  factory _$ListingCopyWith(_Listing value, $Res Function(_Listing) _then) = __$ListingCopyWithImpl;
@override @useResult
$Res call({
 String id, ListingKind kind, String ownerId, String villageId, String categoryId, String name, String bio, String phoneWhatsapp, String? logoUrl, ListingStatus status, bool isVerified, bool isFeatured, ListingPlan plan, bool isTemporarilyClosed, DateTime createdAt
});




}
/// @nodoc
class __$ListingCopyWithImpl<$Res>
    implements _$ListingCopyWith<$Res> {
  __$ListingCopyWithImpl(this._self, this._then);

  final _Listing _self;
  final $Res Function(_Listing) _then;

/// Create a copy of Listing
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? kind = null,Object? ownerId = null,Object? villageId = null,Object? categoryId = null,Object? name = null,Object? bio = null,Object? phoneWhatsapp = null,Object? logoUrl = freezed,Object? status = null,Object? isVerified = null,Object? isFeatured = null,Object? plan = null,Object? isTemporarilyClosed = null,Object? createdAt = null,}) {
  return _then(_Listing(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ListingKind,ownerId: null == ownerId ? _self.ownerId : ownerId // ignore: cast_nullable_to_non_nullable
as String,villageId: null == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as String,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,phoneWhatsapp: null == phoneWhatsapp ? _self.phoneWhatsapp : phoneWhatsapp // ignore: cast_nullable_to_non_nullable
as String,logoUrl: freezed == logoUrl ? _self.logoUrl : logoUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ListingStatus,isVerified: null == isVerified ? _self.isVerified : isVerified // ignore: cast_nullable_to_non_nullable
as bool,isFeatured: null == isFeatured ? _self.isFeatured : isFeatured // ignore: cast_nullable_to_non_nullable
as bool,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as ListingPlan,isTemporarilyClosed: null == isTemporarilyClosed ? _self.isTemporarilyClosed : isTemporarilyClosed // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
