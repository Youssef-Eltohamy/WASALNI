part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

/// تحميل البروفايل بـ user id
class LoadProfile extends ProfileEvent {
  const LoadProfile(this.userId);
  final String userId;

  @override
  List<Object> get props => [userId];
}

/// إنشاء البروفايل أول مرة
class CreateProfileRequested extends ProfileEvent {
  const CreateProfileRequested({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.governorate,
    required this.cityOrVillage,
    this.avatarFile,
    this.birthDate,
  });

  final String userId;
  final String fullName;
  final String phone;
  final String governorate;
  final String cityOrVillage;
  final File? avatarFile;
  final DateTime? birthDate;

  @override
  List<Object?> get props => [
        userId,
        fullName,
        phone,
        governorate,
        cityOrVillage,
        avatarFile?.path,
        birthDate,
      ];
}

/// تحديث جزئي للبروفايل
class UpdateProfileRequested extends ProfileEvent {
  const UpdateProfileRequested({
    required this.userId,
    this.fullName,
    this.phone,
    this.governorate,
    this.cityOrVillage,
    this.avatarFile,
    this.birthDate,
  });

  final String userId;
  final String? fullName;
  final String? phone;
  final String? governorate;
  final String? cityOrVillage;
  final File? avatarFile;
  final DateTime? birthDate;

  @override
  List<Object?> get props => [
        userId,
        fullName,
        phone,
        governorate,
        cityOrVillage,
        avatarFile?.path,
        birthDate,
      ];
}

/// مسح الـ state (عند تسجيل الخروج مثلاً)
class ProfileCleared extends ProfileEvent {
  const ProfileCleared();
}
