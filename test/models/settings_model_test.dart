import 'package:flutter_test/flutter_test.dart';
import 'package:sleepwise/data/models/settings_model.dart';

void main() {
  group('SettingsModel', () {
    test('default values', () {
      final model = SettingsModel();
      expect(model.alarmHour, 7);
      expect(model.alarmMinute, 30);
      expect(model.windowMinutes, 30);
      expect(model.snoozeEnabled, true);
      expect(model.snoozeDurationMinutes, 5);
      expect(model.melodyId, 'sunrise_glow');
      expect(model.alarmVolume, 0.7);
      expect(model.micSensitivity, 'medium');
      expect(model.bedtimeReminder, false);
      expect(model.reminderHour, 23);
      expect(model.reminderMinute, 0);
      expect(model.healthConnect, false);
      expect(model.samsungHealth, false);
      expect(model.theme, 'dark');
      expect(model.language, 'ru');
    });

    test('custom values', () {
      final model = SettingsModel(
        alarmHour: 6,
        alarmMinute: 0,
        windowMinutes: 15,
        snoozeEnabled: false,
        snoozeDurationMinutes: 10,
        melodyId: 'forest_morning',
        alarmVolume: 1.0,
        micSensitivity: 'high',
        bedtimeReminder: true,
        reminderHour: 22,
        reminderMinute: 30,
        healthConnect: true,
        samsungHealth: true,
        theme: 'light',
        language: 'en',
      );
      expect(model.alarmHour, 6);
      expect(model.alarmMinute, 0);
      expect(model.windowMinutes, 15);
      expect(model.snoozeEnabled, false);
      expect(model.snoozeDurationMinutes, 10);
      expect(model.melodyId, 'forest_morning');
      expect(model.alarmVolume, 1.0);
      expect(model.micSensitivity, 'high');
      expect(model.bedtimeReminder, true);
      expect(model.reminderHour, 22);
      expect(model.reminderMinute, 30);
      expect(model.healthConnect, true);
      expect(model.samsungHealth, true);
      expect(model.theme, 'light');
      expect(model.language, 'en');
    });

    group('copyWith', () {
      test('copies with single field change', () {
        final original = SettingsModel();
        final updated = original.copyWith(alarmHour: 8);
        expect(updated.alarmHour, 8);
        expect(updated.alarmMinute, original.alarmMinute);
        expect(updated.windowMinutes, original.windowMinutes);
        expect(updated.melodyId, original.melodyId);
      });

      test('copies with multiple field changes', () {
        final original = SettingsModel();
        final updated = original.copyWith(
          alarmHour: 6,
          alarmMinute: 45,
          windowMinutes: 20,
        );
        expect(updated.alarmHour, 6);
        expect(updated.alarmMinute, 45);
        expect(updated.windowMinutes, 20);
        expect(updated.snoozeEnabled, original.snoozeEnabled);
      });

      test('preserves all fields when no changes', () {
        final original = SettingsModel(
          alarmHour: 5,
          alarmMinute: 15,
          windowMinutes: 10,
          snoozeEnabled: false,
          snoozeDurationMinutes: 10,
          melodyId: 'zen_garden',
          alarmVolume: 0.5,
          micSensitivity: 'low',
          bedtimeReminder: true,
          reminderHour: 22,
          reminderMinute: 45,
          healthConnect: true,
          samsungHealth: true,
          theme: 'light',
          language: 'en',
        );
        final copy = original.copyWith();
        expect(copy.alarmHour, original.alarmHour);
        expect(copy.alarmMinute, original.alarmMinute);
        expect(copy.windowMinutes, original.windowMinutes);
        expect(copy.snoozeEnabled, original.snoozeEnabled);
        expect(copy.snoozeDurationMinutes, original.snoozeDurationMinutes);
        expect(copy.melodyId, original.melodyId);
        expect(copy.alarmVolume, original.alarmVolume);
        expect(copy.micSensitivity, original.micSensitivity);
        expect(copy.bedtimeReminder, original.bedtimeReminder);
        expect(copy.reminderHour, original.reminderHour);
        expect(copy.reminderMinute, original.reminderMinute);
        expect(copy.healthConnect, original.healthConnect);
        expect(copy.samsungHealth, original.samsungHealth);
        expect(copy.theme, original.theme);
        expect(copy.language, original.language);
      });

      test('each field can be independently updated', () {
        final base = SettingsModel();

        expect(base.copyWith(alarmHour: 1).alarmHour, 1);
        expect(base.copyWith(alarmMinute: 1).alarmMinute, 1);
        expect(base.copyWith(windowMinutes: 1).windowMinutes, 1);
        expect(base.copyWith(snoozeEnabled: false).snoozeEnabled, false);
        expect(base.copyWith(snoozeDurationMinutes: 1).snoozeDurationMinutes, 1);
        expect(base.copyWith(melodyId: 'test').melodyId, 'test');
        expect(base.copyWith(alarmVolume: 0.1).alarmVolume, 0.1);
        expect(base.copyWith(micSensitivity: 'low').micSensitivity, 'low');
        expect(base.copyWith(bedtimeReminder: true).bedtimeReminder, true);
        expect(base.copyWith(reminderHour: 1).reminderHour, 1);
        expect(base.copyWith(reminderMinute: 1).reminderMinute, 1);
        expect(base.copyWith(healthConnect: true).healthConnect, true);
        expect(base.copyWith(samsungHealth: true).samsungHealth, true);
        expect(base.copyWith(theme: 'light').theme, 'light');
        expect(base.copyWith(language: 'en').language, 'en');
      });
    });
  });

  group('SettingsModelAdapter', () {
    test('has correct typeId', () {
      final adapter = SettingsModelAdapter();
      expect(adapter.typeId, settingsModelTypeId);
      expect(adapter.typeId, 2);
    });
  });
}
