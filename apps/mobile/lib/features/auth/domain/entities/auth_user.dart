import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.email,
    required this.isEmailConfirmed,
    required this.createdAt,
  });

  final String id;
  final String email;
  final bool isEmailConfirmed;
  final DateTime createdAt;

  /// أيام متبقية قبل حذف الحساب لو الإيميل مأكدش
  /// (FR-010b: 7 أيام من التسجيل)
  int? get daysLeftBeforeAutoDelete {
    if (isEmailConfirmed) return null;
    final deadline = createdAt.add(const Duration(days: 7));
    final remaining = deadline.difference(DateTime.now()).inDays;
    return remaining.clamp(0, 7);
  }

  @override
  List<Object?> get props => [id, email, isEmailConfirmed, createdAt];
}
