import 'package:freezed_annotation/freezed_annotation.dart';

part 'reset_phone_state.freezed.dart';

@freezed
sealed class ResetPhoneState with _$ResetPhoneState {
  const factory ResetPhoneState.idle() = ResetPhoneIdle;
  const factory ResetPhoneState.submitting() = ResetPhoneSubmitting;
  const factory ResetPhoneState.error(String message) = ResetPhoneError;
  const factory ResetPhoneState.sent(String phone) = ResetPhoneSent;
}
