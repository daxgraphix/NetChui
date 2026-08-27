import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  ConnectivityService() : _connectivity = Connectivity();

  final Connectivity _connectivity;
  static const _timeout = Duration(seconds: 4);

  Future<bool> get isOnline async {
    try {
      final results = await _connectivity
          .checkConnectivity()
          .timeout(_timeout);
      
      if (results.contains(ConnectivityResult.none)) return false;
      
      // Perform a quick lookup to verify actual internet access if not "none"
      try {
        final result = await InternetAddress.lookup('google.com').timeout(const Duration(seconds: 2));
        return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
      } catch (_) {
        return false;
      }
    } on TimeoutException {
      return false;
    } on Object {
      return false;
    }
  }

  Future<String> connectionLabel() async {
    List<ConnectivityResult> results;
    try {
      results = await _connectivity
          .checkConnectivity()
          .timeout(_timeout);
    } on TimeoutException {
      return 'Connected';
    } on Object {
      return 'Connected';
    }
    if (results.contains(ConnectivityResult.none)) {
      return 'Offline';
    }
    if (results.contains(ConnectivityResult.wifi)) {
      return 'Wi‑Fi';
    }
    if (results.contains(ConnectivityResult.mobile)) {
      return 'Mobile data';
    }
    if (results.contains(ConnectivityResult.ethernet)) {
      return 'Ethernet';
    }
    return 'Connected';
  }

  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}
