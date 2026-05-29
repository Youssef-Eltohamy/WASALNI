import 'package:connectivity_plus/connectivity_plus.dart';

abstract interface class ConnectivityService {
  Stream<bool> get onStatusChange;
  Future<bool> isOnline();
}

class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl([Connectivity? connectivity])
      : _connectivity = connectivity ?? Connectivity();
  final Connectivity _connectivity;

  bool _isOnline(List<ConnectivityResult> r) =>
      r.isNotEmpty && !(r.length == 1 && r.first == ConnectivityResult.none);

  @override
  Stream<bool> get onStatusChange =>
      _connectivity.onConnectivityChanged.map(_isOnline);

  @override
  Future<bool> isOnline() async =>
      _isOnline(await _connectivity.checkConnectivity());
}
