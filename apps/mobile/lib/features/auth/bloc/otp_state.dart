import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'otp_state.freezed.dart';

@freezed
sealed class OtpState with _$OtpState {
  const factory OtpState.idle() = OtpIdle;
  const factory OtpState.sending() = OtpSending;
  const factory OtpState.codeSent({@Default(30) int resendSeconds}) = OtpCodeSent;
  const factory OtpState.verifying() = OtpVerifying;
  const factory OtpState.wrongCode() = OtpWrongCode;
  const factory OtpState.rateLimited() = OtpRateLimited;
  const factory OtpState.expired() = OtpExpired;
  const factory OtpState.success(Profile profile) = OtpSuccess;
}
