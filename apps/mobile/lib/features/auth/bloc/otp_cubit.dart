import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._repo) : super(const OtpState.idle());

  final AuthRepository _repo;

  Future<void> requestCode(String phone) async {
    emit(const OtpState.sending());
    try {
      await _repo.requestOtp(phone);
      emit(const OtpState.codeSent());
    } on AuthException catch (e) {
      _mapError(e);
    }
  }

  Future<void> resend(String phone) => requestCode(phone);

  Future<void> verify({required String phone, required String code}) async {
    emit(const OtpState.verifying());
    try {
      final profile = await _repo.verifyOtp(phone: phone, code: code);
      emit(OtpState.success(profile));
    } on AuthException catch (e) {
      _mapError(e);
    }
  }

  void _mapError(AuthException e) => emit(switch (e) {
        OtpExpiredException() => const OtpState.expired(),
        OtpRateLimitedException() => const OtpState.rateLimited(),
        OtpWrongCodeException() => const OtpState.wrongCode(),
      });
}
