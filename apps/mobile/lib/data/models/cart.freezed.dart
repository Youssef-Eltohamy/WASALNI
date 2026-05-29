// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CartLine {

 String get productId; String get name; double get priceEgp; int get qty; bool get isUnavailable; double? get latestPriceEgp;
/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartLineCopyWith<CartLine> get copyWith => _$CartLineCopyWithImpl<CartLine>(this as CartLine, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CartLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceEgp, priceEgp) || other.priceEgp == priceEgp)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.isUnavailable, isUnavailable) || other.isUnavailable == isUnavailable)&&(identical(other.latestPriceEgp, latestPriceEgp) || other.latestPriceEgp == latestPriceEgp));
}


@override
int get hashCode => Object.hash(runtimeType,productId,name,priceEgp,qty,isUnavailable,latestPriceEgp);

@override
String toString() {
  return 'CartLine(productId: $productId, name: $name, priceEgp: $priceEgp, qty: $qty, isUnavailable: $isUnavailable, latestPriceEgp: $latestPriceEgp)';
}


}

/// @nodoc
abstract mixin class $CartLineCopyWith<$Res>  {
  factory $CartLineCopyWith(CartLine value, $Res Function(CartLine) _then) = _$CartLineCopyWithImpl;
@useResult
$Res call({
 String productId, String name, double priceEgp, int qty, bool isUnavailable, double? latestPriceEgp
});




}
/// @nodoc
class _$CartLineCopyWithImpl<$Res>
    implements $CartLineCopyWith<$Res> {
  _$CartLineCopyWithImpl(this._self, this._then);

  final CartLine _self;
  final $Res Function(CartLine) _then;

/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? productId = null,Object? name = null,Object? priceEgp = null,Object? qty = null,Object? isUnavailable = null,Object? latestPriceEgp = freezed,}) {
  return _then(_self.copyWith(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceEgp: null == priceEgp ? _self.priceEgp : priceEgp // ignore: cast_nullable_to_non_nullable
as double,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,isUnavailable: null == isUnavailable ? _self.isUnavailable : isUnavailable // ignore: cast_nullable_to_non_nullable
as bool,latestPriceEgp: freezed == latestPriceEgp ? _self.latestPriceEgp : latestPriceEgp // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}

}


/// Adds pattern-matching-related methods to [CartLine].
extension CartLinePatterns on CartLine {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CartLine value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CartLine() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CartLine value)  $default,){
final _that = this;
switch (_that) {
case _CartLine():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CartLine value)?  $default,){
final _that = this;
switch (_that) {
case _CartLine() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String productId,  String name,  double priceEgp,  int qty,  bool isUnavailable,  double? latestPriceEgp)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CartLine() when $default != null:
return $default(_that.productId,_that.name,_that.priceEgp,_that.qty,_that.isUnavailable,_that.latestPriceEgp);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String productId,  String name,  double priceEgp,  int qty,  bool isUnavailable,  double? latestPriceEgp)  $default,) {final _that = this;
switch (_that) {
case _CartLine():
return $default(_that.productId,_that.name,_that.priceEgp,_that.qty,_that.isUnavailable,_that.latestPriceEgp);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String productId,  String name,  double priceEgp,  int qty,  bool isUnavailable,  double? latestPriceEgp)?  $default,) {final _that = this;
switch (_that) {
case _CartLine() when $default != null:
return $default(_that.productId,_that.name,_that.priceEgp,_that.qty,_that.isUnavailable,_that.latestPriceEgp);case _:
  return null;

}
}

}

/// @nodoc


class _CartLine extends CartLine {
  const _CartLine({required this.productId, required this.name, required this.priceEgp, this.qty = 1, this.isUnavailable = false, this.latestPriceEgp}): super._();
  

@override final  String productId;
@override final  String name;
@override final  double priceEgp;
@override@JsonKey() final  int qty;
@override@JsonKey() final  bool isUnavailable;
@override final  double? latestPriceEgp;

/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartLineCopyWith<_CartLine> get copyWith => __$CartLineCopyWithImpl<_CartLine>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CartLine&&(identical(other.productId, productId) || other.productId == productId)&&(identical(other.name, name) || other.name == name)&&(identical(other.priceEgp, priceEgp) || other.priceEgp == priceEgp)&&(identical(other.qty, qty) || other.qty == qty)&&(identical(other.isUnavailable, isUnavailable) || other.isUnavailable == isUnavailable)&&(identical(other.latestPriceEgp, latestPriceEgp) || other.latestPriceEgp == latestPriceEgp));
}


@override
int get hashCode => Object.hash(runtimeType,productId,name,priceEgp,qty,isUnavailable,latestPriceEgp);

@override
String toString() {
  return 'CartLine(productId: $productId, name: $name, priceEgp: $priceEgp, qty: $qty, isUnavailable: $isUnavailable, latestPriceEgp: $latestPriceEgp)';
}


}

/// @nodoc
abstract mixin class _$CartLineCopyWith<$Res> implements $CartLineCopyWith<$Res> {
  factory _$CartLineCopyWith(_CartLine value, $Res Function(_CartLine) _then) = __$CartLineCopyWithImpl;
@override @useResult
$Res call({
 String productId, String name, double priceEgp, int qty, bool isUnavailable, double? latestPriceEgp
});




}
/// @nodoc
class __$CartLineCopyWithImpl<$Res>
    implements _$CartLineCopyWith<$Res> {
  __$CartLineCopyWithImpl(this._self, this._then);

  final _CartLine _self;
  final $Res Function(_CartLine) _then;

/// Create a copy of CartLine
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? productId = null,Object? name = null,Object? priceEgp = null,Object? qty = null,Object? isUnavailable = null,Object? latestPriceEgp = freezed,}) {
  return _then(_CartLine(
productId: null == productId ? _self.productId : productId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,priceEgp: null == priceEgp ? _self.priceEgp : priceEgp // ignore: cast_nullable_to_non_nullable
as double,qty: null == qty ? _self.qty : qty // ignore: cast_nullable_to_non_nullable
as int,isUnavailable: null == isUnavailable ? _self.isUnavailable : isUnavailable // ignore: cast_nullable_to_non_nullable
as bool,latestPriceEgp: freezed == latestPriceEgp ? _self.latestPriceEgp : latestPriceEgp // ignore: cast_nullable_to_non_nullable
as double?,
  ));
}


}

/// @nodoc
mixin _$ShopCart {

 String get shopId; String get shopName; String get shopPhone; List<CartLine> get lines;
/// Create a copy of ShopCart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopCartCopyWith<ShopCart> get copyWith => _$ShopCartCopyWithImpl<ShopCart>(this as ShopCart, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopCart&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.shopPhone, shopPhone) || other.shopPhone == shopPhone)&&const DeepCollectionEquality().equals(other.lines, lines));
}


@override
int get hashCode => Object.hash(runtimeType,shopId,shopName,shopPhone,const DeepCollectionEquality().hash(lines));

@override
String toString() {
  return 'ShopCart(shopId: $shopId, shopName: $shopName, shopPhone: $shopPhone, lines: $lines)';
}


}

/// @nodoc
abstract mixin class $ShopCartCopyWith<$Res>  {
  factory $ShopCartCopyWith(ShopCart value, $Res Function(ShopCart) _then) = _$ShopCartCopyWithImpl;
@useResult
$Res call({
 String shopId, String shopName, String shopPhone, List<CartLine> lines
});




}
/// @nodoc
class _$ShopCartCopyWithImpl<$Res>
    implements $ShopCartCopyWith<$Res> {
  _$ShopCartCopyWithImpl(this._self, this._then);

  final ShopCart _self;
  final $Res Function(ShopCart) _then;

/// Create a copy of ShopCart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shopId = null,Object? shopName = null,Object? shopPhone = null,Object? lines = null,}) {
  return _then(_self.copyWith(
shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,shopName: null == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String,shopPhone: null == shopPhone ? _self.shopPhone : shopPhone // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self.lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLine>,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopCart].
extension ShopCartPatterns on ShopCart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopCart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopCart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopCart value)  $default,){
final _that = this;
switch (_that) {
case _ShopCart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopCart value)?  $default,){
final _that = this;
switch (_that) {
case _ShopCart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String shopId,  String shopName,  String shopPhone,  List<CartLine> lines)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopCart() when $default != null:
return $default(_that.shopId,_that.shopName,_that.shopPhone,_that.lines);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String shopId,  String shopName,  String shopPhone,  List<CartLine> lines)  $default,) {final _that = this;
switch (_that) {
case _ShopCart():
return $default(_that.shopId,_that.shopName,_that.shopPhone,_that.lines);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String shopId,  String shopName,  String shopPhone,  List<CartLine> lines)?  $default,) {final _that = this;
switch (_that) {
case _ShopCart() when $default != null:
return $default(_that.shopId,_that.shopName,_that.shopPhone,_that.lines);case _:
  return null;

}
}

}

/// @nodoc


class _ShopCart extends ShopCart {
  const _ShopCart({required this.shopId, required this.shopName, required this.shopPhone, final  List<CartLine> lines = const <CartLine>[]}): _lines = lines,super._();
  

@override final  String shopId;
@override final  String shopName;
@override final  String shopPhone;
 final  List<CartLine> _lines;
@override@JsonKey() List<CartLine> get lines {
  if (_lines is EqualUnmodifiableListView) return _lines;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_lines);
}


/// Create a copy of ShopCart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopCartCopyWith<_ShopCart> get copyWith => __$ShopCartCopyWithImpl<_ShopCart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopCart&&(identical(other.shopId, shopId) || other.shopId == shopId)&&(identical(other.shopName, shopName) || other.shopName == shopName)&&(identical(other.shopPhone, shopPhone) || other.shopPhone == shopPhone)&&const DeepCollectionEquality().equals(other._lines, _lines));
}


@override
int get hashCode => Object.hash(runtimeType,shopId,shopName,shopPhone,const DeepCollectionEquality().hash(_lines));

@override
String toString() {
  return 'ShopCart(shopId: $shopId, shopName: $shopName, shopPhone: $shopPhone, lines: $lines)';
}


}

/// @nodoc
abstract mixin class _$ShopCartCopyWith<$Res> implements $ShopCartCopyWith<$Res> {
  factory _$ShopCartCopyWith(_ShopCart value, $Res Function(_ShopCart) _then) = __$ShopCartCopyWithImpl;
@override @useResult
$Res call({
 String shopId, String shopName, String shopPhone, List<CartLine> lines
});




}
/// @nodoc
class __$ShopCartCopyWithImpl<$Res>
    implements _$ShopCartCopyWith<$Res> {
  __$ShopCartCopyWithImpl(this._self, this._then);

  final _ShopCart _self;
  final $Res Function(_ShopCart) _then;

/// Create a copy of ShopCart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shopId = null,Object? shopName = null,Object? shopPhone = null,Object? lines = null,}) {
  return _then(_ShopCart(
shopId: null == shopId ? _self.shopId : shopId // ignore: cast_nullable_to_non_nullable
as String,shopName: null == shopName ? _self.shopName : shopName // ignore: cast_nullable_to_non_nullable
as String,shopPhone: null == shopPhone ? _self.shopPhone : shopPhone // ignore: cast_nullable_to_non_nullable
as String,lines: null == lines ? _self._lines : lines // ignore: cast_nullable_to_non_nullable
as List<CartLine>,
  ));
}


}

/// @nodoc
mixin _$Cart {

 List<ShopCart> get shopCarts;
/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CartCopyWith<Cart> get copyWith => _$CartCopyWithImpl<Cart>(this as Cart, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cart&&const DeepCollectionEquality().equals(other.shopCarts, shopCarts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(shopCarts));

@override
String toString() {
  return 'Cart(shopCarts: $shopCarts)';
}


}

/// @nodoc
abstract mixin class $CartCopyWith<$Res>  {
  factory $CartCopyWith(Cart value, $Res Function(Cart) _then) = _$CartCopyWithImpl;
@useResult
$Res call({
 List<ShopCart> shopCarts
});




}
/// @nodoc
class _$CartCopyWithImpl<$Res>
    implements $CartCopyWith<$Res> {
  _$CartCopyWithImpl(this._self, this._then);

  final Cart _self;
  final $Res Function(Cart) _then;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? shopCarts = null,}) {
  return _then(_self.copyWith(
shopCarts: null == shopCarts ? _self.shopCarts : shopCarts // ignore: cast_nullable_to_non_nullable
as List<ShopCart>,
  ));
}

}


/// Adds pattern-matching-related methods to [Cart].
extension CartPatterns on Cart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cart value)  $default,){
final _that = this;
switch (_that) {
case _Cart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cart value)?  $default,){
final _that = this;
switch (_that) {
case _Cart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ShopCart> shopCarts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cart() when $default != null:
return $default(_that.shopCarts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ShopCart> shopCarts)  $default,) {final _that = this;
switch (_that) {
case _Cart():
return $default(_that.shopCarts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ShopCart> shopCarts)?  $default,) {final _that = this;
switch (_that) {
case _Cart() when $default != null:
return $default(_that.shopCarts);case _:
  return null;

}
}

}

/// @nodoc


class _Cart extends Cart {
  const _Cart({final  List<ShopCart> shopCarts = const <ShopCart>[]}): _shopCarts = shopCarts,super._();
  

 final  List<ShopCart> _shopCarts;
@override@JsonKey() List<ShopCart> get shopCarts {
  if (_shopCarts is EqualUnmodifiableListView) return _shopCarts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_shopCarts);
}


/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CartCopyWith<_Cart> get copyWith => __$CartCopyWithImpl<_Cart>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cart&&const DeepCollectionEquality().equals(other._shopCarts, _shopCarts));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_shopCarts));

@override
String toString() {
  return 'Cart(shopCarts: $shopCarts)';
}


}

/// @nodoc
abstract mixin class _$CartCopyWith<$Res> implements $CartCopyWith<$Res> {
  factory _$CartCopyWith(_Cart value, $Res Function(_Cart) _then) = __$CartCopyWithImpl;
@override @useResult
$Res call({
 List<ShopCart> shopCarts
});




}
/// @nodoc
class __$CartCopyWithImpl<$Res>
    implements _$CartCopyWith<$Res> {
  __$CartCopyWithImpl(this._self, this._then);

  final _Cart _self;
  final $Res Function(_Cart) _then;

/// Create a copy of Cart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? shopCarts = null,}) {
  return _then(_Cart(
shopCarts: null == shopCarts ? _self._shopCarts : shopCarts // ignore: cast_nullable_to_non_nullable
as List<ShopCart>,
  ));
}


}

// dart format on
