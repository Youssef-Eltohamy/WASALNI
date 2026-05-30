import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_otp_state.freezed.dart';

@freezed
sealed class ResetOtpState with _$ResetOtpState {
  const factory ResetOtpState.idle() = ResetOtpIdle;
  const factory ResetOtpState.verifying() = ResetOtpVerifying;
  const factory ResetOtpState.error(String message) = ResetOtpError;
  const factory ResetOtpState.verified(String token) = ResetOtpVerified;
}
