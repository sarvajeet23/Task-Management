import 'dart:async';
import 'dart:developer';
import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  NetworkService._internal();
  static final NetworkService _instance = NetworkService._internal();

  final _connectivity = Connectivity();
  var isConnected = false;
  var isInitialized = false;
  StreamSubscription<dynamic>? _streamSubscription;

  final StreamController<bool> _connectionStatusController =
      StreamController<bool>.broadcast();

  static NetworkService get instance => _instance;
  Stream<bool> get connectionStatus =>
      _connectionStatusController.stream.asBroadcastStream();

  close() {
    _streamSubscription?.cancel();
    _connectionStatusController.close();
    isInitialized = false;
  }

  Future<void> init() async {
    log('NetworkController Initializing');

    if (isInitialized) {
      log('NetworkController Already Initialized');
      return;
    }

    _checkForInternetConnectivity();
    log('NetworkController Initialized');
  }

  void _checkForInternetConnectivity() {
    _streamSubscription =
        _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> result) {
      if (result.contains(ConnectivityResult.mobile)) {
        isConnected = true;
        _connectionStatusController.add(true);
        log('Internet Connection Available');
      } else if (result.contains(ConnectivityResult.wifi)) {
        isConnected = true;
        _connectionStatusController.add(true);
        log('Internet Connection Available');
      } else {
        isConnected = false;
        _connectionStatusController.add(false);
        log('No Internet Connection');
      }
    });
  }
}
