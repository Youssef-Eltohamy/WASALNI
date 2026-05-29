import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'otp_state.dart';

class OtpCubit extends Cubit<OtpState> {
  OtpCubit(this._repo) : super(const OtpState.idle());

  final AuthRepository _repo;
  Timer? _timer;
  static const _resendStart = 30;

  Future<void> requestCode(String phone) async {
    emit(const OtpState.sending());
    try {
      await _repo.requestOtp(phone);
      _startCountdown();
    } on AuthException catch (e) {
      _mapError(e);
    }
  }

  Future<void> resend(String phone) => requestCode(phone);

  Future<void> verify({required String phone, required String code}) async {
    // Stop the resend countdown while verifying so its ticks can't overwrite
    // the verifying/result state (the user can resend again after a failure).
    _timer?.cancel();
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

  void _startCountdown() {
    _timer?.cancel();
    emit(const OtpState.codeSent(resendSeconds: _resendStart));
    var remaining = _resendStart;
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      remaining--;
      if (remaining <= 0) {
        t.cancel();
        emit(const OtpState.codeSent(resendSeconds: 0));
      } else {
        emit(OtpState.codeSent(resendSeconds: remaining));
      }
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
