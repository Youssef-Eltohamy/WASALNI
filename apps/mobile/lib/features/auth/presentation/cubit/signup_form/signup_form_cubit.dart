import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../../core/validators/email_validator.dart';
import '../../../../../core/validators/password_validator.dart';
import '../../../data/repositories/auth_repository.dart';

part 'signup_form_state.dart';

class SignupFormCubit extends Cubit<SignupFormState> {
  SignupFormCubit({required AuthRepository repository})
      : _repository = repository,
        super(const SignupFormState());

  final AuthRepository _repository;

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(state.copyWith(email: email, clearError: true));
  }

  void passwordChanged(String value) {
    final password = PasswordInput.dirty(value);
    final confirm = ConfirmPasswordInput.dirty(
      password: value,
      value: state.confirmPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmPassword: confirm,
      clearError: true,
    ));
  }

  void confirmPasswordChanged(String value) {
    final confirm = ConfirmPasswordInput.dirty(
      password: state.password.value,
      value: value,
    );
    emit(state.copyWith(confirmPassword: confirm, clearError: true));
  }

  void termsAcceptedChanged(bool value) {
    emit(state.copyWith(termsAccepted: value, clearError: true));
  }

  Future<void> submit() async {
    if (!state.isValid || state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));

    final result = await _repository.signUp(
      email: state.email.value.trim(),
      password: state.password.value,
    );

    result.fold(
      (failure) => emit(state.copyWith(
        isSubmitting: false,
        errorMessage: failure.message,
      )),
      (_) => emit(state.copyWith(isSubmitting: false, isSuccess: true)),
    );
  }
}
