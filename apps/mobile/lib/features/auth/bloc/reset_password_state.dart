import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'reset_password_state.freezed.dart';

@freezed
sealed class ResetPasswordState with _$ResetPasswordState {
  const factory ResetPasswordState.idle() = ResetPasswordIdle;
  const factory ResetPasswordState.submitting() = ResetPasswordSubmitting;
  const factory ResetPasswordState.error(String message) = ResetPasswordError;
  const factory ResetPasswordState.tokenInvalid(String message) =
      ResetPasswordTokenInvalid;
  const factory ResetPasswordState.success(Profile profile) = ResetPasswordSuccess;
}
