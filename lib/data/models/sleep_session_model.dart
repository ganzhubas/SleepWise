import 'package:hive/hive.dart';

/// Hive type IDs for adapters.
const int sleepSessionModelTypeId = 0;
const int sleepPhaseModelTypeId = 1;

/// Stored sleep phase entry.
class SleepPhaseModel {
  /// 0=awake, 1=light, 2=deep, 3=rem
  final int type;
  final DateTime startTime;
  final DateTime endTime;

  SleepPhaseModel({
    required this.type,
    required this.startTime,
    required this.endTime,
  });

  Duration get duration => endTime.difference(startTime);
}

/// Stored sleep session — Hive-persisted model.
class SleepSessionModel extends HiveObject {
  final String id;
  final DateTime date;
  final DateTime bedtime;
  final DateTime wakeTime;
  final int score;
  final int snorePercent;
  final double hoursSlept;
  final double bedtimeHour;
  final int awakenings;
  final List<SleepPhaseModel> phases;

  SleepSessionModel({
    required this.id,
    required this.date,
    required this.bedtime,
    required this.wakeTime,
    required this.score,
    required this.snorePercent,
    required this.hoursSlept,
    required this.bedtimeHour,
    required this.awakenings,
    required this.phases,
  });

  Duration get duration => wakeTime.difference(bedtime);
}

// ---------------------------------------------------------------------------
// Manual Hive adapters (avoids build_runner / code-gen)
// ---------------------------------------------------------------------------

class SleepPhaseModelAdapter extends TypeAdapter<SleepPhaseModel> {
  @override
  final int typeId = sleepPhaseModelTypeId;

  @override
  SleepPhaseModel read(BinaryReader reader) {
    return SleepPhaseModel(
      type: reader.readInt(),
      startTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      endTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
    );
  }

  @override
  void write(BinaryWriter writer, SleepPhaseModel obj) {
    writer.writeInt(obj.type);
    writer.writeInt(obj.startTime.millisecondsSinceEpoch);
    writer.writeInt(obj.endTime.millisecondsSinceEpoch);
  }
}

class SleepSessionModelAdapter extends TypeAdapter<SleepSessionModel> {
  @override
  final int typeId = sleepSessionModelTypeId;

  @override
  SleepSessionModel read(BinaryReader reader) {
    return SleepSessionModel(
      id: reader.readString(),
      date: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      bedtime: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      wakeTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      score: reader.readInt(),
      snorePercent: reader.readInt(),
      hoursSlept: reader.readDouble(),
      bedtimeHour: reader.readDouble(),
      awakenings: reader.readInt(),
      phases: reader.readList().cast<SleepPhaseModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, SleepSessionModel obj) {
    writer.writeString(obj.id);
    writer.writeInt(obj.date.millisecondsSinceEpoch);
    writer.writeInt(obj.bedtime.millisecondsSinceEpoch);
    writer.writeInt(obj.wakeTime.millisecondsSinceEpoch);
    writer.writeInt(obj.score);
    writer.writeInt(obj.snorePercent);
    writer.writeDouble(obj.hoursSlept);
    writer.writeDouble(obj.bedtimeHour);
    writer.writeInt(obj.awakenings);
    writer.writeList(obj.phases);
  }
}
