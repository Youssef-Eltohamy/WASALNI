import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/app/app.dart';
import 'package:wasalni/app/di.dart';
import 'package:wasalni/core/connectivity/connectivity_service.dart';

// Widget tests have no platform plugins, so override connectivity with a fake.
class _FakeConn implements ConnectivityService {
  @override
  Stream<bool> get onStatusChange => Stream<bool>.empty();
  @override
  Future<bool> isOnline() async => true;
}

void main() {
  setUp(() async {
    await getIt.reset();
    setupDi();
    getIt.unregister<ConnectivityService>();
    getIt.registerLazySingleton<ConnectivityService>(_FakeConn.new);
  });

  testWidgets('App boots, shows RTL home, and switches tabs', (tester) async {
    await tester.pumpWidget(const App());
    await tester.pumpAndSettle();

    expect(find.text('وصلني'), findsWidgets);
    expect(find.byType(NavigationBar), findsOneWidget);

    await tester.tap(find.text('حسابي'));
    await tester.pumpAndSettle();
    // AccountScreen: guest state shows the sign-in prompt
    expect(find.text('تسجيل الدخول'), findsOneWidget);
  });
}
