import '../models/profile.dart';

abstract interface class AuthRepository {
  Future<void> requestOtp(String phone);
  Future<Profile> verifyOtp({required String phone, required String code});
}
