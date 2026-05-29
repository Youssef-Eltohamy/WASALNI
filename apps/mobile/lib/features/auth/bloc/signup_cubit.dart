import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit(this._repo) : super(const SignupState.form());
  final AuthRepository _repo;

  String _name = '';
  String _phone = '';
  String _password = '';

  Future<void> submitForm({
    required String name,
    required String phone,
    required String password,
  }) async {
    _name = name;
    _phone = phone;
    _password = password;
    emit(const SignupState.submitting());
    try {
      await _repo.startSignup(phone: phone);
      emit(const SignupState.codeSent());
    } on AuthException catch (e) {
      emit(SignupState.formError(e.message ?? 'تعذّر إنشاء الحساب'));
    } on NoConnectionException {
      emit(const SignupState.formError('مفيش اتصال بالإنترنت'));
    }
  }

  Future<void> resend() async {
    try {
      await _repo.startSignup(phone: _phone);
    } catch (_) {/* keep showing codeSent; resend is best-effort in mock */}
  }

  Future<void> confirmCode(String code) async {
    emit(const SignupState.verifying());
    try {
      final profile = await _repo.confirmSignup(
          name: _name, phone: _phone, password: _password, code: code);
      emit(SignupState.success(profile));
    } on OtpWrongCodeException catch (e) {
      emit(SignupState.codeSent(error: e.message));
    } on AuthException catch (e) {
      emit(SignupState.codeSent(error: e.message));
    } on NoConnectionException {
      emit(const SignupState.codeSent(error: 'مفيش اتصال بالإنترنت'));
    }
  }
}
