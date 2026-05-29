// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'products_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProductsState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsState()';
}


}

/// @nodoc
class $ProductsStateCopyWith<$Res>  {
$ProductsStateCopyWith(ProductsState _, $Res Function(ProductsState) __);
}


/// Adds pattern-matching-related methods to [ProductsState].
extension ProductsStatePatterns on ProductsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ProductsLoading value)?  loading,TResult Function( ProductsLoaded value)?  loaded,TResult Function( ProductsEmpty value)?  empty,TResult Function( ProductsNoConnection value)?  noConnection,TResult Function( ProductsError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading(_that);case ProductsLoaded() when loaded != null:
return loaded(_that);case ProductsEmpty() when empty != null:
return empty(_that);case ProductsNoConnection() when noConnection != null:
return noConnection(_that);case ProductsError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ProductsLoading value)  loading,required TResult Function( ProductsLoaded value)  loaded,required TResult Function( ProductsEmpty value)  empty,required TResult Function( ProductsNoConnection value)  noConnection,required TResult Function( ProductsError value)  error,}){
final _that = this;
switch (_that) {
case ProductsLoading():
return loading(_that);case ProductsLoaded():
return loaded(_that);case ProductsEmpty():
return empty(_that);case ProductsNoConnection():
return noConnection(_that);case ProductsError():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ProductsLoading value)?  loading,TResult? Function( ProductsLoaded value)?  loaded,TResult? Function( ProductsEmpty value)?  empty,TResult? Function( ProductsNoConnection value)?  noConnection,TResult? Function( ProductsError value)?  error,}){
final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading(_that);case ProductsLoaded() when loaded != null:
return loaded(_that);case ProductsEmpty() when empty != null:
return empty(_that);case ProductsNoConnection() when noConnection != null:
return noConnection(_that);case ProductsError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  loading,TResult Function( List<Product> products)?  loaded,TResult Function()?  empty,TResult Function()?  noConnection,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading();case ProductsLoaded() when loaded != null:
return loaded(_that.products);case ProductsEmpty() when empty != null:
return empty();case ProductsNoConnection() when noConnection != null:
return noConnection();case ProductsError() when error != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  loading,required TResult Function( List<Product> products)  loaded,required TResult Function()  empty,required TResult Function()  noConnection,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ProductsLoading():
return loading();case ProductsLoaded():
return loaded(_that.products);case ProductsEmpty():
return empty();case ProductsNoConnection():
return noConnection();case ProductsError():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  loading,TResult? Function( List<Product> products)?  loaded,TResult? Function()?  empty,TResult? Function()?  noConnection,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ProductsLoading() when loading != null:
return loading();case ProductsLoaded() when loaded != null:
return loaded(_that.products);case ProductsEmpty() when empty != null:
return empty();case ProductsNoConnection() when noConnection != null:
return noConnection();case ProductsError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ProductsLoading implements ProductsState {
  const ProductsLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsState.loading()';
}


}




/// @nodoc


class ProductsLoaded implements ProductsState {
  const ProductsLoaded(final  List<Product> products): _products = products;
  

 final  List<Product> _products;
 List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsLoadedCopyWith<ProductsLoaded> get copyWith => _$ProductsLoadedCopyWithImpl<ProductsLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsLoaded&&const DeepCollectionEquality().equals(other._products, _products));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'ProductsState.loaded(products: $products)';
}


}

/// @nodoc
abstract mixin class $ProductsLoadedCopyWith<$Res> implements $ProductsStateCopyWith<$Res> {
  factory $ProductsLoadedCopyWith(ProductsLoaded value, $Res Function(ProductsLoaded) _then) = _$ProductsLoadedCopyWithImpl;
@useResult
$Res call({
 List<Product> products
});




}
/// @nodoc
class _$ProductsLoadedCopyWithImpl<$Res>
    implements $ProductsLoadedCopyWith<$Res> {
  _$ProductsLoadedCopyWithImpl(this._self, this._then);

  final ProductsLoaded _self;
  final $Res Function(ProductsLoaded) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,}) {
  return _then(ProductsLoaded(
null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,
  ));
}


}

/// @nodoc


class ProductsEmpty implements ProductsState {
  const ProductsEmpty();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsEmpty);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsState.empty()';
}


}




/// @nodoc


class ProductsNoConnection implements ProductsState {
  const ProductsNoConnection();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsNoConnection);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProductsState.noConnection()';
}


}




/// @nodoc


class ProductsError implements ProductsState {
  const ProductsError(this.message);
  

 final  String message;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProductsErrorCopyWith<ProductsError> get copyWith => _$ProductsErrorCopyWithImpl<ProductsError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProductsError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProductsState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ProductsErrorCopyWith<$Res> implements $ProductsStateCopyWith<$Res> {
  factory $ProductsErrorCopyWith(ProductsError value, $Res Function(ProductsError) _then) = _$ProductsErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ProductsErrorCopyWithImpl<$Res>
    implements $ProductsErrorCopyWith<$Res> {
  _$ProductsErrorCopyWithImpl(this._self, this._then);

  final ProductsError _self;
  final $Res Function(ProductsError) _then;

/// Create a copy of ProductsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ProductsError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
