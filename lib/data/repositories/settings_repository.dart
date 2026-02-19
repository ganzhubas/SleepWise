import 'package:hive/hive.dart';

import '../models/settings_model.dart';

/// Repository for persisting and retrieving app settings from Hive.
class SettingsRepository {
  static const String _boxName = 'settings';
  static const String _key = 'app_settings';

  Box<SettingsModel>? _box;

  Future<Box<SettingsModel>> get _settingsBox async {
    _box ??= await Hive.openBox<SettingsModel>(_boxName);
    return _box!;
  }

  /// Get current settings, or defaults if none saved.
  Future<SettingsModel> getSettings() async {
    final box = await _settingsBox;
    return box.get(_key) ?? SettingsModel();
  }

  /// Save settings.
  Future<void> saveSettings(SettingsModel settings) async {
    final box = await _settingsBox;
    await box.put(_key, settings);
  }

  /// Update a single field — reads current, applies change, saves.
  Future<SettingsModel> updateSettings(
    SettingsModel Function(SettingsModel current) updater,
  ) async {
    final current = await getSettings();
    final updated = updater(current);
    await saveSettings(updated);
    return updated;
  }
}
