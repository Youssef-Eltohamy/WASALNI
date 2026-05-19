import 'dart:io';

import 'package:supabase_flutter/supabase_flutter.dart';

import 'failures.dart';

Failure mapErrorToFailure(Object error) {
  // 1) Network errors
  if (error is SocketException) {
    return const NetworkFailure('تحقق من اتصالك بالإنترنت');
  }

  // 2) Supabase Auth errors
  if (error is AuthApiException) {
    return _mapAuthApiException(error);
  }
  if (error is AuthException) {
    return AuthFailure(_translateAuthMessage(error.message));
  }

  // 3) Supabase Postgres errors
  if (error is PostgrestException) {
    return _mapPostgrestException(error);
  }

  // 4) Supabase Storage errors
  if (error is StorageException) {
    return StorageFailure(_translateStorageMessage(error.message));
  }

  // 5) Format errors (validation)
  if (error is FormatException) {
    return ValidationFailure(error.message);
  }

  return const UnknownFailure('حصل خطأ غير متوقع، حاول تاني');
}

AuthFailure _mapAuthApiException(AuthApiException e) {
  final code = e.statusCode;
  switch (code) {
    case '400':
      if (e.message.contains('Invalid login')) {
        return const AuthFailure('بيانات الدخول غير صحيحة');
      }
      if (e.message.toLowerCase().contains('email not confirmed')) {
        return const AuthFailure('الإيميل غير مؤكد، تحقق من بريدك');
      }
      return AuthFailure(_translateAuthMessage(e.message));
    case '422':
      if (e.message.toLowerCase().contains('already')) {
        return const AuthFailure('الإيميل مسجل بالفعل، حاول تسجيل الدخول');
      }
      return AuthFailure(_translateAuthMessage(e.message));
    case '429':
      return const AuthFailure('محاولات كتيرة، حاول بعد دقيقة');
    default:
      return AuthFailure(_translateAuthMessage(e.message));
  }
}

ProfileFailure _mapPostgrestException(PostgrestException e) {
  switch (e.code) {
    case '23505':
      if (e.message.contains('phone')) {
        return const ProfileFailure('رقم الموبايل ده مستخدم بالفعل');
      }
      return const ProfileFailure('البيانات دي موجودة بالفعل');
    case '23514':
      return const ProfileFailure('بيانات غير صالحة، تحقق من المدخلات');
    case '42501':
      return const ProfileFailure('ليس لديك صلاحية لهذه العملية');
    case 'PGRST116':
      return const ProfileFailure('البيانات غير موجودة');
    default:
      return ProfileFailure(e.message);
  }
}

String _translateAuthMessage(String message) {
  final lower = message.toLowerCase();
  if (lower.contains('invalid')) return 'بيانات الدخول غير صحيحة';
  if (lower.contains('weak')) return 'كلمة السر ضعيفة';
  if (lower.contains('not confirmed')) return 'الإيميل غير مؤكد';
  if (lower.contains('expired')) return 'انتهت صلاحية الرابط';
  if (lower.contains('network')) return 'تحقق من اتصالك بالإنترنت';
  return 'حصل خطأ، حاول تاني';
}

String _translateStorageMessage(String message) {
  final lower = message.toLowerCase();
  if (lower.contains('size')) return 'حجم الصورة كبير، الحد 2MB';
  if (lower.contains('mime') || lower.contains('type')) {
    return 'صيغة الصورة غير مدعومة (JPG/PNG/WebP)';
  }
  return 'فشل رفع الصورة، حاول تاني';
}
