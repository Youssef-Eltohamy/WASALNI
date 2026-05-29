// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'listing_detail_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListingDetailState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingDetailState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListingDetailState()';
}


}

/// @nodoc
class $ListingDetailStateCopyWith<$Res>  {
$ListingDetailStateCopyWith(ListingDetailState _, $Res Function(ListingDetailState) __);
}


/// Adds pattern-matching-related methods to [ListingDetailState].
extension ListingDetailStatePatterns on ListingDetailState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ListingDetailLoading value)?  loading,TResult Function( ListingDetailLoaded value)?  loaded,TResult Function( ListingDetailNoConnection value)?  noConnection,TResult Function( ListingDetailError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ListingDetailLoading() when loading != null:
return loading(_that);case ListingDetailLoaded() when loaded != null:
return loaded(_that);case ListingDetailNoConnection() when noConnection != null:
return noConnection(_that);case ListingDetailError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ListingDetailLoading value)  loading,required TResult Function( ListingDetailLoaded value)  loaded,required TResult Function( ListingDetailNoConnection value)  noConnection,required TResult Function( ListingDetailError value)  error,}){
final _that = this;
switch (_that) {
case ListingDetailLoading():
return loading(_that);case ListingDetailLoaded():
return loaded(_that);case ListingDetailNoConnection():
return noConnection(_that);case ListingDetailError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ListingDetailLoading value)?  loading,TResult? Function( ListingDetailLoaded value)?  loaded,TResult? Function( ListingDetailNoConnection value)?  noConnection,TResult? Function( ListingDetailError value)?  error,}){
final _that = this;
switch (_that) {
case ListingDetailLoading() when loading != null:
return loading(_that);case ListingDetailLoaded() when loaded != null:
return loaded(_that);case ListingDetailNoConnection() when noConnection != null:
return noConnection(_that);case ListingDetailError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( Listing listing)?  loaded,TResult Function()?  noConnection,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ListingDetailLoading() when loading != null:
return loading();case ListingDetailLoaded() when loaded != null:
return loaded(_that.listing);case ListingDetailNoConnection() when noConnection != null:
return noConnection();case ListingDetailError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( Listing listing)  loaded,required TResult Function()  noConnection,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ListingDetailLoading():
return loading();case ListingDetailLoaded():
return loaded(_that.listing);case ListingDetailNoConnection():
return noConnection();case ListingDetailError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( Listing listing)?  loaded,TResult? Function()?  noConnection,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ListingDetailLoading() when loading != null:
return loading();case ListingDetailLoaded() when loaded != null:
return loaded(_that.listing);case ListingDetailNoConnection() when noConnection != null:
return noConnection();case ListingDetailError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ListingDetailLoading implements ListingDetailState {
  const ListingDetailLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingDetailLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListingDetailState.loading()';
}


}




/// @nodoc


class ListingDetailLoaded implements ListingDetailState {
  const ListingDetailLoaded(this.listing);
  

 final  Listing listing;

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingDetailLoadedCopyWith<ListingDetailLoaded> get copyWith => _$ListingDetailLoadedCopyWithImpl<ListingDetailLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingDetailLoaded&&(identical(other.listing, listing) || other.listing == listing));
}


@override
int get hashCode => Object.hash(runtimeType,listing);

@override
String toString() {
  return 'ListingDetailState.loaded(listing: $listing)';
}


}

/// @nodoc
abstract mixin class $ListingDetailLoadedCopyWith<$Res> implements $ListingDetailStateCopyWith<$Res> {
  factory $ListingDetailLoadedCopyWith(ListingDetailLoaded value, $Res Function(ListingDetailLoaded) _then) = _$ListingDetailLoadedCopyWithImpl;
@useResult
$Res call({
 Listing listing
});


$ListingCopyWith<$Res> get listing;

}
/// @nodoc
class _$ListingDetailLoadedCopyWithImpl<$Res>
    implements $ListingDetailLoadedCopyWith<$Res> {
  _$ListingDetailLoadedCopyWithImpl(this._self, this._then);

  final ListingDetailLoaded _self;
  final $Res Function(ListingDetailLoaded) _then;

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? listing = null,}) {
  return _then(ListingDetailLoaded(
null == listing ? _self.listing : listing // ignore: cast_nullable_to_non_nullable
as Listing,
  ));
}

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ListingCopyWith<$Res> get listing {
  
  return $ListingCopyWith<$Res>(_self.listing, (value) {
    return _then(_self.copyWith(listing: value));
  });
}
}

/// @nodoc


class ListingDetailNoConnection implements ListingDetailState {
  const ListingDetailNoConnection();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingDetailNoConnection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListingDetailState.noConnection()';
}


}




/// @nodoc


class ListingDetailError implements ListingDetailState {
  const ListingDetailError(this.message);
  

 final  String message;

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ListingDetailErrorCopyWith<ListingDetailError> get copyWith => _$ListingDetailErrorCopyWithImpl<ListingDetailError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListingDetailError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ListingDetailState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ListingDetailErrorCopyWith<$Res> implements $ListingDetailStateCopyWith<$Res> {
  factory $ListingDetailErrorCopyWith(ListingDetailError value, $Res Function(ListingDetailError) _then) = _$ListingDetailErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ListingDetailErrorCopyWithImpl<$Res>
    implements $ListingDetailErrorCopyWith<$Res> {
  _$ListingDetailErrorCopyWithImpl(this._self, this._then);

  final ListingDetailError _self;
  final $Res Function(ListingDetailError) _then;

/// Create a copy of ListingDetailState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ListingDetailError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
