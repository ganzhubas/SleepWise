/// SleepWise Screenshot Generator
///
/// Generates 5 store screenshots at iPhone 15 Pro Max resolution (1290x2796).
/// Each screenshot renders a framed device mockup with a caption overlay.
///
/// Usage:
///   flutter test metadata/screenshots/generate_screenshots.dart
///
/// Or integrate with `integration_test` + `screenshot` package:
///   flutter drive --driver=test_driver/integration_test.dart \
///       --target=metadata/screenshots/generate_screenshots.dart
library;

import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// iPhone 15 Pro Max logical resolution (3x scale).
const Size kScreenSize = Size(430, 932);

/// Physical pixel resolution for store screenshots.
const Size kPhysicalSize = Size(1290, 2796);

/// Screenshot definitions: route, filename, Russian caption, English caption.
const List<ScreenshotSpec> kScreenshots = [
  ScreenshotSpec(
    route: '/',
    filename: '01_alarm',
    captionRu: 'Умный будильник',
    captionEn: 'Smart Alarm',
  ),
  ScreenshotSpec(
    route: '/sleep-tracking',
    filename: '02_night_mode',
    captionRu: 'Ночной режим',
    captionEn: 'Night Mode',
  ),
  ScreenshotSpec(
    route: '/morning-report',
    filename: '03_morning_report',
    captionRu: 'Утренний отчёт',
    captionEn: 'Morning Report',
  ),
  ScreenshotSpec(
    route: '/statistics',
    filename: '04_statistics',
    captionRu: 'Статистика сна',
    captionEn: 'Sleep Statistics',
  ),
  ScreenshotSpec(
    route: '/paywall',
    filename: '05_paywall',
    captionRu: 'SleepWise Pro',
    captionEn: 'SleepWise Pro',
  ),
];

class ScreenshotSpec {
  final String route;
  final String filename;
  final String captionRu;
  final String captionEn;

  const ScreenshotSpec({
    required this.route,
    required this.filename,
    required this.captionRu,
    required this.captionEn,
  });
}

/// Adds a device frame and caption to a raw screenshot.
///
/// This can be run as a standalone Dart script to post-process PNGs:
///   dart run metadata/screenshots/add_frames.dart
Future<ui.Image> addDeviceFrame({
  required ui.Image screenshot,
  required String caption,
  Color backgroundColor = const Color(0xFF0A0E21),
  Color frameColor = const Color(0xFF1A1A2E),
  Color captionColor = Colors.white,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = Canvas(recorder);
  final width = kPhysicalSize.width;
  final height = kPhysicalSize.height;

  // Background gradient
  final bgPaint = Paint()
    ..shader = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF0A0E21), Color(0xFF1A1A3E)],
    ).createShader(Rect.fromLTWH(0, 0, width, height));
  canvas.drawRect(Rect.fromLTWH(0, 0, width, height), bgPaint);

  // Caption at top
  final textPainter = TextPainter(
    text: TextSpan(
      text: caption,
      style: TextStyle(
        color: captionColor,
        fontSize: 72,
        fontWeight: FontWeight.w700,
        letterSpacing: -0.5,
      ),
    ),
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: width - 120);
  textPainter.paint(
    canvas,
    Offset((width - textPainter.width) / 2, 140),
  );

  // Device frame (rounded rectangle)
  const frameMargin = 60.0;
  const frameTop = 320.0;
  const frameRadius = 60.0;
  final frameRect = RRect.fromRectAndRadius(
    Rect.fromLTWH(
      frameMargin,
      frameTop,
      width - frameMargin * 2,
      height - frameTop - 80,
    ),
    const Radius.circular(frameRadius),
  );

  // Frame shadow
  canvas.drawRRect(
    frameRect.shift(const Offset(0, 8)),
    Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20),
  );

  // Frame border
  canvas.drawRRect(
    frameRect,
    Paint()
      ..color = frameColor
      ..style = PaintingStyle.fill,
  );

  // Clip and draw screenshot inside frame
  canvas.save();
  canvas.clipRRect(
    RRect.fromRectAndRadius(
      Rect.fromLTWH(
        frameMargin + 6,
        frameTop + 6,
        width - frameMargin * 2 - 12,
        height - frameTop - 80 - 12,
      ),
      const Radius.circular(frameRadius - 6),
    ),
  );

  // Scale screenshot to fit frame
  final srcRect = Rect.fromLTWH(
    0,
    0,
    screenshot.width.toDouble(),
    screenshot.height.toDouble(),
  );
  final dstRect = Rect.fromLTWH(
    frameMargin + 6,
    frameTop + 6,
    width - frameMargin * 2 - 12,
    height - frameTop - 80 - 12,
  );
  canvas.drawImageRect(screenshot, srcRect, dstRect, Paint());
  canvas.restore();

  final picture = recorder.endRecording();
  return picture.toImage(width.toInt(), height.toInt());
}

void main() {
  // This file serves as the screenshot spec and frame utility.
  // Actual screenshot capture requires integration test setup.
  //
  // To capture screenshots manually:
  //
  // 1. Run the app in each screen state
  // 2. Take screenshots at 1290x2796 resolution
  // 3. Run the frame script:
  //      dart run metadata/screenshots/add_frames.dart
  //
  // For automated screenshots with integration_test:
  //
  //   flutter drive \
  //     --driver=test_driver/integration_test.dart \
  //     --target=integration_test/screenshot_test.dart \
  //     -d 'iPhone 15 Pro Max'

  test('Screenshot specs are valid', () {
    expect(kScreenshots.length, 5);
    for (final spec in kScreenshots) {
      expect(spec.filename, isNotEmpty);
      expect(spec.captionRu, isNotEmpty);
      expect(spec.captionEn, isNotEmpty);
    }
  });
}
