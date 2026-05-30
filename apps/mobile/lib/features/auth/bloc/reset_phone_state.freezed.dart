// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reset_phone_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ResetPhoneState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPhoneState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPhoneState()';
}


}

/// @nodoc
class $ResetPhoneStateCopyWith<$Res>  {
$ResetPhoneStateCopyWith(ResetPhoneState _, $Res Function(ResetPhoneState) __);
}


/// Adds pattern-matching-related methods to [ResetPhoneState].
extension ResetPhoneStatePatterns on ResetPhoneState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ResetPhoneIdle value)?  idle,TResult Function( ResetPhoneSubmitting value)?  submitting,TResult Function( ResetPhoneError value)?  error,TResult Function( ResetPhoneSent value)?  sent,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ResetPhoneIdle() when idle != null:
return idle(_that);case ResetPhoneSubmitting() when submitting != null:
return submitting(_that);case ResetPhoneError() when error != null:
return error(_that);case ResetPhoneSent() when sent != null:
return sent(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ResetPhoneIdle value)  idle,required TResult Function( ResetPhoneSubmitting value)  submitting,required TResult Function( ResetPhoneError value)  error,required TResult Function( ResetPhoneSent value)  sent,}){
final _that = this;
switch (_that) {
case ResetPhoneIdle():
return idle(_that);case ResetPhoneSubmitting():
return submitting(_that);case ResetPhoneError():
return error(_that);case ResetPhoneSent():
return sent(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ResetPhoneIdle value)?  idle,TResult? Function( ResetPhoneSubmitting value)?  submitting,TResult? Function( ResetPhoneError value)?  error,TResult? Function( ResetPhoneSent value)?  sent,}){
final _that = this;
switch (_that) {
case ResetPhoneIdle() when idle != null:
return idle(_that);case ResetPhoneSubmitting() when submitting != null:
return submitting(_that);case ResetPhoneError() when error != null:
return error(_that);case ResetPhoneSent() when sent != null:
return sent(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  idle,TResult Function()?  submitting,TResult Function( String message)?  error,TResult Function( String phone)?  sent,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ResetPhoneIdle() when idle != null:
return idle();case ResetPhoneSubmitting() when submitting != null:
return submitting();case ResetPhoneError() when error != null:
return error(_that.message);case ResetPhoneSent() when sent != null:
return sent(_that.phone);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  idle,required TResult Function()  submitting,required TResult Function( String message)  error,required TResult Function( String phone)  sent,}) {final _that = this;
switch (_that) {
case ResetPhoneIdle():
return idle();case ResetPhoneSubmitting():
return submitting();case ResetPhoneError():
return error(_that.message);case ResetPhoneSent():
return sent(_that.phone);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  idle,TResult? Function()?  submitting,TResult? Function( String message)?  error,TResult? Function( String phone)?  sent,}) {final _that = this;
switch (_that) {
case ResetPhoneIdle() when idle != null:
return idle();case ResetPhoneSubmitting() when submitting != null:
return submitting();case ResetPhoneError() when error != null:
return error(_that.message);case ResetPhoneSent() when sent != null:
return sent(_that.phone);case _:
  return null;

}
}

}

/// @nodoc


class ResetPhoneIdle implements ResetPhoneState {
  const ResetPhoneIdle();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPhoneIdle);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPhoneState.idle()';
}


}




/// @nodoc


class ResetPhoneSubmitting implements ResetPhoneState {
  const ResetPhoneSubmitting();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPhoneSubmitting);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ResetPhoneState.submitting()';
}


}




/// @nodoc


class ResetPhoneError implements ResetPhoneState {
  const ResetPhoneError(this.message);
  

 final  String message;

/// Create a copy of ResetPhoneState
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
  return 'ResetPhoneState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ResetPhoneErrorCopyWith<$Res> implements $ResetPhoneStateCopyWith<$Res> {
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

/// Create a copy of ResetPhoneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ResetPhoneError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ResetPhoneSent implements ResetPhoneState {
  const ResetPhoneSent(this.phone);
  

 final  String phone;

/// Create a copy of ResetPhoneState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ResetPhoneSentCopyWith<ResetPhoneSent> get copyWith => _$ResetPhoneSentCopyWithImpl<ResetPhoneSent>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ResetPhoneSent&&(identical(other.phone, phone) || other.phone == phone));
}


@override
int get hashCode => Object.hash(runtimeType,phone);

@override
String toString() {
  return 'ResetPhoneState.sent(phone: $phone)';
}


}

/// @nodoc
abstract mixin class $ResetPhoneSentCopyWith<$Res> implements $ResetPhoneStateCopyWith<$Res> {
  factory $ResetPhoneSentCopyWith(ResetPhoneSent value, $Res Function(ResetPhoneSent) _then) = _$ResetPhoneSentCopyWithImpl;
@useResult
$Res call({
 String phone
});




}
/// @nodoc
class _$ResetPhoneSentCopyWithImpl<$Res>
    implements $ResetPhoneSentCopyWith<$Res> {
  _$ResetPhoneSentCopyWithImpl(this._self, this._then);

  final ResetPhoneSent _self;
  final $Res Function(ResetPhoneSent) _then;

/// Create a copy of ResetPhoneState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? phone = null,}) {
  return _then(ResetPhoneSent(
null == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
