import 'package:freezed_annotation/freezed_annotation.dart';

part 'village.freezed.dart';

@freezed
abstract class Village with _$Village {
  const factory Village({
    required String id,
    required String name,
    required String governorate,
    required String markaz,
  }) = _Village;
}
