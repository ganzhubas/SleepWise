import 'package:hive/hive.dart';

import '../../models/sleep_phase.dart';
import '../../models/sleep_session.dart';
import '../models/sleep_session_model.dart';

/// Repository for persisting and retrieving sleep sessions from Hive.
class SleepRepository {
  static const String _boxName = 'sleep_sessions';

  Box<SleepSessionModel>? _box;

  Future<Box<SleepSessionModel>> get _sessionBox async {
    _box ??= await Hive.openBox<SleepSessionModel>(_boxName);
    return _box!;
  }

  /// Save a sleep session to the database.
  Future<void> saveSleepSession(SleepSession session) async {
    final box = await _sessionBox;

    final id = session.bedtime.millisecondsSinceEpoch.toString();

    // Convert phases
    final phaseModels = session.phases
        .map((p) => SleepPhaseModel(
              type: p.type.index,
              startTime: p.startTime,
              endTime: p.endTime,
            ))
        .toList();

    // Count awakenings (transitions to awake phase)
    var awakenings = 0;
    for (var i = 1; i < session.phases.length; i++) {
      if (session.phases[i].type == SleepPhaseType.awake &&
          session.phases[i - 1].type != SleepPhaseType.awake) {
        awakenings++;
      }
    }

    // Calculate bedtime hour as decimal (e.g., 23.25 = 23:15)
    final bedtimeHour = session.bedtime.hour +
        session.bedtime.minute / 60.0;

    final model = SleepSessionModel(
      id: id,
      date: DateTime(
        session.bedtime.year,
        session.bedtime.month,
        session.bedtime.day,
      ),
      bedtime: session.bedtime,
      wakeTime: session.wakeTime,
      score: session.score,
      snorePercent: session.snorePercentage,
      hoursSlept: session.hoursSlept,
      bedtimeHour: bedtimeHour,
      awakenings: awakenings,
      phases: phaseModels,
    );

    await box.put(id, model);
  }

  /// Get all sessions within a date range (inclusive).
  Future<List<SleepSessionModel>> getSessions({
    required DateTime from,
    required DateTime to,
  }) async {
    final box = await _sessionBox;
    final fromDate = DateTime(from.year, from.month, from.day);
    final toDate = DateTime(to.year, to.month, to.day, 23, 59, 59);

    return box.values
        .where((s) =>
            !s.date.isBefore(fromDate) && !s.date.isAfter(toDate))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  /// Get the last N sessions, ordered by date descending.
  Future<List<SleepSessionModel>> getLastSessions(int count) async {
    final box = await _sessionBox;
    final all = box.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    return all.take(count).toList();
  }

  /// Get the most recent session.
  Future<SleepSessionModel?> getLastSession() async {
    final sessions = await getLastSessions(1);
    return sessions.isEmpty ? null : sessions.first;
  }

  /// Delete a session by ID.
  Future<void> deleteSession(String id) async {
    final box = await _sessionBox;
    await box.delete(id);
  }

  /// Get total session count.
  Future<int> getSessionCount() async {
    final box = await _sessionBox;
    return box.length;
  }
}
