import 'dart:io';

import 'package:health/health.dart';

import '../models/sleep_phase.dart';
import '../models/sleep_session.dart';

/// Result of a health platform connection attempt.
enum HealthConnectionStatus {
  connected,
  denied,
  unavailable,
}

/// Unified service for Apple Health (iOS) and Google Health Connect (Android).
///
/// Handles permission requests, writing sleep sessions, and reading
/// supplementary data (heart rate, steps) for future algorithm improvements.
class HealthService {
  HealthService._();
  static final instance = HealthService._();

  final _health = Health();
  bool _configured = false;

  // ── Types we need ──────────────────────────────────────────────────────

  /// Types we request write access to.
  static const _writeTypes = [
    HealthDataType.SLEEP_SESSION,
    HealthDataType.SLEEP_ASLEEP,
    HealthDataType.SLEEP_AWAKE,
    HealthDataType.SLEEP_DEEP,
    HealthDataType.SLEEP_REM,
    HealthDataType.SLEEP_LIGHT,
    HealthDataType.SLEEP_IN_BED,
  ];

  /// Types we request read access to (for future use).
  static const _readTypes = [
    HealthDataType.HEART_RATE,
    HealthDataType.STEPS,
    HealthDataType.SLEEP_SESSION,
  ];

  /// All types combined for permission request.
  List<HealthDataType> get _allTypes => [..._writeTypes, ..._readTypes];

  // ── Configuration ─────────────────────────────────────────────────────

  void _ensureConfigured() {
    if (_configured) return;
    _health.configure();
    _configured = true;
  }

  // ── Permissions ───────────────────────────────────────────────────────

  /// Request health permissions. Returns connection status.
  Future<HealthConnectionStatus> requestPermissions() async {
    try {
      _ensureConfigured();

      // On Android, check if Health Connect is installed
      if (Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) {
          return HealthConnectionStatus.unavailable;
        }
      }

      final permissions = _allTypes.map((t) {
        if (_writeTypes.contains(t)) return HealthDataAccess.READ_WRITE;
        return HealthDataAccess.READ;
      }).toList();

      final granted = await _health.requestAuthorization(
        _allTypes,
        permissions: permissions,
      );

      return granted
          ? HealthConnectionStatus.connected
          : HealthConnectionStatus.denied;
    } catch (_) {
      return HealthConnectionStatus.unavailable;
    }
  }

  /// Check if we currently have permissions (without requesting).
  Future<bool> hasPermissions() async {
    try {
      _ensureConfigured();

      if (Platform.isAndroid) {
        final status = await _health.getHealthConnectSdkStatus();
        if (status != HealthConnectSdkStatus.sdkAvailable) return false;
      }

      final perms = await _health.hasPermissions(
        _writeTypes,
        permissions: _writeTypes
            .map((_) => HealthDataAccess.READ_WRITE)
            .toList(),
      );
      return perms ?? false;
    } catch (_) {
      return false;
    }
  }

  // ── Write sleep session ───────────────────────────────────────────────

  /// Write a complete sleep session to Apple Health / Health Connect.
  ///
  /// Writes:
  /// - Overall SLEEP_IN_BED from bedtime to wakeTime
  /// - Overall SLEEP_SESSION from bedtime to wakeTime
  /// - Individual phase entries (SLEEP_DEEP, SLEEP_LIGHT, SLEEP_REM, SLEEP_AWAKE, SLEEP_ASLEEP)
  Future<bool> writeSleepSession(SleepSession session) async {
    try {
      _ensureConfigured();

      // 1. Write overall in-bed period
      var success = await _health.writeHealthData(
        value: 0,
        type: HealthDataType.SLEEP_IN_BED,
        startTime: session.bedtime,
        endTime: session.wakeTime,
      );
      if (!success) return false;

      // 2. Write sleep session
      success = await _health.writeHealthData(
        value: 0,
        type: HealthDataType.SLEEP_SESSION,
        startTime: session.bedtime,
        endTime: session.wakeTime,
      );
      if (!success) return false;

      // 3. Write individual phases
      for (final phase in session.phases) {
        if (phase.duration.inMinutes < 1) continue;

        final healthType = _phaseToHealthType(phase.type);
        if (healthType == null) continue;

        await _health.writeHealthData(
          value: 0,
          type: healthType,
          startTime: phase.startTime,
          endTime: phase.endTime,
        );
      }

      return true;
    } catch (_) {
      return false;
    }
  }

  static HealthDataType? _phaseToHealthType(SleepPhaseType type) {
    return switch (type) {
      SleepPhaseType.deep => HealthDataType.SLEEP_DEEP,
      SleepPhaseType.light => HealthDataType.SLEEP_LIGHT,
      SleepPhaseType.rem => HealthDataType.SLEEP_REM,
      SleepPhaseType.awake => HealthDataType.SLEEP_AWAKE,
    };
  }

  // ── Read supplementary data (for future use) ─────────────────────────

  /// Read heart rate data for a time range (from Apple Watch / wearable).
  Future<List<HealthDataPoint>> readHeartRate({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      _ensureConfigured();
      return await _health.getHealthDataFromTypes(
        types: [HealthDataType.HEART_RATE],
        startTime: from,
        endTime: to,
      );
    } catch (_) {
      return [];
    }
  }

  /// Read step count for a time range (for activity–sleep correlation).
  Future<int> readSteps({
    required DateTime from,
    required DateTime to,
  }) async {
    try {
      _ensureConfigured();
      final steps = await _health.getTotalStepsInInterval(from, to);
      return steps ?? 0;
    } catch (_) {
      return 0;
    }
  }

  // ── Platform info ─────────────────────────────────────────────────────

  /// Returns the platform-specific health service name.
  String get platformName {
    if (Platform.isIOS) return 'Apple Health';
    if (Platform.isAndroid) return 'Health Connect';
    return 'Health';
  }

  /// Check if Health Connect is available (Android only).
  Future<bool> isHealthConnectAvailable() async {
    if (!Platform.isAndroid) return true; // iOS always has HealthKit
    try {
      _ensureConfigured();
      final status = await _health.getHealthConnectSdkStatus();
      return status == HealthConnectSdkStatus.sdkAvailable;
    } catch (_) {
      return false;
    }
  }
}
