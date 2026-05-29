import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/models/profile.dart';
import 'session_state.dart';

/// Global session. Browse-first: starts as guest. Persistence across restarts
/// is deferred to the backend phase (mock session resets on cold start).
class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(const SessionState.guest());

  bool get isAuthenticated => state is SessionAuthenticated;

  String get displayName =>
      switch (state) { SessionAuthenticated(:final profile) => profile.displayName, _ => '' };

  void signIn(Profile profile) => emit(SessionState.authenticated(profile));
  void signOut() => emit(const SessionState.guest());
}
