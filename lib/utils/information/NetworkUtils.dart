import 'dart:io';

class NetworkUtils {

  /// Checks if the phone is connected to the Internet by trying to
  /// reach example.com domain.
  ///
  /// https://stackoverflow.com/a/49648870/11243782
  static Future<bool> hasInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }
    return false;
  }
}