import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_state.dart';

class ResetCubit extends Cubit<ResetState> {
  ResetCubit(this._repo) : super(const ResetState.phone());
  final AuthRepository _repo;

  String _phone = '';

  Future<void> submitPhone(String phone) async {
    _phone = phone;
    emit(const ResetState.submitting());
    try {
      await _repo.startReset(phone: phone);
      emit(const ResetState.codeSent());
    } on AuthException catch (e) {
      emit(ResetState.phoneError(e.message ?? 'تعذّر إرسال الكود'));
    } on NoConnectionException {
      emit(const ResetState.phoneError('مفيش اتصال بالإنترنت'));
    }
  }

  Future<void> resend() async {
    try {
      await _repo.startReset(phone: _phone);
    } catch (_) {/* best-effort in mock */}
  }

  Future<void> confirm({required String code, required String newPassword}) async {
    emit(const ResetState.verifying());
    try {
      final profile =
          await _repo.confirmReset(phone: _phone, code: code, newPassword: newPassword);
      emit(ResetState.success(profile));
    } on AuthException catch (e) {
      emit(ResetState.codeSent(error: e.message));
    } on NoConnectionException {
      emit(const ResetState.codeSent(error: 'مفيش اتصال بالإنترنت'));
    }
  }
}
