import 'dart:io';
import 'dart:typed_data';

import 'package:fpdart/fpdart.dart';
import 'package:image/image.dart' as img;
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../../../../core/errors/error_mapper.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/network/supabase_client.dart';
import '../../domain/entities/profile.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  ProfileRepository({sb.SupabaseClient? client})
      : _client = client ?? SupabaseService.client;

  final sb.SupabaseClient _client;

  static const String _table = 'profiles';
  static const String _avatarsBucket = 'avatars';

  /// جلب البروفايل بـ id. يرجع Right(null) لو مفيش (المستخدم مكملش بياناته).
  Future<Either<Failure, Profile?>> getProfile(String userId) async {
    try {
      final response = await _client
          .from(_table)
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response == null) return const Right(null);
      return Right(ProfileMapper.fromJson(response));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// إنشاء البروفايل أول مرة (بعد تأكيد الإيميل).
  Future<Either<Failure, Profile>> createProfile({
    required String userId,
    required String fullName,
    required String phone,
    required String governorate,
    required String cityOrVillage,
    String? avatarUrl,
    DateTime? birthDate,
  }) async {
    try {
      final payload = ProfileMapper.toInsertJson(
        id: userId,
        fullName: fullName,
        phone: phone,
        governorate: governorate,
        cityOrVillage: cityOrVillage,
        avatarUrl: avatarUrl,
        birthDate: birthDate,
      );
      final response =
          await _client.from(_table).insert(payload).select().single();
      return Right(ProfileMapper.fromJson(response));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// تحديث جزئي للبروفايل.
  Future<Either<Failure, Profile>> updateProfile({
    required String userId,
    String? fullName,
    String? phone,
    String? governorate,
    String? cityOrVillage,
    String? avatarUrl,
    DateTime? birthDate,
  }) async {
    try {
      final payload = ProfileMapper.toUpdateJson(
        fullName: fullName,
        phone: phone,
        governorate: governorate,
        cityOrVillage: cityOrVillage,
        avatarUrl: avatarUrl,
        birthDate: birthDate,
      );
      if (payload.isEmpty) {
        return const Left(ProfileFailure('لا يوجد بيانات للتحديث'));
      }
      final response = await _client
          .from(_table)
          .update(payload)
          .eq('id', userId)
          .select()
          .single();
      return Right(ProfileMapper.fromJson(response));
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// رفع الصورة الشخصية (مع ضغط client-side).
  /// يرجع الـ public URL للصورة بعد الرفع.
  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required File file,
  }) async {
    try {
      final compressed = await _compressImage(file);
      final path = '$userId/avatar.jpg';
      await _client.storage.from(_avatarsBucket).uploadBinary(
            path,
            compressed,
            fileOptions: const sb.FileOptions(
              upsert: true,
              contentType: 'image/jpeg',
            ),
          );
      final publicUrl = _client.storage.from(_avatarsBucket).getPublicUrl(path);
      // ?t={timestamp} يجبر cache invalidation للصورة لو اتغيرت
      return Right('$publicUrl?t=${DateTime.now().millisecondsSinceEpoch}');
    } catch (e) {
      return Left(mapErrorToFailure(e));
    }
  }

  /// ضغط الصورة: تصغير إلى 800×800 max + JPEG quality 85
  Future<Uint8List> _compressImage(File file) async {
    final bytes = await file.readAsBytes();
    final original = img.decodeImage(bytes);
    if (original == null) {
      throw const FormatException('صورة غير صالحة');
    }

    final img.Image resized;
    if (original.width > 800 || original.height > 800) {
      resized = img.copyResize(
        original,
        width: original.width >= original.height ? 800 : null,
        height: original.height > original.width ? 800 : null,
      );
    } else {
      resized = original;
    }

    return Uint8List.fromList(img.encodeJpg(resized, quality: 85));
  }
}
