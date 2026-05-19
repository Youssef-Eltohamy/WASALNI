// ignore_for_file: use_null_aware_elements

import '../../domain/entities/profile.dart';

class ProfileMapper {
  ProfileMapper._();

  /// يحول صف من DB إلى Profile entity
  static Profile fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as String,
      fullName: json['full_name'] as String,
      phone: json['phone'] as String,
      governorate: json['governorate'] as String,
      cityOrVillage: json['city_or_village'] as String,
      avatarUrl: json['avatar_url'] as String?,
      birthDate: json['birth_date'] != null
          ? DateTime.parse(json['birth_date'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  /// تحويل Profile لـ INSERT/UPDATE payload
  static Map<String, dynamic> toInsertJson({
    required String id,
    required String fullName,
    required String phone,
    required String governorate,
    required String cityOrVillage,
    String? avatarUrl,
    DateTime? birthDate,
  }) {
    return {
      'id': id,
      'full_name': fullName,
      'phone': phone,
      'governorate': governorate,
      'city_or_village': cityOrVillage,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (birthDate != null)
        'birth_date':
            '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
    };
  }

  /// تحويل تعديلات جزئية لـ UPDATE payload (only changed fields)
  static Map<String, dynamic> toUpdateJson({
    String? fullName,
    String? phone,
    String? governorate,
    String? cityOrVillage,
    String? avatarUrl,
    DateTime? birthDate,
  }) {
    return {
      if (fullName != null) 'full_name': fullName,
      if (phone != null) 'phone': phone,
      if (governorate != null) 'governorate': governorate,
      if (cityOrVillage != null) 'city_or_village': cityOrVillage,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
      if (birthDate != null)
        'birth_date':
            '${birthDate.year}-${birthDate.month.toString().padLeft(2, '0')}-${birthDate.day.toString().padLeft(2, '0')}',
    };
  }
}
