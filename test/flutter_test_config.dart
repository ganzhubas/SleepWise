import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sleepwise/data/models/sleep_session_model.dart';
import 'package:sleepwise/data/models/settings_model.dart';

/// Automatically called by the Flutter test framework before every test file.
/// Loads bundled project fonts so golden screenshots render real glyphs
/// instead of the default Ahem squares.
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await _loadFonts();
  await _initHive();
  await testMain();
}

Future<void> _initHive() async {
  final tempDir = Directory.systemTemp.createTempSync('sleepwise_test_');
  Hive.init(tempDir.path);
  if (!Hive.isAdapterRegistered(sleepPhaseModelTypeId)) {
    Hive.registerAdapter(SleepPhaseModelAdapter());
  }
  if (!Hive.isAdapterRegistered(sleepSessionModelTypeId)) {
    Hive.registerAdapter(SleepSessionModelAdapter());
  }
  if (!Hive.isAdapterRegistered(settingsModelTypeId)) {
    Hive.registerAdapter(SettingsModelAdapter());
  }
}

Future<void> _loadFonts() async {
  const fontManifest = <_FontDef>[
    _FontDef('Montserrat', [
      'assets/fonts/Montserrat/Montserrat-Light.ttf',
      'assets/fonts/Montserrat/Montserrat-Regular.ttf',
      'assets/fonts/Montserrat/Montserrat-Medium.ttf',
      'assets/fonts/Montserrat/Montserrat-SemiBold.ttf',
      'assets/fonts/Montserrat/Montserrat-Bold.ttf',
    ]),
    _FontDef('Inter', [
      'assets/fonts/Inter/Inter-Light.ttf',
      'assets/fonts/Inter/Inter-Regular.ttf',
      'assets/fonts/Inter/Inter-Medium.ttf',
    ]),
    _FontDef('JetBrainsMono', [
      'assets/fonts/JetBrainsMono/JetBrainsMono-Light.ttf',
      'assets/fonts/JetBrainsMono/JetBrainsMono-Regular.ttf',
      'assets/fonts/JetBrainsMono/JetBrainsMono-Medium.ttf',
    ]),
  ];

  for (final def in fontManifest) {
    final loader = FontLoader(def.family);
    for (final asset in def.assets) {
      final bytes = File(asset).readAsBytesSync();
      loader.addFont(Future.value(ByteData.sublistView(Uint8List.fromList(bytes))));
    }
    await loader.load();
  }
}

class _FontDef {
  final String family;
  final List<String> assets;
  const _FontDef(this.family, this.assets);
}
