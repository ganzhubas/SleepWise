import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:sleepwise/data/models/settings_model.dart';
import 'package:sleepwise/data/models/sleep_session_model.dart';
import 'package:sleepwise/data/repositories/settings_repository.dart';
import 'package:sleepwise/data/repositories/sleep_repository.dart';
import 'package:sleepwise/models/sleep_phase.dart';
import 'package:sleepwise/models/sleep_session.dart';

void main() {
  group('SleepRepository', () {
    late SleepRepository repo;

    setUp(() async {
      // Clear and re-open with a fresh box for each test
      if (Hive.isBoxOpen('sleep_sessions')) {
        await Hive.box<SleepSessionModel>('sleep_sessions').clear();
      }
      repo = SleepRepository();
    });

    test('saves and retrieves a session', () async {
      final session = SleepSession(
        bedtime: DateTime(2026, 2, 10, 23, 0),
        wakeTime: DateTime(2026, 2, 11, 7, 0),
        score: 82,
        snorePercentage: 8,
        phases: [
          SleepPhase(
            type: SleepPhaseType.light,
            startTime: DateTime(2026, 2, 10, 23, 0),
            endTime: DateTime(2026, 2, 11, 1, 0),
          ),
          SleepPhase(
            type: SleepPhaseType.deep,
            startTime: DateTime(2026, 2, 11, 1, 0),
            endTime: DateTime(2026, 2, 11, 3, 0),
          ),
          SleepPhase(
            type: SleepPhaseType.rem,
            startTime: DateTime(2026, 2, 11, 3, 0),
            endTime: DateTime(2026, 2, 11, 5, 0),
          ),
          SleepPhase(
            type: SleepPhaseType.light,
            startTime: DateTime(2026, 2, 11, 5, 0),
            endTime: DateTime(2026, 2, 11, 7, 0),
          ),
        ],
      );

      await repo.saveSleepSession(session);

      final sessions = await repo.getSessions(
        from: DateTime(2026, 2, 10),
        to: DateTime(2026, 2, 11),
      );

      expect(sessions, isNotEmpty);
      expect(sessions.first.score, 82);
      expect(sessions.first.snorePercent, 8);
      expect(sessions.first.phases.length, 4);
    });

    test('getLastSession returns most recent', () async {
      final session1 = SleepSession(
        bedtime: DateTime(2026, 2, 8, 23, 0),
        wakeTime: DateTime(2026, 2, 9, 7, 0),
        score: 70,
      );
      final session2 = SleepSession(
        bedtime: DateTime(2026, 2, 9, 23, 0),
        wakeTime: DateTime(2026, 2, 10, 7, 0),
        score: 85,
      );

      await repo.saveSleepSession(session1);
      await repo.saveSleepSession(session2);

      final last = await repo.getLastSession();
      expect(last, isNotNull);
      expect(last!.score, 85);
    });

    test('getLastSessions returns correct count', () async {
      for (var i = 0; i < 5; i++) {
        await repo.saveSleepSession(SleepSession(
          bedtime: DateTime(2026, 5, i + 1, 23, 0),
          wakeTime: DateTime(2026, 5, i + 2, 7, 0),
          score: 60 + i * 5,
        ));
      }

      final last3 = await repo.getLastSessions(3);
      expect(last3.length, 3);
    });

    test('deleteSession removes session', () async {
      final session = SleepSession(
        bedtime: DateTime(2026, 3, 1, 23, 0),
        wakeTime: DateTime(2026, 3, 2, 7, 0),
        score: 75,
      );

      await repo.saveSleepSession(session);
      final id = session.bedtime.millisecondsSinceEpoch.toString();

      await repo.deleteSession(id);
      final sessions = await repo.getSessions(
        from: DateTime(2026, 3, 1),
        to: DateTime(2026, 3, 2),
      );
      expect(sessions.where((s) => s.id == id), isEmpty);
    });

    test('getSessionCount returns correct count', () async {
      final countBefore = await repo.getSessionCount();
      expect(countBefore, 0);

      await repo.saveSleepSession(SleepSession(
        bedtime: DateTime(2026, 4, 1, 23, 0),
        wakeTime: DateTime(2026, 4, 2, 7, 0),
      ));
      final countAfter = await repo.getSessionCount();
      expect(countAfter, 1);
    });

    test('counts awakenings correctly', () async {
      final session = SleepSession(
        bedtime: DateTime(2026, 6, 15, 23, 0),
        wakeTime: DateTime(2026, 6, 16, 7, 0),
        phases: [
          SleepPhase(
            type: SleepPhaseType.light,
            startTime: DateTime(2026, 6, 15, 23, 0),
            endTime: DateTime(2026, 6, 16, 1, 0),
          ),
          SleepPhase(
            type: SleepPhaseType.awake,
            startTime: DateTime(2026, 6, 16, 1, 0),
            endTime: DateTime(2026, 6, 16, 1, 15),
          ),
          SleepPhase(
            type: SleepPhaseType.deep,
            startTime: DateTime(2026, 6, 16, 1, 15),
            endTime: DateTime(2026, 6, 16, 4, 0),
          ),
          SleepPhase(
            type: SleepPhaseType.awake,
            startTime: DateTime(2026, 6, 16, 4, 0),
            endTime: DateTime(2026, 6, 16, 4, 10),
          ),
          SleepPhase(
            type: SleepPhaseType.light,
            startTime: DateTime(2026, 6, 16, 4, 10),
            endTime: DateTime(2026, 6, 16, 7, 0),
          ),
        ],
      );

      await repo.saveSleepSession(session);
      final last = await repo.getLastSession();
      expect(last!.awakenings, 2);
    });

    test('getLastSession returns null when empty', () async {
      final last = await repo.getLastSession();
      expect(last, isNull);
    });

    test('getSessions returns empty for out-of-range dates', () async {
      await repo.saveSleepSession(SleepSession(
        bedtime: DateTime(2026, 1, 1, 23, 0),
        wakeTime: DateTime(2026, 1, 2, 7, 0),
      ));

      final sessions = await repo.getSessions(
        from: DateTime(2026, 6, 1),
        to: DateTime(2026, 6, 30),
      );
      expect(sessions, isEmpty);
    });
  });

  group('SettingsRepository', () {
    late SettingsRepository repo;

    setUp(() async {
      if (Hive.isBoxOpen('settings')) {
        await Hive.box<SettingsModel>('settings').clear();
      }
      repo = SettingsRepository();
    });

    test('returns default settings when none saved', () async {
      final settings = await repo.getSettings();
      expect(settings.alarmHour, 7);
      expect(settings.alarmMinute, 30);
      expect(settings.language, 'ru');
    });

    test('saves and retrieves settings', () async {
      final custom = SettingsModel(
        alarmHour: 6,
        alarmMinute: 0,
        windowMinutes: 20,
        language: 'en',
      );
      await repo.saveSettings(custom);

      final retrieved = await repo.getSettings();
      expect(retrieved.alarmHour, 6);
      expect(retrieved.alarmMinute, 0);
      expect(retrieved.windowMinutes, 20);
      expect(retrieved.language, 'en');
    });

    test('updateSettings applies functional update', () async {
      await repo.saveSettings(SettingsModel());

      final updated = await repo.updateSettings(
        (current) => current.copyWith(alarmHour: 5, melodyId: 'zen_garden'),
      );

      expect(updated.alarmHour, 5);
      expect(updated.melodyId, 'zen_garden');
      expect(updated.alarmMinute, 30);

      final persisted = await repo.getSettings();
      expect(persisted.alarmHour, 5);
      expect(persisted.melodyId, 'zen_garden');
    });
  });
}
