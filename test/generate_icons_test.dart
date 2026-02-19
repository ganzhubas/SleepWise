// Generates app icon (1024x1024), adaptive foreground, and splash icon as PNG.
// Run: flutter test test/generate_icons_test.dart

@Tags(['generate'])
library;

import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';

const int iconSize = 1024;
const int splashSize = 512;

// Brand colors
const int nightSky = 0xFF0D1B2A;
const int starYellow = 0xFFFFC857;

void main() {
  test('generate app icons', () async {
    TestWidgetsFlutterBinding.ensureInitialized();

    // Generate app icon 1024x1024
    final iconBytes = await _renderIcon(iconSize);
    final iconFile = File('assets/icon/app_icon.png');
    await iconFile.parent.create(recursive: true);
    await iconFile.writeAsBytes(iconBytes);
    // ignore: avoid_print
    print('App icon: ${iconFile.path} (${iconBytes.length} bytes)');

    // Generate adaptive foreground
    final fgBytes = await _renderIcon(iconSize, adaptiveForeground: true);
    final fgFile = File('assets/icon/app_icon_foreground.png');
    await fgFile.writeAsBytes(fgBytes);
    // ignore: avoid_print
    print('Adaptive fg: ${fgFile.path} (${fgBytes.length} bytes)');

    // Generate splash icon 512x512
    final splashBytes = await _renderIcon(splashSize, splashMode: true);
    final splashFile = File('assets/icon/splash_icon.png');
    await splashFile.writeAsBytes(splashBytes);
    // ignore: avoid_print
    print('Splash icon: ${splashFile.path} (${splashBytes.length} bytes)');
  });
}

Future<Uint8List> _renderIcon(
  int size, {
  bool adaptiveForeground = false,
  bool splashMode = false,
}) async {
  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas(recorder);
  final s = size.toDouble();

  if (adaptiveForeground) {
    // Transparent background
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, s, s),
      ui.Paint()..color = const ui.Color(0x00000000),
    );
  } else {
    // Solid dark background + subtle gradient
    canvas.drawRect(
      ui.Rect.fromLTWH(0, 0, s, s),
      ui.Paint()..color = const ui.Color(nightSky),
    );
    final bgPaint = ui.Paint()
      ..shader = ui.Gradient.radial(
        ui.Offset(s * 0.35, s * 0.35),
        s * 0.8,
        [const ui.Color(0xFF162B44), const ui.Color(nightSky)],
        [0.0, 1.0],
      );
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, s, s), bgPaint);
  }

  final scale = s / 1024.0;

  canvas.save();
  if (adaptiveForeground) {
    // Shrink to fit in Android adaptive icon safe zone
    canvas.translate(s * 0.18, s * 0.18);
    canvas.scale(0.64);
  }

  // --- Stars (small dots) ---
  final stars = <List<double>>[
    [180, 150, 6, 1.0], [750, 120, 5, 0.8], [890, 250, 4, 0.7],
    [130, 400, 3.5, 0.6], [820, 520, 5, 0.9], [160, 650, 4, 0.7],
    [900, 700, 3, 0.5], [350, 100, 3, 0.55], [650, 80, 4, 0.65],
    [100, 250, 3, 0.5], [870, 400, 4.5, 0.75], [780, 780, 3.5, 0.6],
    [250, 800, 3, 0.5], [550, 850, 4, 0.65], [950, 150, 3, 0.45],
  ];
  for (final st in stars) {
    _drawDot(canvas, st[0] * scale, st[1] * scale, st[2] * scale, st[3]);
  }

  // --- Twinkling 4-pointed stars ---
  _drawTwinkle(canvas, 200 * scale, 200 * scale, 18 * scale, 0.9);
  _drawTwinkle(canvas, 830 * scale, 180 * scale, 14 * scale, 0.7);
  _drawTwinkle(canvas, 150 * scale, 550 * scale, 12 * scale, 0.6);
  _drawTwinkle(canvas, 880 * scale, 600 * scale, 16 * scale, 0.8);

  // --- Crescent moon ---
  final cx = s * 0.48;
  final cy = splashMode ? s * 0.45 : s * 0.42;
  final mr = s * 0.28;

  // Glow
  final glowPaint = ui.Paint()
    ..shader = ui.Gradient.radial(
      ui.Offset(cx, cy), mr * 1.8,
      [const ui.Color(0x30FFC857), const ui.Color(0x15FFC857), const ui.Color(0x00FFC857)],
      [0.0, 0.5, 1.0],
    );
  canvas.drawCircle(ui.Offset(cx, cy), mr * 1.8, glowPaint);

  // Moon gradient
  final moonPaint = ui.Paint()
    ..shader = ui.Gradient.linear(
      ui.Offset(cx - mr, cy - mr), ui.Offset(cx + mr, cy + mr),
      [const ui.Color(0xFFFFF3D4), const ui.Color(0xFFFFD97D), const ui.Color(0xFFFFC857)],
      [0.0, 0.6, 1.0],
    );

  // Crescent: draw moon then cut with overlapping circle
  final cutR = mr * 0.82;
  final cutDx = mr * 0.45;
  final cutDy = -mr * 0.15;

  if (adaptiveForeground) {
    // Can't use dstOut on transparent bg — draw full moon then dark cut circle
    canvas.drawCircle(ui.Offset(cx, cy), mr, moonPaint);
    canvas.drawCircle(
      ui.Offset(cx + cutDx, cy + cutDy), cutR,
      ui.Paint()..color = const ui.Color(nightSky),
    );
  } else {
    // Use saveLayer + dstOut for clean crescent
    canvas.saveLayer(ui.Rect.fromLTWH(0, 0, s * 2, s * 2), ui.Paint());
    canvas.drawCircle(ui.Offset(cx, cy), mr, moonPaint);
    canvas.drawCircle(
      ui.Offset(cx + cutDx, cy + cutDy), cutR,
      ui.Paint()..blendMode = ui.BlendMode.dstOut..color = const ui.Color(0xFFFFFFFF),
    );
    canvas.restore();
  }

  // Decorative stars near moon
  _drawTwinkle(canvas, cx + mr * 0.7, cy - mr * 0.9, 20 * scale, 1.0);
  _drawTwinkle(canvas, cx + mr * 1.1, cy - mr * 0.3, 12 * scale, 0.8);
  _drawTwinkle(canvas, cx + mr * 0.5, cy + mr * 0.8, 10 * scale, 0.6);

  // Sleep Z's
  _drawZ(canvas, cx + mr * 0.9, cy - mr * 1.1, 42 * scale, 0.9);
  _drawZ(canvas, cx + mr * 1.2, cy - mr * 0.7, 32 * scale, 0.7);
  _drawZ(canvas, cx + mr * 1.4, cy - mr * 0.3, 22 * scale, 0.5);

  canvas.restore();

  final picture = recorder.endRecording();
  final image = await picture.toImage(size, size);
  final bd = await image.toByteData(format: ui.ImageByteFormat.png);
  return bd!.buffer.asUint8List();
}

void _drawDot(ui.Canvas c, double x, double y, double r, double a) {
  c.drawCircle(
    ui.Offset(x, y), r,
    ui.Paint()..color = ui.Color.fromARGB((a * 255).round(), 0xFF, 0xC8, 0x57),
  );
}

void _drawTwinkle(ui.Canvas c, double x, double y, double sz, double a) {
  final p = ui.Paint()
    ..color = ui.Color.fromARGB((a * 255).round(), 0xFF, 0xC8, 0x57)
    ..strokeWidth = sz * 0.15
    ..style = ui.PaintingStyle.stroke
    ..strokeCap = ui.StrokeCap.round;
  c.drawLine(ui.Offset(x - sz, y), ui.Offset(x + sz, y), p);
  c.drawLine(ui.Offset(x, y - sz), ui.Offset(x, y + sz), p);
  c.drawCircle(
    ui.Offset(x, y), sz * 0.2,
    ui.Paint()..color = ui.Color.fromARGB((a * 255).round(), 0xFF, 0xFF, 0xFF),
  );
}

void _drawZ(ui.Canvas c, double x, double y, double sz, double a) {
  final p = ui.Paint()
    ..color = ui.Color.fromARGB((a * 255).round(), 0xE0, 0xE1, 0xDD)
    ..strokeWidth = sz * 0.12
    ..style = ui.PaintingStyle.stroke
    ..strokeCap = ui.StrokeCap.round
    ..strokeJoin = ui.StrokeJoin.round;
  final path = ui.Path()
    ..moveTo(x - sz * 0.4, y - sz * 0.4)
    ..lineTo(x + sz * 0.4, y - sz * 0.4)
    ..lineTo(x - sz * 0.4, y + sz * 0.4)
    ..lineTo(x + sz * 0.4, y + sz * 0.4);
  c.drawPath(path, p);
}
