/// Errors a repository can surface. UI maps each to a distinct state.
sealed class RepositoryException implements Exception {
  const RepositoryException([this.message]);
  final String? message;
}

class NoConnectionException extends RepositoryException {
  const NoConnectionException() : super('لا يوجد اتصال بالإنترنت');
}

class RequestTimeoutException extends RepositoryException {
  const RequestTimeoutException() : super('انتهت مهلة الاتصال');
}

class ServerException extends RepositoryException {
  const ServerException([super.message = 'خطأ في الخادم']);
}

class NotFoundException extends RepositoryException {
  const NotFoundException([super.message = 'غير موجود']);
}
