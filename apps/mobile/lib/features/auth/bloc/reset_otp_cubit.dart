import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_otp_state.dart';

class ResetOtpCubit extends Cubit<ResetOtpState> {
  ResetOtpCubit(this._repo, this._phone) : super(const ResetOtpState.idle());
  final AuthRepository _repo;
  final String _phone;

  Future<void> verify(String code) async {
    emit(const ResetOtpState.verifying());
    try {
      final token = await _repo.verifyResetCode(phone: _phone, code: code);
      emit(ResetOtpState.verified(token));
    } on AuthException catch (e) {
      emit(ResetOtpState.error(e.message ?? 'الكود غلط'));
    } on NoConnectionException {
      emit(const ResetOtpState.error('مفيش اتصال بالإنترنت'));
    }
  }

  Future<void> resend() async {
    try {
      await _repo.startReset(phone: _phone);
    } catch (_) {/* best-effort: allowed only after the code expires */}
  }
}
