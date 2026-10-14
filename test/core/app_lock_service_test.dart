import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/core/security/app_lock_service.dart';

void main() {
  group('AppLockService', () {
    test('locks when timeout has elapsed', () {
      final lastUnlock = DateTime.now().subtract(const Duration(minutes: 6));

      final shouldLock = AppLockService.shouldLockNow(
        lastUnlock: lastUnlock,
        timeoutMinutes: 5,
      );

      expect(shouldLock, isTrue);
    });

    test('does not lock before timeout', () {
      final lastUnlock = DateTime.now().subtract(const Duration(minutes: 3));

      final shouldLock = AppLockService.shouldLockNow(
        lastUnlock: lastUnlock,
        timeoutMinutes: 5,
      );

      expect(shouldLock, isFalse);
    });
  });
}
