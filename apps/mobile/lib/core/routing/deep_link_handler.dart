import 'dart:async';

import 'package:app_links/app_links.dart';

/// Singleton يستمع للـ deep links (wasalni://...) ويوجّه التطبيق.
///
/// Supabase SDK يعالج auth tokens تلقائياً عن طريق
/// `onAuthStateChange` stream، فمحتاجين بس نضمن إن الـ App أتفتح
/// لو كان في الخلفية لما لينك الإيميل يضغط.
class DeepLinkHandler {
  DeepLinkHandler._();
  static final DeepLinkHandler instance = DeepLinkHandler._();

  final AppLinks _appLinks = AppLinks();
  StreamSubscription<Uri>? _sub;

  /// تهيئة. تستدعى مرة واحدة في `main` بعد Supabase init.
  Future<void> init() async {
    // عالج cold start (App كان مقفول لما الـ link اتضغط)
    final initialLink = await _appLinks.getInitialLink();
    if (initialLink != null) _handle(initialLink);

    // عالج warm start (App في الخلفية)
    _sub?.cancel();
    _sub = _appLinks.uriLinkStream.listen(_handle);
  }

  void _handle(Uri uri) {
    // Supabase SDK بيلتقط الـ session تلقائياً من الـ URL fragment.
    // الـ AuthBloc بيستقبل الحدث من خلال stream `onAuthStateChange`.
    // فمحتاجين بس نسجل للـ debugging.
    // (للمسار الفعلي بعد التأكيد: AuthBloc يعالج الحدث)
  }

  Future<void> dispose() async {
    await _sub?.cancel();
  }
}
