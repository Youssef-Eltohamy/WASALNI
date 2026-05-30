import 'dart:async';
import '../auth/bloc/session_cubit.dart';
import '../auth/bloc/session_state.dart';
import 'bloc/cart_cubit.dart';

/// Binds the cart to the session so the cart "belongs" to whoever is signed in:
/// - on sign-in, the guest cart merges into the user's saved cart;
/// - on sign-out, the user's cart is saved and the guest starts fresh.
///
/// It listens to [SessionCubit] so every sign-in/out is covered regardless of
/// which screen triggered it.
class SessionCartCoordinator {
  SessionCartCoordinator(this._session, this._cart);
  final SessionCubit _session;
  final CartCubit _cart;
  StreamSubscription<SessionState>? _sub;

  void start() {
    _sub ??= _session.stream.listen((state) {
      switch (state) {
        case SessionAuthenticated(:final profile):
          _cart.mergeOnSignIn(profile.id);
        case SessionGuest():
          _cart.saveAndResetOnSignOut();
      }
    });
  }

  Future<void> dispose() async {
    await _sub?.cancel();
    _sub = null;
  }
}
