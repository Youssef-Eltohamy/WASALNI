import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/network/repository_exception.dart';
import '../../../data/repositories/auth_repository.dart';
import '../auth_exceptions.dart';
import 'reset_phone_state.dart';

class ResetPhoneCubit extends Cubit<ResetPhoneState> {
  ResetPhoneCubit(this._repo) : super(const ResetPhoneState.idle());
  final AuthRepository _repo;

  Future<void> submit(String phone) async {
    emit(const ResetPhoneState.submitting());
    try {
      await _repo.startReset(phone: phone);
      emit(ResetPhoneState.sent(phone));
    } on AuthException catch (e) {
      emit(ResetPhoneState.error(e.message ?? 'تعذّر إرسال الكود'));
    } on NoConnectionException {
      emit(const ResetPhoneState.error('مفيش اتصال بالإنترنت'));
    }
  }
}
