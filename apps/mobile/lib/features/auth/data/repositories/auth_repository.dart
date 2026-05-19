import 'package:fpdart/fpdart.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/supabase_client.dart';
import '../../domain/entities/auth_user.dart';
import '../models/auth_user_model.dart';

class AuthRepository {
  AuthRepository({sb.SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final sb.SupabaseClient _client;

  static const String _emailConfirmRedirect = 'wasalni://auth/confirm';
  static const String _passwordResetRedirect = 'wasalni://auth/reset-password';

  /// المستخدم الحالي (null لو Guest).
  AuthUser? get currentUser {
    final user = _client.auth.currentUser;
    return user != null ? AuthUserMapper.fromSupabase(user) : null;
  }

  /// Stream للـ Auth state changes (login, logout, token refresh, etc.)
  Stream<AuthUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      return user != null ? AuthUserMapper.fromSupabase(user) : null;
    });
  }

  /// إنشاء حساب جديد. Supabase بيبعت إيميل التأكيد تلقائياً.
  Future<Either<Failure, AuthUser>> signUp({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        emailRedirectTo: _emailConfirmRedirect,
      );
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('فشل إنشاء الحساب، حاول تاني'));
      }
      return Right(AuthUserMapper.fromSupabase(user));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// تسجيل دخول. ممكن يفشل لو الإيميل مأكدش.
  Future<Either<Failure, AuthUser>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      final user = response.user;
      if (user == null) {
        return const Left(AuthFailure('بيانات الدخول غير صحيحة'));
      }
      return Right(AuthUserMapper.fromSupabase(user));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// تسجيل خروج. يمسح الـ session محلياً و server-side.
  Future<Either<Failure, void>> signOut() async {
    try {
      await _client.auth.signOut();
      return const Right(null);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// طلب رابط استعادة كلمة السر.
  Future<Either<Failure, void>> resetPasswordForEmail(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(
        email,
        redirectTo: _passwordResetRedirect,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// تحديث كلمة السر (بعد deep link reset).
  Future<Either<Failure, void>> updatePassword(String newPassword) async {
    try {
      await _client.auth
          .updateUser(sb.UserAttributes(password: newPassword));
      return const Right(null);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// إعادة إرسال إيميل التأكيد.
  Future<Either<Failure, void>> resendConfirmation(String email) async {
    try {
      await _client.auth.resend(
        type: sb.OtpType.signup,
        email: email,
        emailRedirectTo: _emailConfirmRedirect,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }
}
