import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wasalni/core/network/repository_exception.dart';
import 'package:wasalni/data/repositories/supabase/supabase_error.dart';

/// A fake whose runtime type name contains "ClientException" — stands in for a
/// real network failure without importing dart:io / package:http.
class ClientException implements Exception {}

void main() {
  test('PostgrestException → ServerException', () {
    expect(
      () => throwRepositoryError(
          const PostgrestException(message: 'boom')),
      throwsA(isA<ServerException>()),
    );
  });

  test('a *ClientException (network) → NoConnectionException', () {
    expect(
      () => throwRepositoryError(ClientException()),
      throwsA(isA<NoConnectionException>()),
    );
  });

  test('an unexpected error (e.g. TypeError) → ServerException, not offline',
      () {
    expect(
      () => throwRepositoryError(ArgumentError('bad row')),
      throwsA(isA<ServerException>()),
    );
  });
}
