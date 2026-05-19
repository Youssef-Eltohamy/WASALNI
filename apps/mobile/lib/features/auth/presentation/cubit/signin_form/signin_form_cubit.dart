import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../../../../core/validators/email_validator.dart';
import '../../../data/repositories/auth_repository.dart';

part 'signin_form_state.dart';

class SigninFormCubit extends Cubit<SigninFormState> {
  SigninFormCubit({required AuthRepository repository})
      : _repository = repository,
        super(const SigninFormState());

  final AuthRepository _repository;

  void emailChanged(String value) {
    final email = EmailInput.dirty(value);
    emit(state.copyWith(email: email, clearError: true));
  }

  void passwordChanged(String value) {
    final password = SigninPasswordInput.dirty(value);
    emit(state.copyWith(password: password, clearError: true));
  }

  Future<void> submit() async {
    if (!state.isValid || state.isSubmitting) return;
    emit(state.copyWith(isSubmitting: true, clearError: true));

    final result = await _repository.signIn(
      email: state.email.value.trim(),
      password: state.password.value,
    );

    result.fold(
      (failure) {
        final isNotConfirmed = failure.message.contains('غير مؤكد');
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: failure.message,
          needsEmailConfirmation: isNotConfirmed,
        ));
      },
      (_) => emit(state.copyWith(isSubmitting: false)),
    );
  }
}
