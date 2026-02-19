import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/theme/app_colors.dart';
import '../../widgets/gradient_background.dart';
import '../../widgets/sleep_button.dart';
import 'widgets/bell_illustration.dart';
import 'widgets/microphone_illustration.dart';

/// Permission flow shown after onboarding.
/// Asks for microphone then notifications, skipping already-granted ones.
class PermissionsScreen extends StatefulWidget {
  const PermissionsScreen({super.key});

  @override
  State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
  _PermStep _step = _PermStep.loading;
  bool _micDenied = false;
  bool _notifDenied = false;

  @override
  void initState() {
    super.initState();
    _determineFirstStep();
  }

  Future<void> _determineFirstStep() async {
    final micGranted = await Permission.microphone.isGranted;
    if (!micGranted) {
      setState(() => _step = _PermStep.microphone);
      return;
    }
    final notifGranted = await Permission.notification.isGranted;
    if (!notifGranted) {
      setState(() => _step = _PermStep.notification);
      return;
    }
    _goToApp();
  }

  Future<void> _requestMicrophone() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      await _moveToNotificationOrFinish();
    } else {
      setState(() => _micDenied = true);
    }
  }

  Future<void> _moveToNotificationOrFinish() async {
    final notifGranted = await Permission.notification.isGranted;
    if (!notifGranted) {
      setState(() {
        _step = _PermStep.notification;
        _micDenied = false;
      });
    } else {
      _goToApp();
    }
  }

  Future<void> _requestNotification() async {
    final status = await Permission.notification.request();
    if (status.isGranted) {
      _goToApp();
    } else {
      setState(() => _notifDenied = true);
    }
  }

  void _skipNotification() => _goToApp();

  void _goToApp() {
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed('/alarm');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: switch (_step) {
            _PermStep.loading => const Center(
                child: CircularProgressIndicator(color: AppColors.calmBlue),
              ),
            _PermStep.microphone => MicrophonePermPage(
                denied: _micDenied,
                onAllow: _requestMicrophone,
              ),
            _PermStep.notification => NotificationPermPage(
                denied: _notifDenied,
                onAllow: _requestNotification,
                onSkip: _skipNotification,
              ),
          },
        ),
      ),
    );
  }
}

enum _PermStep { loading, microphone, notification }

// ─────────────────────────────────────────────────────────────────────────────
// Microphone permission page
// ─────────────────────────────────────────────────────────────────────────────

class MicrophonePermPage extends StatelessWidget {
  final bool denied;
  final VoidCallback onAllow;

  const MicrophonePermPage({
    super.key,
    required this.denied,
    required this.onAllow,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const MicrophoneIllustration(size: 200),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            'Доступ к микрофону',
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.moonlight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            denied
                ? 'Без микрофона анализ сна невозможен.\nВы можете разрешить доступ в настройках.'
                : 'SleepWise слушает только звуки движения\nдля анализа фаз сна. Аудио не записывается.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.moonlight.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          SleepButton(
            label: denied ? 'Открыть настройки' : 'Разрешить',
            onPressed: denied ? openAppSettings : onAllow,
            variant: SleepButtonVariant.primary,
            width: double.infinity,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          GestureDetector(
            onTap: () {
              // Placeholder — could open a privacy policy page
            },
            child: Text(
              'Подробнее о приватности',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.calmBlue.withValues(alpha: 0.7),
              ),
            ),
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Notification permission page
// ─────────────────────────────────────────────────────────────────────────────

class NotificationPermPage extends StatelessWidget {
  final bool denied;
  final VoidCallback onAllow;
  final VoidCallback onSkip;

  const NotificationPermPage({
    super.key,
    required this.denied,
    required this.onAllow,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingXL),
      child: Column(
        children: [
          const Spacer(flex: 2),
          const BellIllustration(size: 200),
          const SizedBox(height: AppDimensions.paddingXXL),
          Text(
            'Уведомления',
            style: theme.textTheme.displaySmall?.copyWith(
              color: AppColors.moonlight,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          Text(
            denied
                ? 'Будильник может не сработать без уведомлений.\nВы можете включить их в настройках.'
                : 'Чтобы будильник точно сработал,\nдаже если приложение свёрнуто',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: AppColors.moonlight.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.paddingXL),
          SleepButton(
            label: denied ? 'Открыть настройки' : 'Разрешить',
            onPressed: denied ? openAppSettings : onAllow,
            variant: SleepButtonVariant.primary,
            width: double.infinity,
          ),
          const SizedBox(height: AppDimensions.paddingM),
          SleepButton(
            label: 'Не сейчас',
            onPressed: onSkip,
            variant: SleepButtonVariant.text,
          ),
          const Spacer(flex: 3),
        ],
      ),
    );
  }
}
