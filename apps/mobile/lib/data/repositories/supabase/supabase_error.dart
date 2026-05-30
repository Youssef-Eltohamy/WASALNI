import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/network/repository_exception.dart';

/// Translates an error thrown during a Supabase call into the app's
/// [RepositoryException] types.
///
/// - [PostgrestException] (server/RLS/SQL error) → [ServerException].
/// - A genuine network failure → [NoConnectionException]. We detect it by the
///   runtime type name (`SocketException` on mobile, `ClientException` on web)
///   instead of importing `dart:io`, which would break the web build.
/// - Anything else (e.g. a mapper `TypeError` from an unexpected row shape) →
///   [ServerException] with the message, so real bugs are NOT disguised as
///   "no internet".
///
/// Always throws; the `Never` return lets callers write `catch (e) =>
/// throwRepositoryError(e)` as the last clause.
Never throwRepositoryError(Object error) {
  if (error is PostgrestException) {
    throw ServerException(error.message);
  }
  final typeName = error.runtimeType.toString();
  if (typeName.contains('SocketException') ||
      typeName.contains('ClientException')) {
    throw const NoConnectionException();
  }
  throw ServerException(error.toString());
}
