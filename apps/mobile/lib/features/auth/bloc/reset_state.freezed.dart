// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResetState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetState()';
}


}

/// @nodoc
class $ResetStateCopyWith<$Res>  {
$ResetStateCopyWith(ResetState _, $Res Function(ResetState) __);
}


/// Adds pattern-matching-related methods to [ResetState].
extension ResetStatePatterns on ResetState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResetPhase value)?  phone,TResult Function( ResetSubmitting value)?  submitting,TResult Function( ResetPhoneError value)?  phoneError,TResult Function( ResetCodeSent value)?  codeSent,TResult Function( ResetVerifying value)?  verifying,TResult Function( ResetSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResetPhase() when phone != null:
return phone(_that);case ResetSubmitting() when submitting != null:
return submitting(_that);case ResetPhoneError() when phoneError != null:
return phoneError(_that);case ResetCodeSent() when codeSent != null:
return codeSent(_that);case ResetVerifying() when verifying != null:
return verifying(_that);case ResetSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResetPhase value)  phone,required TResult Function( ResetSubmitting value)  submitting,required TResult Function( ResetPhoneError value)  phoneError,required TResult Function( ResetCodeSent value)  codeSent,required TResult Function( ResetVerifying value)  verifying,required TResult Function( ResetSuccess value)  success,}){
final _that = this;
switch (_that) {
case ResetPhase():
return phone(_that);case ResetSubmitting():
return submitting(_that);case ResetPhoneError():
return phoneError(_that);case ResetCodeSent():
return codeSent(_that);case ResetVerifying():
return verifying(_that);case ResetSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResetPhase value)?  phone,TResult? Function( ResetSubmitting value)?  submitting,TResult? Function( ResetPhoneError value)?  phoneError,TResult? Function( ResetCodeSent value)?  codeSent,TResult? Function( ResetVerifying value)?  verifying,TResult? Function( ResetSuccess value)?  success,}){
final _that = this;
switch (_that) {
case ResetPhase() when phone != null:
return phone(_that);case ResetSubmitting() when submitting != null:
return submitting(_that);case ResetPhoneError() when phoneError != null:
return phoneError(_that);case ResetCodeSent() when codeSent != null:
return codeSent(_that);case ResetVerifying() when verifying != null:
return verifying(_that);case ResetSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  phone,TResult Function()?  submitting,TResult Function( String message)?  phoneError,TResult Function( String? error)?  codeSent,TResult Function()?  verifying,TResult Function( Profile profile)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResetPhase() when phone != null:
return phone();case ResetSubmitting() when submitting != null:
return submitting();case ResetPhoneError() when phoneError != null:
return phoneError(_that.message);case ResetCodeSent() when codeSent != null:
return codeSent(_that.error);case ResetVerifying() when verifying != null:
return verifying();case ResetSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  phone,required TResult Function()  submitting,required TResult Function( String message)  phoneError,required TResult Function( String? error)  codeSent,required TResult Function()  verifying,required TResult Function( Profile profile)  success,}) {final _that = this;
switch (_that) {
case ResetPhase():
return phone();case ResetSubmitting():
return submitting();case ResetPhoneError():
return phoneError(_that.message);case ResetCodeSent():
return codeSent(_that.error);case ResetVerifying():
return verifying();case ResetSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  phone,TResult? Function()?  submitting,TResult? Function( String message)?  phoneError,TResult? Function( String? error)?  codeSent,TResult? Function()?  verifying,TResult? Function( Profile profile)?  success,}) {final _that = this;
switch (_that) {
case ResetPhase() when phone != null:
return phone();case ResetSubmitting() when submitting != null:
return submitting();case ResetPhoneError() when phoneError != null:
return phoneError(_that.message);case ResetCodeSent() when codeSent != null:
return codeSent(_that.error);case ResetVerifying() when verifying != null:
return verifying();case ResetSuccess() when success != null:
return success(_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class ResetPhase implements ResetState {
  const ResetPhase();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPhase);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetState.phone()';
}


}




/// @nodoc


class ResetSubmitting implements ResetState {
  const ResetSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetState.submitting()';
}


}




/// @nodoc


class ResetPhoneError implements ResetState {
  const ResetPhoneError(this.message);
  

 final  String message;

/// Create a copy of ResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPhoneErrorCopyWith<ResetPhoneError> get copyWith => _$ResetPhoneErrorCopyWithImpl<ResetPhoneError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPhoneError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ResetState.phoneError(message: $message)';
}


}

/// @nodoc
abstract mixin class $ResetPhoneErrorCopyWith<$Res> implements $ResetStateCopyWith<$Res> {
  factory $ResetPhoneErrorCopyWith(ResetPhoneError value, $Res Function(ResetPhoneError) _then) = _$ResetPhoneErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ResetPhoneErrorCopyWithImpl<$Res>
    implements $ResetPhoneErrorCopyWith<$Res> {
  _$ResetPhoneErrorCopyWithImpl(this._self, this._then);

  final ResetPhoneError _self;
  final $Res Function(ResetPhoneError) _then;

/// Create a copy of ResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ResetPhoneError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetCodeSent implements ResetState {
  const ResetCodeSent({this.error});
  

 final  String? error;

/// Create a copy of ResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetCodeSentCopyWith<ResetCodeSent> get copyWith => _$ResetCodeSentCopyWithImpl<ResetCodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetCodeSent&&(identical(other.error, error) || other.error == error));
}


@override
int get hashCode => Object.hash(runtimeType,error);

@override
String toString() {
  return 'ResetState.codeSent(error: $error)';
}


}

/// @nodoc
abstract mixin class $ResetCodeSentCopyWith<$Res> implements $ResetStateCopyWith<$Res> {
  factory $ResetCodeSentCopyWith(ResetCodeSent value, $Res Function(ResetCodeSent) _then) = _$ResetCodeSentCopyWithImpl;
@useResult
$Res call({
 String? error
});




}
/// @nodoc
class _$ResetCodeSentCopyWithImpl<$Res>
    implements $ResetCodeSentCopyWith<$Res> {
  _$ResetCodeSentCopyWithImpl(this._self, this._then);

  final ResetCodeSent _self;
  final $Res Function(ResetCodeSent) _then;

/// Create a copy of ResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = freezed,}) {
  return _then(ResetCodeSent(
error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class ResetVerifying implements ResetState {
  const ResetVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetState.verifying()';
}


}




/// @nodoc


class ResetSuccess implements ResetState {
  const ResetSuccess(this.profile);
  

 final  Profile profile;

/// Create a copy of ResetState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetSuccessCopyWith<ResetSuccess> get copyWith => _$ResetSuccessCopyWithImpl<ResetSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetSuccess&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'ResetState.success(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $ResetSuccessCopyWith<$Res> implements $ResetStateCopyWith<$Res> {
  factory $ResetSuccessCopyWith(ResetSuccess value, $Res Function(ResetSuccess) _then) = _$ResetSuccessCopyWithImpl;
@useResult
$Res call({
 Profile profile
});


$ProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$ResetSuccessCopyWithImpl<$Res>
    implements $ResetSuccessCopyWith<$Res> {
  _$ResetSuccessCopyWithImpl(this._self, this._then);

  final ResetSuccess _self;
  final $Res Function(ResetSuccess) _then;

/// Create a copy of ResetState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(ResetSuccess(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,
  ));
}

/// Create a copy of ResetState
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
