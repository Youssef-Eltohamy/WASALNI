// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$FeedState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState()';
}


}

/// @nodoc
class $FeedStateCopyWith<$Res>  {
$FeedStateCopyWith(FeedState _, $Res Function(FeedState) __);
}


/// Adds pattern-matching-related methods to [FeedState].
extension FeedStatePatterns on FeedState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( FeedLoading value)?  loading,TResult Function( FeedLoaded value)?  loaded,TResult Function( FeedEmpty value)?  empty,TResult Function( FeedNoConnection value)?  noConnection,TResult Function( FeedError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedEmpty() when empty != null:
return empty(_that);case FeedNoConnection() when noConnection != null:
return noConnection(_that);case FeedError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( FeedLoading value)  loading,required TResult Function( FeedLoaded value)  loaded,required TResult Function( FeedEmpty value)  empty,required TResult Function( FeedNoConnection value)  noConnection,required TResult Function( FeedError value)  error,}){
final _that = this;
switch (_that) {
case FeedLoading():
return loading(_that);case FeedLoaded():
return loaded(_that);case FeedEmpty():
return empty(_that);case FeedNoConnection():
return noConnection(_that);case FeedError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( FeedLoading value)?  loading,TResult? Function( FeedLoaded value)?  loaded,TResult? Function( FeedEmpty value)?  empty,TResult? Function( FeedNoConnection value)?  noConnection,TResult? Function( FeedError value)?  error,}){
final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading(_that);case FeedLoaded() when loaded != null:
return loaded(_that);case FeedEmpty() when empty != null:
return empty(_that);case FeedNoConnection() when noConnection != null:
return noConnection(_that);case FeedError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Listing> listings,  String? villageId,  ListingKind? kind)?  loaded,TResult Function()?  empty,TResult Function()?  noConnection,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.listings,_that.villageId,_that.kind);case FeedEmpty() when empty != null:
return empty();case FeedNoConnection() when noConnection != null:
return noConnection();case FeedError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Listing> listings,  String? villageId,  ListingKind? kind)  loaded,required TResult Function()  empty,required TResult Function()  noConnection,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case FeedLoading():
return loading();case FeedLoaded():
return loaded(_that.listings,_that.villageId,_that.kind);case FeedEmpty():
return empty();case FeedNoConnection():
return noConnection();case FeedError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Listing> listings,  String? villageId,  ListingKind? kind)?  loaded,TResult? Function()?  empty,TResult? Function()?  noConnection,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case FeedLoading() when loading != null:
return loading();case FeedLoaded() when loaded != null:
return loaded(_that.listings,_that.villageId,_that.kind);case FeedEmpty() when empty != null:
return empty();case FeedNoConnection() when noConnection != null:
return noConnection();case FeedError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class FeedLoading implements FeedState {
  const FeedLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.loading()';
}


}




/// @nodoc


class FeedLoaded implements FeedState {
  const FeedLoaded(final  List<Listing> listings, {this.villageId, this.kind}): _listings = listings;
  

 final  List<Listing> _listings;
 List<Listing> get listings {
  if (_listings is EqualUnmodifiableListView) return _listings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_listings);
}

 final  String? villageId;
 final  ListingKind? kind;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedLoadedCopyWith<FeedLoaded> get copyWith => _$FeedLoadedCopyWithImpl<FeedLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedLoaded&&const DeepCollectionEquality().equals(other._listings, _listings)&&(identical(other.villageId, villageId) || other.villageId == villageId)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_listings),villageId,kind);

@override
String toString() {
  return 'FeedState.loaded(listings: $listings, villageId: $villageId, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $FeedLoadedCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedLoadedCopyWith(FeedLoaded value, $Res Function(FeedLoaded) _then) = _$FeedLoadedCopyWithImpl;
@useResult
$Res call({
 List<Listing> listings, String? villageId, ListingKind? kind
});




}
/// @nodoc
class _$FeedLoadedCopyWithImpl<$Res>
    implements $FeedLoadedCopyWith<$Res> {
  _$FeedLoadedCopyWithImpl(this._self, this._then);

  final FeedLoaded _self;
  final $Res Function(FeedLoaded) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? listings = null,Object? villageId = freezed,Object? kind = freezed,}) {
  return _then(FeedLoaded(
null == listings ? _self._listings : listings // ignore: cast_nullable_to_non_nullable
as List<Listing>,villageId: freezed == villageId ? _self.villageId : villageId // ignore: cast_nullable_to_non_nullable
as String?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as ListingKind?,
  ));
}


}

/// @nodoc


class FeedEmpty implements FeedState {
  const FeedEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.empty()';
}


}




/// @nodoc


class FeedNoConnection implements FeedState {
  const FeedNoConnection();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedNoConnection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'FeedState.noConnection()';
}


}




/// @nodoc


class FeedError implements FeedState {
  const FeedError(this.message);
  

 final  String message;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedErrorCopyWith<FeedError> get copyWith => _$FeedErrorCopyWithImpl<FeedError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'FeedState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $FeedErrorCopyWith<$Res> implements $FeedStateCopyWith<$Res> {
  factory $FeedErrorCopyWith(FeedError value, $Res Function(FeedError) _then) = _$FeedErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$FeedErrorCopyWithImpl<$Res>
    implements $FeedErrorCopyWith<$Res> {
  _$FeedErrorCopyWithImpl(this._self, this._then);

  final FeedError _self;
  final $Res Function(FeedError) _then;

/// Create a copy of FeedState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(FeedError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
