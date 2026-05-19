part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

/// Bootstrap: نفحص لو في session موجودة عند فتح التطبيق
class AuthStarted extends AuthEvent {
  const AuthStarted();
}

/// المستخدم سجل
class SignupRequested extends AuthEvent {
  const SignupRequested({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// المستخدم سجل دخول
class SigninRequested extends AuthEvent {
  const SigninRequested({required this.email, required this.password});
  final String email;
  final String password;

  @override
  List<Object> get props => [email, password];
}

/// طلب إعادة إرسال إيميل التأكيد
class ResendConfirmationRequested extends AuthEvent {
  const ResendConfirmationRequested(this.email);
  final String email;

  @override
  List<Object> get props => [email];
}

/// المستخدم خرج
class SignoutRequested extends AuthEvent {
  const SignoutRequested();
}

/// Internal: Supabase أبلغنا بتغير الـ auth state
class _AuthUserChanged extends AuthEvent {
  const _AuthUserChanged(this.user);
  final AuthUser? user;

  @override
  List<Object?> get props => [user];
}

/// المستخدم لقى بروفايل (بعد ProfileBloc ما يلوّد بنجاح)
class ProfileFound extends AuthEvent {
  const ProfileFound();
}

/// مفيش بروفايل بعد (المستخدم لازم يكمل setup)
class ProfileMissing extends AuthEvent {
  const ProfileMissing();
}
