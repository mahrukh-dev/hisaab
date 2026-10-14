import 'package:flutter/material.dart';
import 'package:hisaab/core/security/app_lock_service.dart';

class AppLockGate extends StatefulWidget {
  const AppLockGate({
    required this.child,
    this.enabled = true,
    this.autoLockMinutes = 5,
    super.key,
  });

  final Widget child;
  final bool enabled;
  final int autoLockMinutes;

  @override
  State<AppLockGate> createState() => _AppLockGateState();
}

class _AppLockGateState extends State<AppLockGate> with WidgetsBindingObserver {
  bool _isLocked = false;
  DateTime _lastUnlockAt = DateTime.now();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _isLocked = false;
    if (widget.enabled) {
      _requestUnlock();
    }
  }

  @override
  void didUpdateWidget(covariant AppLockGate oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.enabled != widget.enabled) {
      if (widget.enabled) {
        setState(() {
          _isLocked = true;
        });
        _requestUnlock();
      } else {
        setState(() {
          _isLocked = false;
          _lastUnlockAt = DateTime.now();
        });
      }
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      _lastUnlockAt = DateTime.now();
      return;
    }

    if (state == AppLifecycleState.resumed && widget.enabled) {
      final shouldLock = AppLockService.shouldLockNow(
        lastUnlock: _lastUnlockAt,
        timeoutMinutes: widget.autoLockMinutes,
      );

      if (shouldLock) {
        setState(() {
          _isLocked = true;
        });
        _requestUnlock();
      }
    }
  }

  Future<void> _requestUnlock() async {
    final available = await AppLockService.isAvailable();
    if (!available) {
      if (!mounted) {
        return;
      }
      setState(() {
        _lastUnlockAt = DateTime.now();
        _isLocked = false;
      });
      return;
    }

    final unlocked = await AppLockService.authenticate();
    if (!mounted) {
      return;
    }

    if (unlocked) {
      setState(() {
        _lastUnlockAt = DateTime.now();
        _isLocked = false;
      });
      return;
    }

    setState(() {
      _isLocked = true;
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLocked) {
      return widget.child;
    }

    return _LockScreen(
      onUnlock: () async {
        final unlocked = await AppLockService.authenticate();
        if (!mounted) {
          return;
        }

        if (unlocked) {
          setState(() {
            _isLocked = false;
            _lastUnlockAt = DateTime.now();
          });
        }
      },
    );
  }
}

class _LockScreen extends StatelessWidget {
  const _LockScreen({required this.onUnlock});

  final Future<void> Function() onUnlock;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 72),
              const SizedBox(height: 20),
              Text(
                'App locked',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text('Authenticate to continue.'),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: () async {
                  await onUnlock();
                },
                icon: const Icon(Icons.fingerprint),
                label: const Text('Unlock'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
