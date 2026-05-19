part of 'profile_form_cubit.dart';

class ProfileFormState extends Equatable {
  const ProfileFormState({
    this.fullName = const RequiredTextInput.pure(
      minLength: 3,
      fieldName: 'الاسم الكامل',
    ),
    this.phone = const PhoneInput.pure(),
    this.governorate,
    this.cityOrVillage = const RequiredTextInput.pure(
      minLength: 2,
      fieldName: 'المدينة/القرية',
    ),
    this.avatarFile,
    this.birthDate,
    this.isSubmitting = false,
    this.errorMessage,
    this.isSuccess = false,
  });

  final RequiredTextInput fullName;
  final PhoneInput phone;
  final Governorate? governorate;
  final RequiredTextInput cityOrVillage;
  final File? avatarFile;
  final DateTime? birthDate;
  final bool isSubmitting;
  final String? errorMessage;
  final bool isSuccess;

  bool get isValid =>
      Formz.validate([fullName, phone, cityOrVillage]) && governorate != null;

  ProfileFormState copyWith({
    RequiredTextInput? fullName,
    PhoneInput? phone,
    Governorate? governorate,
    RequiredTextInput? cityOrVillage,
    File? avatarFile,
    bool clearAvatar = false,
    DateTime? birthDate,
    bool clearBirthDate = false,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool? isSuccess,
  }) {
    return ProfileFormState(
      fullName: fullName ?? this.fullName,
      phone: phone ?? this.phone,
      governorate: governorate ?? this.governorate,
      cityOrVillage: cityOrVillage ?? this.cityOrVillage,
      avatarFile: clearAvatar ? null : (avatarFile ?? this.avatarFile),
      birthDate: clearBirthDate ? null : (birthDate ?? this.birthDate),
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        phone,
        governorate,
        cityOrVillage,
        avatarFile?.path,
        birthDate,
        isSubmitting,
        errorMessage,
        isSuccess,
      ];
}
