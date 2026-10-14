import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hisaab/core/backup/backup_service.dart';
import 'package:hisaab/core/security/device_security.dart';
import 'package:hisaab/features/ai_assistant/ai_assistant_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _biometricLock = true;
  int _autoLockMinutes = 5;
  bool _privacyMode = true;
  bool _encryptedBackup = true;
  bool _aiEnabled = false;

  Future<void> _exportBackup() async {
    final passphraseController = TextEditingController();
    if (!mounted) {
      return;
    }
    final result = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Export encrypted backup'),
          content: TextField(
            controller: passphraseController,
            obscureText: true,
            decoration: const InputDecoration(
              labelText: 'Passphrase',
              hintText: 'Enter a backup passphrase',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final passphrase = passphraseController.text.trim();
                if (passphrase.isEmpty) {
                  return;
                }
                Navigator.of(context).pop(passphrase);
              },
              child: const Text('Export'),
            ),
          ],
        );
      },
    );

    if (result == null || result.isEmpty) {
      return;
    }

    final payload = '{"version":1,"exportedAt":"${DateTime.now().toUtc().toIso8601String()}"}';
    final encrypted = await BackupService.encryptPayload(
      payload,
      passphrase: result,
    );

    await Clipboard.setData(ClipboardData(text: encrypted));
    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup exported'),
        content: SelectableText(encrypted),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  Future<void> _restoreBackup() async {
    final passphraseController = TextEditingController();
    final archiveController = TextEditingController();
    if (!mounted) {
      return;
    }
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore backup'),
          content: SizedBox(
            width: 500,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: passphraseController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Passphrase',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: archiveController,
                  minLines: 4,
                  maxLines: 8,
                  decoration: const InputDecoration(
                    labelText: 'Encrypted archive',
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                final passphrase = passphraseController.text.trim();
                final archive = archiveController.text.trim();
                if (passphrase.isEmpty || archive.isEmpty) {
                  return;
                }
                Navigator.of(context).pop({
                  'passphrase': passphrase,
                  'archive': archive,
                });
              },
              child: const Text('Restore'),
            ),
          ],
        );
      },
    );

    if (result == null) {
      return;
    }

    try {
      final payload = await BackupService.decryptPayload(
        result['archive']!,
        passphrase: result['passphrase']!,
      );

      if (!context.mounted) {
        return;
      }

      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Backup restored'),
          content: SelectableText(payload),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Done'),
            ),
          ],
        ),
      );
    } on FormatException catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error.message)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(
            'Security',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: _biometricLock,
                  onChanged: (value) {
                    setState(() {
                      _biometricLock = value;
                    });
                  },
                  title: const Text('Biometric lock'),
                  subtitle: const Text(
                    'Require Face ID or fingerprint on launch',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  title: const Text('Auto-lock timeout'),
                  subtitle: Text('$_autoLockMinutes minutes'),
                  trailing: PopupMenuButton<int>(
                    icon: const Icon(Icons.timelapse),
                    onSelected: (value) {
                      setState(() {
                        _autoLockMinutes = value;
                      });
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 1, child: Text('1 minute')),
                      PopupMenuItem(value: 5, child: Text('5 minutes')),
                      PopupMenuItem(value: 15, child: Text('15 minutes')),
                      PopupMenuItem(value: 30, child: Text('30 minutes')),
                    ],
                  ),
                ),
                const Divider(height: 1),
                SwitchListTile.adaptive(
                  value: _privacyMode,
                  onChanged: (value) async {
                    setState(() {
                      _privacyMode = value;
                    });
                    await DeviceSecurity.setSecureMode(enabled: value);
                  },
                  title: const Text('Privacy mode'),
                  subtitle: const Text(
                    'Blur app preview and hide sensitive content',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Backup & restore',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: _encryptedBackup,
                  onChanged: (value) {
                    setState(() {
                      _encryptedBackup = value;
                    });
                  },
                  title: const Text('Encrypted backup'),
                  subtitle: const Text(
                    'Protect exports with a passphrase-derived key',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.upload_file),
                  title: const Text('Export backup'),
                  subtitle: const Text('Create a password-protected archive'),
                  onTap: _exportBackup,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Restore backup'),
                  subtitle: const Text('Import an encrypted archive'),
                  onTap: _restoreBackup,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'AI privacy',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          Card(
            child: Column(
              children: [
                SwitchListTile.adaptive(
                  value: _aiEnabled,
                  onChanged: (value) {
                    setState(() {
                      _aiEnabled = value;
                    });
                  },
                  title: const Text('AI assistant'),
                  subtitle: const Text(
                    'Off by default. Only sends aggregated spending data.',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.auto_awesome),
                  title: const Text('Open quick-add assistant'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (context) => const AiAssistantScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
