import 'dart:async';
import 'package:bloc_test/bloc_test.dart';
import 'package:wasalni/core/connectivity/connectivity_cubit.dart';
import 'package:wasalni/core/connectivity/connectivity_service.dart';

class FakeConnectivityService implements ConnectivityService {
  final _controller = StreamController<bool>.broadcast();
  bool online = true;
  void emit(bool value) => _controller.add(value);
  @override
  Stream<bool> get onStatusChange => _controller.stream;
  @override
  Future<bool> isOnline() async => online;
}

void main() {
  blocTest<ConnectivityCubit, ConnectivityStatus>(
    'emits offline then online as the service stream changes',
    build: () => ConnectivityCubit(FakeConnectivityService()..online = true),
    act: (cubit) async {
      final svc = cubit.service as FakeConnectivityService;
      await cubit.init();
      svc.emit(false);
      svc.emit(true);
    },
    expect: () => [
      ConnectivityStatus.online,
      ConnectivityStatus.offline,
      ConnectivityStatus.online,
    ],
  );
}
