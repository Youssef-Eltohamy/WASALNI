import 'package:freezed_annotation/freezed_annotation.dart';

part 'profile.freezed.dart';

@freezed
abstract class Profile with _$Profile {
  const factory Profile({
    required String id,
    required String phone,
    required String displayName,
    String? villageId,
    required DateTime createdAt,
  }) = _Profile;
}
