import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

class AppLockService {
  const AppLockService._();

  static final LocalAuthentication _auth = LocalAuthentication();

  static Future<bool> isAvailable() async {
    try {
      final supportsBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();
      return supportsBiometrics || isDeviceSupported;
    } on PlatformException {
      return false;
    }
  }

  static bool shouldLockNow({
    required DateTime lastUnlock,
    required int timeoutMinutes,
  }) {
    if (timeoutMinutes <= 0) {
      return false;
    }

    final elapsedMinutes = DateTime.now().difference(lastUnlock).inMinutes;
    return elapsedMinutes >= timeoutMinutes;
  }

  static Future<bool> authenticate({String reason = 'Unlock Hisaab'}) async {
    try {
      final supportsBiometrics = await _auth.canCheckBiometrics;
      final isDeviceSupported = await _auth.isDeviceSupported();

      if (!supportsBiometrics && !isDeviceSupported) {
        return false;
      }

      return _auth.authenticate(
        localizedReason: reason,
      );
    } on PlatformException {
      return false;
    }
  }
}
