import 'package:flutter_test/flutter_test.dart';
import 'package:hisaab/core/backup/backup_service.dart';

void main() {
  group('BackupService', () {
    test('encrypts and decrypts a payload round-trip', () async {
      const payload = '{"version":1,"accounts":[{"id":"cash","name":"Cash"}]}';

      final encrypted = await BackupService.encryptPayload(
        payload,
        passphrase: 'super-secret-passphrase',
      );

      final restored = await BackupService.decryptPayload(
        encrypted,
        passphrase: 'super-secret-passphrase',
      );

      expect(restored, payload);
    });

    test('rejects a wrong passphrase', () async {
      const payload = '{"version":1,"accounts":[]}';

      final encrypted = await BackupService.encryptPayload(
        payload,
        passphrase: 'correct-passphrase',
      );

      expect(
        () => BackupService.decryptPayload(
          encrypted,
          passphrase: 'wrong-passphrase',
        ),
        throwsA(isA<FormatException>()),
      );
    });
  });
}
