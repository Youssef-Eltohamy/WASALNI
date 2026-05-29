import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'login_state.freezed.dart';

@freezed
sealed class LoginState with _$LoginState {
  const factory LoginState.idle() = LoginIdle;
  const factory LoginState.submitting() = LoginSubmitting;
  const factory LoginState.error(String message) = LoginError;
  const factory LoginState.success(Profile profile) = LoginSuccess;
}
