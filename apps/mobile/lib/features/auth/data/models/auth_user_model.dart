import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../domain/entities/auth_user.dart';

class AuthUserMapper {
  AuthUserMapper._();

  static AuthUser fromSupabase(sb.User user) {
    return AuthUser(
      id: user.id,
      email: user.email ?? '',
      isEmailConfirmed: user.emailConfirmedAt != null,
      createdAt: DateTime.parse(user.createdAt),
    );
  }
}
