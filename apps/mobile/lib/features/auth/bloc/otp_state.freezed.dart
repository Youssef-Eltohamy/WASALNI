// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'otp_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OtpState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState()';
}


}

/// @nodoc
class $OtpStateCopyWith<$Res>  {
$OtpStateCopyWith(OtpState _, $Res Function(OtpState) __);
}


/// Adds pattern-matching-related methods to [OtpState].
extension OtpStatePatterns on OtpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( OtpIdle value)?  idle,TResult Function( OtpSending value)?  sending,TResult Function( OtpCodeSent value)?  codeSent,TResult Function( OtpVerifying value)?  verifying,TResult Function( OtpWrongCode value)?  wrongCode,TResult Function( OtpRateLimited value)?  rateLimited,TResult Function( OtpExpired value)?  expired,TResult Function( OtpSuccess value)?  success,required TResult orElse(),}){
final _that = this;
switch (_that) {
case OtpIdle() when idle != null:
return idle(_that);case OtpSending() when sending != null:
return sending(_that);case OtpCodeSent() when codeSent != null:
return codeSent(_that);case OtpVerifying() when verifying != null:
return verifying(_that);case OtpWrongCode() when wrongCode != null:
return wrongCode(_that);case OtpRateLimited() when rateLimited != null:
return rateLimited(_that);case OtpExpired() when expired != null:
return expired(_that);case OtpSuccess() when success != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( OtpIdle value)  idle,required TResult Function( OtpSending value)  sending,required TResult Function( OtpCodeSent value)  codeSent,required TResult Function( OtpVerifying value)  verifying,required TResult Function( OtpWrongCode value)  wrongCode,required TResult Function( OtpRateLimited value)  rateLimited,required TResult Function( OtpExpired value)  expired,required TResult Function( OtpSuccess value)  success,}){
final _that = this;
switch (_that) {
case OtpIdle():
return idle(_that);case OtpSending():
return sending(_that);case OtpCodeSent():
return codeSent(_that);case OtpVerifying():
return verifying(_that);case OtpWrongCode():
return wrongCode(_that);case OtpRateLimited():
return rateLimited(_that);case OtpExpired():
return expired(_that);case OtpSuccess():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( OtpIdle value)?  idle,TResult? Function( OtpSending value)?  sending,TResult? Function( OtpCodeSent value)?  codeSent,TResult? Function( OtpVerifying value)?  verifying,TResult? Function( OtpWrongCode value)?  wrongCode,TResult? Function( OtpRateLimited value)?  rateLimited,TResult? Function( OtpExpired value)?  expired,TResult? Function( OtpSuccess value)?  success,}){
final _that = this;
switch (_that) {
case OtpIdle() when idle != null:
return idle(_that);case OtpSending() when sending != null:
return sending(_that);case OtpCodeSent() when codeSent != null:
return codeSent(_that);case OtpVerifying() when verifying != null:
return verifying(_that);case OtpWrongCode() when wrongCode != null:
return wrongCode(_that);case OtpRateLimited() when rateLimited != null:
return rateLimited(_that);case OtpExpired() when expired != null:
return expired(_that);case OtpSuccess() when success != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  sending,TResult Function( int resendSeconds)?  codeSent,TResult Function()?  verifying,TResult Function()?  wrongCode,TResult Function()?  rateLimited,TResult Function()?  expired,TResult Function( Profile profile)?  success,required TResult orElse(),}) {final _that = this;
switch (_that) {
case OtpIdle() when idle != null:
return idle();case OtpSending() when sending != null:
return sending();case OtpCodeSent() when codeSent != null:
return codeSent(_that.resendSeconds);case OtpVerifying() when verifying != null:
return verifying();case OtpWrongCode() when wrongCode != null:
return wrongCode();case OtpRateLimited() when rateLimited != null:
return rateLimited();case OtpExpired() when expired != null:
return expired();case OtpSuccess() when success != null:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  sending,required TResult Function( int resendSeconds)  codeSent,required TResult Function()  verifying,required TResult Function()  wrongCode,required TResult Function()  rateLimited,required TResult Function()  expired,required TResult Function( Profile profile)  success,}) {final _that = this;
switch (_that) {
case OtpIdle():
return idle();case OtpSending():
return sending();case OtpCodeSent():
return codeSent(_that.resendSeconds);case OtpVerifying():
return verifying();case OtpWrongCode():
return wrongCode();case OtpRateLimited():
return rateLimited();case OtpExpired():
return expired();case OtpSuccess():
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  sending,TResult? Function( int resendSeconds)?  codeSent,TResult? Function()?  verifying,TResult? Function()?  wrongCode,TResult? Function()?  rateLimited,TResult? Function()?  expired,TResult? Function( Profile profile)?  success,}) {final _that = this;
switch (_that) {
case OtpIdle() when idle != null:
return idle();case OtpSending() when sending != null:
return sending();case OtpCodeSent() when codeSent != null:
return codeSent(_that.resendSeconds);case OtpVerifying() when verifying != null:
return verifying();case OtpWrongCode() when wrongCode != null:
return wrongCode();case OtpRateLimited() when rateLimited != null:
return rateLimited();case OtpExpired() when expired != null:
return expired();case OtpSuccess() when success != null:
return success(_that.profile);case _:
  return null;

}
}

}

/// @nodoc


class OtpIdle implements OtpState {
  const OtpIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.idle()';
}


}




/// @nodoc


class OtpSending implements OtpState {
  const OtpSending();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpSending);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.sending()';
}


}




/// @nodoc


class OtpCodeSent implements OtpState {
  const OtpCodeSent({this.resendSeconds = 30});
  

@JsonKey() final  int resendSeconds;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpCodeSentCopyWith<OtpCodeSent> get copyWith => _$OtpCodeSentCopyWithImpl<OtpCodeSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpCodeSent&&(identical(other.resendSeconds, resendSeconds) || other.resendSeconds == resendSeconds));
}


@override
int get hashCode => Object.hash(runtimeType,resendSeconds);

@override
String toString() {
  return 'OtpState.codeSent(resendSeconds: $resendSeconds)';
}


}

/// @nodoc
abstract mixin class $OtpCodeSentCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory $OtpCodeSentCopyWith(OtpCodeSent value, $Res Function(OtpCodeSent) _then) = _$OtpCodeSentCopyWithImpl;
@useResult
$Res call({
 int resendSeconds
});




}
/// @nodoc
class _$OtpCodeSentCopyWithImpl<$Res>
    implements $OtpCodeSentCopyWith<$Res> {
  _$OtpCodeSentCopyWithImpl(this._self, this._then);

  final OtpCodeSent _self;
  final $Res Function(OtpCodeSent) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? resendSeconds = null,}) {
  return _then(OtpCodeSent(
resendSeconds: null == resendSeconds ? _self.resendSeconds : resendSeconds // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class OtpVerifying implements OtpState {
  const OtpVerifying();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpVerifying);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.verifying()';
}


}




/// @nodoc


class OtpWrongCode implements OtpState {
  const OtpWrongCode();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpWrongCode);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.wrongCode()';
}


}




/// @nodoc


class OtpRateLimited implements OtpState {
  const OtpRateLimited();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpRateLimited);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.rateLimited()';
}


}




/// @nodoc


class OtpExpired implements OtpState {
  const OtpExpired();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpExpired);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'OtpState.expired()';
}


}




/// @nodoc


class OtpSuccess implements OtpState {
  const OtpSuccess(this.profile);
  

 final  Profile profile;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OtpSuccessCopyWith<OtpSuccess> get copyWith => _$OtpSuccessCopyWithImpl<OtpSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OtpSuccess&&(identical(other.profile, profile) || other.profile == profile));
}


@override
int get hashCode => Object.hash(runtimeType,profile);

@override
String toString() {
  return 'OtpState.success(profile: $profile)';
}


}

/// @nodoc
abstract mixin class $OtpSuccessCopyWith<$Res> implements $OtpStateCopyWith<$Res> {
  factory $OtpSuccessCopyWith(OtpSuccess value, $Res Function(OtpSuccess) _then) = _$OtpSuccessCopyWithImpl;
@useResult
$Res call({
 Profile profile
});


$ProfileCopyWith<$Res> get profile;

}
/// @nodoc
class _$OtpSuccessCopyWithImpl<$Res>
    implements $OtpSuccessCopyWith<$Res> {
  _$OtpSuccessCopyWithImpl(this._self, this._then);

  final OtpSuccess _self;
  final $Res Function(OtpSuccess) _then;

/// Create a copy of OtpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? profile = null,}) {
  return _then(OtpSuccess(
null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as Profile,
  ));
}

/// Create a copy of OtpState
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
