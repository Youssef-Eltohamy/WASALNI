// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'signup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SignupState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupState()';
}


}

/// @nodoc
class $SignupStateCopyWith<$Res>  {
$SignupStateCopyWith(SignupState _, $Res Function(SignupState) __);
}


/// Adds pattern-matching-related methods to [SignupState].
extension SignupStatePatterns on SignupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SignupForm value)?  form,TResult Function( SignupSubmitting value)?  submitting,TResult Function( SignupFormError value)?  formError,TResult Function( SignupCodeSent value)?  codeSent,TResult Function( SignupVerifying value)?  verifying,TResult Function( SignupSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SignupForm() when form != null:
return form(_that);case SignupSubmitting() when submitting != null:
return submitting(_that);case SignupFormError() when formError != null:
return formError(_that);case SignupCodeSent() when codeSent != null:
return codeSent(_that);case SignupVerifying() when verifying != null:
return verifying(_that);case SignupSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SignupForm value)  form,required TResult Function( SignupSubmitting value)  submitting,required TResult Function( SignupFormError value)  formError,required TResult Function( SignupCodeSent value)  codeSent,required TResult Function( SignupVerifying value)  verifying,required TResult Function( SignupSuccess value)  success,}){
final _that = this;
switch (_that) {
case SignupForm():
return form(_that);case SignupSubmitting():
return submitting(_that);case SignupFormError():
return formError(_that);case SignupCodeSent():
return codeSent(_that);case SignupVerifying():
return verifying(_that);case SignupSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SignupForm value)?  form,TResult? Function( SignupSubmitting value)?  submitting,TResult? Function( SignupFormError value)?  formError,TResult? Function( SignupCodeSent value)?  codeSent,TResult? Function( SignupVerifying value)?  verifying,TResult? Function( SignupSuccess value)?  success,}){
final _that = this;
switch (_that) {
case SignupForm() when form != null:
return form(_that);case SignupSubmitting() when submitting != null:
return submitting(_that);case SignupFormError() when formError != null:
return formError(_that);case SignupCodeSent() when codeSent != null:
return codeSent(_that);case SignupVerifying() when verifying != null:
return verifying(_that);case SignupSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  form,TResult Function()?  submitting,TResult Function( String message)?  formError,TResult Function( String? error)?  codeSent,TResult Function()?  verifying,TResult Function( Profile profile)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SignupForm() when form != null:
return form();case SignupSubmitting() when submitting != null:
return submitting();case SignupFormError() when formError != null:
return formError(_that.message);case SignupCodeSent() when codeSent != null:
return codeSent(_that.error);case SignupVerifying() when verifying != null:
return verifying();case SignupSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  form,required TResult Function()  submitting,required TResult Function( String message)  formError,required TResult Function( String? error)  codeSent,required TResult Function()  verifying,required TResult Function( Profile profile)  success,}) {final _that = this;
switch (_that) {
case SignupForm():
return form();case SignupSubmitting():
return submitting();case SignupFormError():
return formError(_that.message);case SignupCodeSent():
return codeSent(_that.error);case SignupVerifying():
return verifying();case SignupSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  form,TResult? Function()?  submitting,TResult? Function( String message)?  formError,TResult? Function( String? error)?  codeSent,TResult? Function()?  verifying,TResult? Function( Profile profile)?  success,}) {final _that = this;
switch (_that) {
case SignupForm() when form != null:
return form();case SignupSubmitting() when submitting != null:
return submitting();case SignupFormError() when formError != null:
return formError(_that.message);case SignupCodeSent() when codeSent != null:
return codeSent(_that.error);case SignupVerifying() when verifying != null:
return verifying();case SignupSuccess() when success != null:
return success(_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class SignupForm implements SignupState {
  const SignupForm();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupForm);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupState.form()';
}


}




/// @nodoc


class SignupSubmitting implements SignupState {
  const SignupSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupState.submitting()';
}


}




/// @nodoc


class SignupFormError implements SignupState {
  const SignupFormError(this.message);
  

 final  String message;

/// Create a copy of SignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupFormErrorCopyWith<SignupFormError> get copyWith => _$SignupFormErrorCopyWithImpl<SignupFormError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupFormError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SignupState.formError(message: $message)';
}


}

/// @nodoc
abstract mixin class $SignupFormErrorCopyWith<$Res> implements $SignupStateCopyWith<$Res> {
  factory $SignupFormErrorCopyWith(SignupFormError value, $Res Function(SignupFormError) _then) = _$SignupFormErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SignupFormErrorCopyWithImpl<$Res>
    implements $SignupFormErrorCopyWith<$Res> {
  _$SignupFormErrorCopyWithImpl(this._self, this._then);

  final SignupFormError _self;
  final $Res Function(SignupFormError) _then;

/// Create a copy of SignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SignupFormError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SignupCodeSent implements SignupState {
  const SignupCodeSent({this.error});
  

 final  String? error;

/// Create a copy of SignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupCodeSentCopyWith<SignupCodeSent> get copyWith => _$SignupCodeSentCopyWithImpl<SignupCodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupCodeSent&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'SignupState.codeSent(error: $error)';
}


}

/// @nodoc
abstract mixin class $SignupCodeSentCopyWith<$Res> implements $SignupStateCopyWith<$Res> {
  factory $SignupCodeSentCopyWith(SignupCodeSent value, $Res Function(SignupCodeSent) _then) = _$SignupCodeSentCopyWithImpl;
@useResult
$Res call({
 String? error
});




}
/// @nodoc
class _$SignupCodeSentCopyWithImpl<$Res>
    implements $SignupCodeSentCopyWith<$Res> {
  _$SignupCodeSentCopyWithImpl(this._self, this._then);

  final SignupCodeSent _self;
  final $Res Function(SignupCodeSent) _then;

/// Create a copy of SignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(SignupCodeSent(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class SignupVerifying implements SignupState {
  const SignupVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SignupState.verifying()';
}


}




/// @nodoc


class SignupSuccess implements SignupState {
  const SignupSuccess(this.profile);
  

 final  Profile profile;

/// Create a copy of SignupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SignupSuccessCopyWith<SignupSuccess> get copyWith => _$SignupSuccessCopyWithImpl<SignupSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SignupSuccess&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'SignupState.success(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $SignupSuccessCopyWith<$Res> implements $SignupStateCopyWith<$Res> {
  factory $SignupSuccessCopyWith(SignupSuccess value, $Res Function(SignupSuccess) _then) = _$SignupSuccessCopyWithImpl;
@useResult
$Res call({
 Profile profile
});


$ProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$SignupSuccessCopyWithImpl<$Res>
    implements $SignupSuccessCopyWith<$Res> {
  _$SignupSuccessCopyWithImpl(this._self, this._then);

  final SignupSuccess _self;
  final $Res Function(SignupSuccess) _then;

/// Create a copy of SignupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(SignupSuccess(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,
  ));
}

/// Create a copy of SignupState
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
