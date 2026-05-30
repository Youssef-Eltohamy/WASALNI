// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_password_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResetPasswordState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState()';
}


}

/// @nodoc
class $ResetPasswordStateCopyWith<$Res>  {
$ResetPasswordStateCopyWith(ResetPasswordState _, $Res Function(ResetPasswordState) __);
}


/// Adds pattern-matching-related methods to [ResetPasswordState].
extension ResetPasswordStatePatterns on ResetPasswordState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResetPasswordIdle value)?  idle,TResult Function( ResetPasswordSubmitting value)?  submitting,TResult Function( ResetPasswordError value)?  error,TResult Function( ResetPasswordTokenInvalid value)?  tokenInvalid,TResult Function( ResetPasswordSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle(_that);case ResetPasswordSubmitting() when submitting != null:
return submitting(_that);case ResetPasswordError() when error != null:
return error(_that);case ResetPasswordTokenInvalid() when tokenInvalid != null:
return tokenInvalid(_that);case ResetPasswordSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResetPasswordIdle value)  idle,required TResult Function( ResetPasswordSubmitting value)  submitting,required TResult Function( ResetPasswordError value)  error,required TResult Function( ResetPasswordTokenInvalid value)  tokenInvalid,required TResult Function( ResetPasswordSuccess value)  success,}){
final _that = this;
switch (_that) {
case ResetPasswordIdle():
return idle(_that);case ResetPasswordSubmitting():
return submitting(_that);case ResetPasswordError():
return error(_that);case ResetPasswordTokenInvalid():
return tokenInvalid(_that);case ResetPasswordSuccess():
return success(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResetPasswordIdle value)?  idle,TResult? Function( ResetPasswordSubmitting value)?  submitting,TResult? Function( ResetPasswordError value)?  error,TResult? Function( ResetPasswordTokenInvalid value)?  tokenInvalid,TResult? Function( ResetPasswordSuccess value)?  success,}){
final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle(_that);case ResetPasswordSubmitting() when submitting != null:
return submitting(_that);case ResetPasswordError() when error != null:
return error(_that);case ResetPasswordTokenInvalid() when tokenInvalid != null:
return tokenInvalid(_that);case ResetPasswordSuccess() when success != null:
return success(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function( String message)?  error,TResult Function( String message)?  tokenInvalid,TResult Function( Profile profile)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle();case ResetPasswordSubmitting() when submitting != null:
return submitting();case ResetPasswordError() when error != null:
return error(_that.message);case ResetPasswordTokenInvalid() when tokenInvalid != null:
return tokenInvalid(_that.message);case ResetPasswordSuccess() when success != null:
return success(_that.profile);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function( String message)  error,required TResult Function( String message)  tokenInvalid,required TResult Function( Profile profile)  success,}) {final _that = this;
switch (_that) {
case ResetPasswordIdle():
return idle();case ResetPasswordSubmitting():
return submitting();case ResetPasswordError():
return error(_that.message);case ResetPasswordTokenInvalid():
return tokenInvalid(_that.message);case ResetPasswordSuccess():
return success(_that.profile);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function( String message)?  error,TResult? Function( String message)?  tokenInvalid,TResult? Function( Profile profile)?  success,}) {final _that = this;
switch (_that) {
case ResetPasswordIdle() when idle != null:
return idle();case ResetPasswordSubmitting() when submitting != null:
return submitting();case ResetPasswordError() when error != null:
return error(_that.message);case ResetPasswordTokenInvalid() when tokenInvalid != null:
return tokenInvalid(_that.message);case ResetPasswordSuccess() when success != null:
return success(_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class ResetPasswordIdle implements ResetPasswordState {
  const ResetPasswordIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.idle()';
}


}




/// @nodoc


class ResetPasswordSubmitting implements ResetPasswordState {
  const ResetPasswordSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPasswordState.submitting()';
}


}




/// @nodoc


class ResetPasswordError implements ResetPasswordState {
  const ResetPasswordError(this.message);
  

 final  String message;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordErrorCopyWith<ResetPasswordError> get copyWith => _$ResetPasswordErrorCopyWithImpl<ResetPasswordError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ResetPasswordState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordErrorCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory $ResetPasswordErrorCopyWith(ResetPasswordError value, $Res Function(ResetPasswordError) _then) = _$ResetPasswordErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ResetPasswordErrorCopyWithImpl<$Res>
    implements $ResetPasswordErrorCopyWith<$Res> {
  _$ResetPasswordErrorCopyWithImpl(this._self, this._then);

  final ResetPasswordError _self;
  final $Res Function(ResetPasswordError) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ResetPasswordError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetPasswordTokenInvalid implements ResetPasswordState {
  const ResetPasswordTokenInvalid(this.message);
  

 final  String message;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordTokenInvalidCopyWith<ResetPasswordTokenInvalid> get copyWith => _$ResetPasswordTokenInvalidCopyWithImpl<ResetPasswordTokenInvalid>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordTokenInvalid&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ResetPasswordState.tokenInvalid(message: $message)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordTokenInvalidCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory $ResetPasswordTokenInvalidCopyWith(ResetPasswordTokenInvalid value, $Res Function(ResetPasswordTokenInvalid) _then) = _$ResetPasswordTokenInvalidCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ResetPasswordTokenInvalidCopyWithImpl<$Res>
    implements $ResetPasswordTokenInvalidCopyWith<$Res> {
  _$ResetPasswordTokenInvalidCopyWithImpl(this._self, this._then);

  final ResetPasswordTokenInvalid _self;
  final $Res Function(ResetPasswordTokenInvalid) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ResetPasswordTokenInvalid(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetPasswordSuccess implements ResetPasswordState {
  const ResetPasswordSuccess(this.profile);
  

 final  Profile profile;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPasswordSuccessCopyWith<ResetPasswordSuccess> get copyWith => _$ResetPasswordSuccessCopyWithImpl<ResetPasswordSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPasswordSuccess&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'ResetPasswordState.success(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $ResetPasswordSuccessCopyWith<$Res> implements $ResetPasswordStateCopyWith<$Res> {
  factory $ResetPasswordSuccessCopyWith(ResetPasswordSuccess value, $Res Function(ResetPasswordSuccess) _then) = _$ResetPasswordSuccessCopyWithImpl;
@useResult
$Res call({
 Profile profile
});


$ProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$ResetPasswordSuccessCopyWithImpl<$Res>
    implements $ResetPasswordSuccessCopyWith<$Res> {
  _$ResetPasswordSuccessCopyWithImpl(this._self, this._then);

  final ResetPasswordSuccess _self;
  final $Res Function(ResetPasswordSuccess) _then;

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(ResetPasswordSuccess(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,
  ));
}

/// Create a copy of ResetPasswordState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileCopyWith<$Res> get profile {
  
  return $ProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}
}

// dart format on
