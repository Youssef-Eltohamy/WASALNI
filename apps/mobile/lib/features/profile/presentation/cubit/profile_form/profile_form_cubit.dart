import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../../core/constants/governorates.dart';
import '../../../../../core/validators/phone_validator.dart';
import '../../../../../core/validators/required_text_validator.dart';

part 'profile_form_state.dart';

class ProfileFormCubit extends Cubit<ProfileFormState> {
  ProfileFormCubit() : super(const ProfileFormState());

  void fullNameChanged(String value) {
    final input = RequiredTextInput.dirty(
      value: value,
      minLength: 3,
      fieldName: 'الاسم الكامل',
    );
    emit(state.copyWith(fullName: input, clearError: true));
  }

  void phoneChanged(String value) {
    final input = PhoneInput.dirty(value);
    emit(state.copyWith(phone: input, clearError: true));
  }

  void governorateChanged(Governorate? value) {
    emit(state.copyWith(governorate: value, clearError: true));
  }

  void cityOrVillageChanged(String value) {
    final input = RequiredTextInput.dirty(
      value: value,
      minLength: 2,
      fieldName: 'المدينة/القرية',
    );
    emit(state.copyWith(cityOrVillage: input, clearError: true));
  }

  void avatarChanged(File? file) {
    emit(state.copyWith(
      avatarFile: file,
      clearAvatar: file == null,
      clearError: true,
    ));
  }

  void birthDateChanged(DateTime? date) {
    emit(state.copyWith(
      birthDate: date,
      clearBirthDate: date == null,
      clearError: true,
    ));
  }

  /// يستخدم بعد ProfileBloc يأكد النجاح
  void setSubmitting(bool value) {
    emit(state.copyWith(isSubmitting: value, clearError: value));
  }

  void setError(String message) {
    emit(state.copyWith(isSubmitting: false, errorMessage: message));
  }

  void setSuccess() {
    emit(state.copyWith(isSubmitting: false, isSuccess: true));
  }

  /// يجهّز البيانات الـ normalized للإرسال
  String? get normalizedPhone => PhoneInput.tryNormalize(state.phone.value);
}
