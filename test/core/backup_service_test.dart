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

    test('includes a checksum in the archive header', () async {
      const payload = '{"version":1,"accounts":[]}';

      final encrypted = await BackupService.encryptPayload(
        payload,
        passphrase: 'correct-passphrase',
      );

      final parts = encrypted.split(':');
      expect(parts, hasLength(3));
      expect(parts.first, 'hisaab-backup-v1');
      expect(parts[1], isNotEmpty);
      expect(parts[2], isNotEmpty);
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
