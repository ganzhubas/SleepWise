import 'package:hive/hive.dart';

const int settingsModelTypeId = 2;

/// Persisted app settings.
class SettingsModel {
  final int alarmHour;
  final int alarmMinute;
  final int windowMinutes;
  final bool snoozeEnabled;
  final int snoozeDurationMinutes;
  final String melodyId;
  final double alarmVolume;
  final String micSensitivity; // low, medium, high
  final bool bedtimeReminder;
  final int reminderHour;
  final int reminderMinute;
  final bool healthConnect;
  final bool samsungHealth;
  final String theme; // dark, light, system
  final String language; // ru, en

  SettingsModel({
    this.alarmHour = 7,
    this.alarmMinute = 30,
    this.windowMinutes = 30,
    this.snoozeEnabled = true,
    this.snoozeDurationMinutes = 5,
    this.melodyId = 'sunrise_glow',
    this.alarmVolume = 0.7,
    this.micSensitivity = 'medium',
    this.bedtimeReminder = false,
    this.reminderHour = 23,
    this.reminderMinute = 0,
    this.healthConnect = false,
    this.samsungHealth = false,
    this.theme = 'dark',
    this.language = 'ru',
  });

  SettingsModel copyWith({
    int? alarmHour,
    int? alarmMinute,
    int? windowMinutes,
    bool? snoozeEnabled,
    int? snoozeDurationMinutes,
    String? melodyId,
    double? alarmVolume,
    String? micSensitivity,
    bool? bedtimeReminder,
    int? reminderHour,
    int? reminderMinute,
    bool? healthConnect,
    bool? samsungHealth,
    String? theme,
    String? language,
  }) {
    return SettingsModel(
      alarmHour: alarmHour ?? this.alarmHour,
      alarmMinute: alarmMinute ?? this.alarmMinute,
      windowMinutes: windowMinutes ?? this.windowMinutes,
      snoozeEnabled: snoozeEnabled ?? this.snoozeEnabled,
      snoozeDurationMinutes: snoozeDurationMinutes ?? this.snoozeDurationMinutes,
      melodyId: melodyId ?? this.melodyId,
      alarmVolume: alarmVolume ?? this.alarmVolume,
      micSensitivity: micSensitivity ?? this.micSensitivity,
      bedtimeReminder: bedtimeReminder ?? this.bedtimeReminder,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      healthConnect: healthConnect ?? this.healthConnect,
      samsungHealth: samsungHealth ?? this.samsungHealth,
      theme: theme ?? this.theme,
      language: language ?? this.language,
    );
  }
}

// ---------------------------------------------------------------------------
// Manual Hive adapter
// ---------------------------------------------------------------------------

class SettingsModelAdapter extends TypeAdapter<SettingsModel> {
  @override
  final int typeId = settingsModelTypeId;

  @override
  SettingsModel read(BinaryReader reader) {
    return SettingsModel(
      alarmHour: reader.readInt(),
      alarmMinute: reader.readInt(),
      windowMinutes: reader.readInt(),
      snoozeEnabled: reader.readBool(),
      snoozeDurationMinutes: reader.readInt(),
      melodyId: reader.readString(),
      alarmVolume: reader.readDouble(),
      micSensitivity: reader.readString(),
      bedtimeReminder: reader.readBool(),
      reminderHour: reader.readInt(),
      reminderMinute: reader.readInt(),
      healthConnect: reader.readBool(),
      samsungHealth: reader.readBool(),
      theme: reader.readString(),
      language: reader.readString(),
    );
  }

  @override
  void write(BinaryWriter writer, SettingsModel obj) {
    writer.writeInt(obj.alarmHour);
    writer.writeInt(obj.alarmMinute);
    writer.writeInt(obj.windowMinutes);
    writer.writeBool(obj.snoozeEnabled);
    writer.writeInt(obj.snoozeDurationMinutes);
    writer.writeString(obj.melodyId);
    writer.writeDouble(obj.alarmVolume);
    writer.writeString(obj.micSensitivity);
    writer.writeBool(obj.bedtimeReminder);
    writer.writeInt(obj.reminderHour);
    writer.writeInt(obj.reminderMinute);
    writer.writeBool(obj.healthConnect);
    writer.writeBool(obj.samsungHealth);
    writer.writeString(obj.theme);
    writer.writeString(obj.language);
  }
}
