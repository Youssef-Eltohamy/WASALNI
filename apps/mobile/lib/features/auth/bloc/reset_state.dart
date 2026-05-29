import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'reset_state.freezed.dart';

@freezed
sealed class ResetState with _$ResetState {
  const factory ResetState.phone() = ResetPhase;
  const factory ResetState.submitting() = ResetSubmitting;
  const factory ResetState.phoneError(String message) = ResetPhoneError;
  const factory ResetState.codeSent({String? error}) = ResetCodeSent;
  const factory ResetState.verifying() = ResetVerifying;
  const factory ResetState.success(Profile profile) = ResetSuccess;
}
