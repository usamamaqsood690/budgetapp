/// Network Info - Singleton Pattern Implementation
/// Checks internet connectivity status
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:wealthnxai/domain/network/network_info.dart';

class NetworkInfoImpl implements NetworkInfo {
  static NetworkInfoImpl? _instance;
  static NetworkInfoImpl get instance {
    _instance ??= NetworkInfoImpl._internal();
    return _instance!;
  }

  final Connectivity _connectivity;

  NetworkInfoImpl._internal() : _connectivity = Connectivity();

  @override
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    // In connectivity_plus 5.x, checkConnectivity returns List<ConnectivityResult>
    return result.isNotEmpty && !result.contains(ConnectivityResult.none);
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged;
  }
}