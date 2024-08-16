import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static Future<bool> checkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  static Stream<ConnectivityResult> connectivityChanged() {
    return Connectivity().onConnectivityChanged;
  }
}
