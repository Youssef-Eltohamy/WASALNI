import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit(this._repo, this._phone, this._token)
      : super(const ResetPasswordState.idle());
  final AuthRepository _repo;
  final String _phone;
  final String _token;

  Future<void> submit(String newPassword) async {
    emit(const ResetPasswordState.submitting());
    try {
      final profile = await _repo.setNewPassword(
          phone: _phone, token: _token, newPassword: newPassword);
      emit(ResetPasswordState.success(profile));
    } on ResetTokenInvalidException catch (e) {
      emit(ResetPasswordState.tokenInvalid(e.message ?? 'انتهت الجلسة'));
    } on AuthException catch (e) {
      emit(ResetPasswordState.error(e.message ?? 'تعذّر تغيير كلمة السر'));
    } on NoConnectionException {
      emit(const ResetPasswordState.error('مفيش اتصال بالإنترنت'));
    }
  }
}
