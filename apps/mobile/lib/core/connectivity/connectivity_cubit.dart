import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'connectivity_service.dart';

enum ConnectivityStatus { online, offline }

class ConnectivityCubit extends Cubit<ConnectivityStatus> {
  ConnectivityCubit(this.service) : super(ConnectivityStatus.online);

  final ConnectivityService service;
  StreamSubscription<bool>? _sub;

  Future<void> init() async {
    bool online;
    try {
      online = await service.isOnline();
    } catch (_) {
      online = true; // if the platform check fails, assume online (don't block the app)
    }
    emit(online ? ConnectivityStatus.online : ConnectivityStatus.offline);
    _sub = service.onStatusChange.listen(
      (online) =>
          emit(online ? ConnectivityStatus.online : ConnectivityStatus.offline),
    );
  }

  @override
  Future<void> close() {
    _sub?.cancel();
    return super.close();
  }
}
