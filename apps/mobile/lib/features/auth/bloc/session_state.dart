import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../data/models/profile.dart';

part 'session_state.freezed.dart';

@freezed
sealed class SessionState with _$SessionState {
  const factory SessionState.unknown() = SessionUnknown;
  const factory SessionState.guest() = SessionGuest;
  const factory SessionState.authenticated(Profile profile) = SessionAuthenticated;
}
