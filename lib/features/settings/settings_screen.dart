import 'package:flutter/material.dart';

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
                  onChanged: (value) {
                    setState(() {
                      _privacyMode = value;
                    });
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
                  onTap: () {},
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.download),
                  title: const Text('Restore backup'),
                  subtitle: const Text('Import an encrypted archive'),
                  onTap: () {},
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
            child: ListTile(
              leading: const Icon(Icons.smart_toy_outlined),
              title: const Text('AI assistant'),
              subtitle: const Text(
                'Off by default. Only sends aggregated spending data.',
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
