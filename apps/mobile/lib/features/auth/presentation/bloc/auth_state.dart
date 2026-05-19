part of 'auth_bloc.dart';

enum AuthStatus {
  /// لسه بنفحص الـ session
  unknown,
  /// مفيش session = Guest
  unauthenticated,
  /// عملية auth جارية (loading)
  processing,
  /// المستخدم سجل لكن مأكدش الإيميل
  awaitingEmailConfirmation,
  /// مسجل دخول لكن مكملش بروفايل
  authenticatedNoProfile,
  /// مسجل دخول كامل
  authenticated,
}

class AuthState extends Equatable {
  const AuthState({
    this.status = AuthStatus.unknown,
    this.user,
    this.failure,
  });

  final AuthStatus status;
  final AuthUser? user;
  final Failure? failure;

  bool get isAuthenticated => status == AuthStatus.authenticated;
  bool get isGuest => status == AuthStatus.unauthenticated;

  const AuthState.unknown() : this();
  const AuthState.unauthenticated() : this(status: AuthStatus.unauthenticated);
  const AuthState.processing({AuthUser? user})
      : this(status: AuthStatus.processing, user: user);

  const AuthState.awaitingConfirmation(AuthUser user)
      : this(status: AuthStatus.awaitingEmailConfirmation, user: user);

  const AuthState.authenticatedNoProfile(AuthUser user)
      : this(status: AuthStatus.authenticatedNoProfile, user: user);

  const AuthState.authenticated(AuthUser user)
      : this(status: AuthStatus.authenticated, user: user);

  AuthState withFailure(Failure failure) =>
      AuthState(status: status, user: user, failure: failure);

  AuthState clearFailure() =>
      AuthState(status: status, user: user);

  @override
  List<Object?> get props => [status, user, failure];
}
