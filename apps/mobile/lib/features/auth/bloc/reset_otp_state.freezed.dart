// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResetOtpState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetOtpState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetOtpState()';
}


}

/// @nodoc
class $ResetOtpStateCopyWith<$Res>  {
$ResetOtpStateCopyWith(ResetOtpState _, $Res Function(ResetOtpState) __);
}


/// Adds pattern-matching-related methods to [ResetOtpState].
extension ResetOtpStatePatterns on ResetOtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResetOtpIdle value)?  idle,TResult Function( ResetOtpVerifying value)?  verifying,TResult Function( ResetOtpError value)?  error,TResult Function( ResetOtpVerified value)?  verified,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResetOtpIdle() when idle != null:
return idle(_that);case ResetOtpVerifying() when verifying != null:
return verifying(_that);case ResetOtpError() when error != null:
return error(_that);case ResetOtpVerified() when verified != null:
return verified(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResetOtpIdle value)  idle,required TResult Function( ResetOtpVerifying value)  verifying,required TResult Function( ResetOtpError value)  error,required TResult Function( ResetOtpVerified value)  verified,}){
final _that = this;
switch (_that) {
case ResetOtpIdle():
return idle(_that);case ResetOtpVerifying():
return verifying(_that);case ResetOtpError():
return error(_that);case ResetOtpVerified():
return verified(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResetOtpIdle value)?  idle,TResult? Function( ResetOtpVerifying value)?  verifying,TResult? Function( ResetOtpError value)?  error,TResult? Function( ResetOtpVerified value)?  verified,}){
final _that = this;
switch (_that) {
case ResetOtpIdle() when idle != null:
return idle(_that);case ResetOtpVerifying() when verifying != null:
return verifying(_that);case ResetOtpError() when error != null:
return error(_that);case ResetOtpVerified() when verified != null:
return verified(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  verifying,TResult Function( String message)?  error,TResult Function( String token)?  verified,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResetOtpIdle() when idle != null:
return idle();case ResetOtpVerifying() when verifying != null:
return verifying();case ResetOtpError() when error != null:
return error(_that.message);case ResetOtpVerified() when verified != null:
return verified(_that.token);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  verifying,required TResult Function( String message)  error,required TResult Function( String token)  verified,}) {final _that = this;
switch (_that) {
case ResetOtpIdle():
return idle();case ResetOtpVerifying():
return verifying();case ResetOtpError():
return error(_that.message);case ResetOtpVerified():
return verified(_that.token);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  verifying,TResult? Function( String message)?  error,TResult? Function( String token)?  verified,}) {final _that = this;
switch (_that) {
case ResetOtpIdle() when idle != null:
return idle();case ResetOtpVerifying() when verifying != null:
return verifying();case ResetOtpError() when error != null:
return error(_that.message);case ResetOtpVerified() when verified != null:
return verified(_that.token);case _:
  return null;

}
}

}

/// @nodoc


class ResetOtpIdle implements ResetOtpState {
  const ResetOtpIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetOtpIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetOtpState.idle()';
}


}




/// @nodoc


class ResetOtpVerifying implements ResetOtpState {
  const ResetOtpVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetOtpVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetOtpState.verifying()';
}


}




/// @nodoc


class ResetOtpError implements ResetOtpState {
  const ResetOtpError(this.message);
  

 final  String message;

/// Create a copy of ResetOtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetOtpErrorCopyWith<ResetOtpError> get copyWith => _$ResetOtpErrorCopyWithImpl<ResetOtpError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetOtpError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ResetOtpState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ResetOtpErrorCopyWith<$Res> implements $ResetOtpStateCopyWith<$Res> {
  factory $ResetOtpErrorCopyWith(ResetOtpError value, $Res Function(ResetOtpError) _then) = _$ResetOtpErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ResetOtpErrorCopyWithImpl<$Res>
    implements $ResetOtpErrorCopyWith<$Res> {
  _$ResetOtpErrorCopyWithImpl(this._self, this._then);

  final ResetOtpError _self;
  final $Res Function(ResetOtpError) _then;

/// Create a copy of ResetOtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ResetOtpError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetOtpVerified implements ResetOtpState {
  const ResetOtpVerified(this.token);
  

 final  String token;

/// Create a copy of ResetOtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetOtpVerifiedCopyWith<ResetOtpVerified> get copyWith => _$ResetOtpVerifiedCopyWithImpl<ResetOtpVerified>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetOtpVerified&&(identical(other.token, token) || other.token == token));
}


@override
int get hashCode => Object.hash(runtimeType,token);

@override
String toString() {
  return 'ResetOtpState.verified(token: $token)';
}


}

/// @nodoc
abstract mixin class $ResetOtpVerifiedCopyWith<$Res> implements $ResetOtpStateCopyWith<$Res> {
  factory $ResetOtpVerifiedCopyWith(ResetOtpVerified value, $Res Function(ResetOtpVerified) _then) = _$ResetOtpVerifiedCopyWithImpl;
@useResult
$Res call({
 String token
});




}
/// @nodoc
class _$ResetOtpVerifiedCopyWithImpl<$Res>
    implements $ResetOtpVerifiedCopyWith<$Res> {
  _$ResetOtpVerifiedCopyWithImpl(this._self, this._then);

  final ResetOtpVerified _self;
  final $Res Function(ResetOtpVerified) _then;

/// Create a copy of ResetOtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? token = null,}) {
  return _then(ResetOtpVerified(
null == token ? _self.token : token // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
