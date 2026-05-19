import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  const Profile({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.governorate,
    required this.cityOrVillage,
    this.avatarUrl,
    this.birthDate,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String fullName;
  final String phone;            // +201XXXXXXXXX
  final String governorate;
  final String cityOrVillage;
  final String? avatarUrl;
  final DateTime? birthDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  Profile copyWith({
    String? fullName,
    String? phone,
    String? governorate,
    String? cityOrVillage,
    String? avatarUrl,
    DateTime? birthDate,
  }) {
    return Profile(
      id: id,
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      cityOrVillage: cityOrVillage ?? this.cityOrVillage,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      birthDate: birthDate ?? this.birthDate,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        fullName,
        phone,
        governorate,
        cityOrVillage,
        avatarUrl,
        birthDate,
        createdAt,
        updatedAt,
      ];
}
