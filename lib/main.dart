import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/sleepwise_app.dart';
import 'data/models/sleep_session_model.dart';
import 'data/models/settings_model.dart';
import 'services/notification_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(SleepPhaseModelAdapter());
  Hive.registerAdapter(SleepSessionModelAdapter());
  Hive.registerAdapter(SettingsModelAdapter());

  // Initialize notifications (channels, timezone)
  await NotificationService.instance.init();

  runApp(const SleepWiseApp());
}
