import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit(this._repo) : super(const LoginState.idle());
  final AuthRepository _repo;

  Future<void> submit({required String phone, required String password}) async {
    emit(const LoginState.submitting());
    try {
      final profile = await _repo.login(phone: phone, password: password);
      emit(LoginState.success(profile));
    } on AuthException catch (e) {
      emit(LoginState.error(e.message ?? 'تعذّر تسجيل الدخول'));
    } on NoConnectionException {
      emit(const LoginState.error('مفيش اتصال بالإنترنت'));
    }
  }
}
