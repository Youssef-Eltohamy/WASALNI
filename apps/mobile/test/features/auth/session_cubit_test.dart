import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wasalni/data/models/profile.dart';
import 'package:wasalni/features/auth/bloc/session_cubit.dart';
import 'package:wasalni/features/auth/bloc/session_state.dart';

Profile _profile() => Profile(
    id: 'u1', phone: '+201000000000', displayName: 'محمد', createdAt: DateTime(2026));

void main() {
  test('starts as guest', () {
    expect(SessionCubit().state, isA<SessionGuest>());
  });

  blocTest<SessionCubit, SessionState>(
    'signIn → authenticated with profile',
    build: SessionCubit.new,
    act: (c) => c.signIn(_profile()),
    expect: () => [isA<SessionAuthenticated>()],
    verify: (c) =>
        expect((c.state as SessionAuthenticated).profile.displayName, 'محمد'),
  );

  blocTest<SessionCubit, SessionState>(
    'signOut → back to guest',
    build: SessionCubit.new,
    act: (c) { c.signIn(_profile()); c.signOut(); },
    expect: () => [isA<SessionAuthenticated>(), isA<SessionGuest>()],
  );

  test('displayName helper: empty for guest, name when authenticated', () {
    final c = SessionCubit();
    expect(c.displayName, '');
    c.signIn(_profile());
    expect(c.displayName, 'محمد');
  });
}
