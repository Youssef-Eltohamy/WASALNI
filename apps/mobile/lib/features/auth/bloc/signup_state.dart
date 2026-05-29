import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'signup_state.freezed.dart';

@freezed
sealed class SignupState with _$SignupState {
  const factory SignupState.form() = SignupForm;
  const factory SignupState.submitting() = SignupSubmitting;
  const factory SignupState.formError(String message) = SignupFormError;
  const factory SignupState.codeSent({String? error}) = SignupCodeSent;
  const factory SignupState.verifying() = SignupVerifying;
  const factory SignupState.success(Profile profile) = SignupSuccess;
}
