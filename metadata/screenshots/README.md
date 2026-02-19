# SleepWise Store Screenshots

## Target Resolution
- **iPhone 15 Pro Max**: 1290 × 2796 px (6.7")
- **iPhone 6.5"**: 1284 × 2778 px (fallback)
- **Android**: 1080 × 1920 px (minimum)

## Screenshots List

| # | Screen          | File                  | Caption (RU)         | Caption (EN)       |
|---|----------------|-----------------------|----------------------|--------------------|
| 1 | Alarm          | `01_alarm.png`        | Умный будильник      | Smart Alarm        |
| 2 | Night Mode     | `02_night_mode.png`   | Ночной режим         | Night Mode         |
| 3 | Morning Report | `03_morning_report.png` | Утренний отчёт     | Morning Report     |
| 4 | Statistics     | `04_statistics.png`   | Статистика сна       | Sleep Statistics   |
| 5 | Paywall        | `05_paywall.png`      | SleepWise Pro        | SleepWise Pro      |

## How to Capture

### Option 1: Manual (Simulator)
```bash
# Launch iOS simulator
open -a Simulator
xcrun simctl boot "iPhone 15 Pro Max"

# Run app and navigate to each screen
flutter run -d 'iPhone 15 Pro Max'

# Take screenshot
xcrun simctl io booted screenshot 01_alarm.png
```

### Option 2: Automated (integration_test)
```bash
flutter drive \
  --driver=test_driver/integration_test.dart \
  --target=integration_test/screenshot_test.dart \
  -d 'iPhone 15 Pro Max'
```

### Option 3: Fastlane Snapshots
```bash
cd ios && fastlane snapshot
```

## Adding Frames & Captions

The `generate_screenshots.dart` file contains the `addDeviceFrame()` utility
that overlays a device bezel and text caption on raw screenshots.

## Store Requirements

### App Store
- iPhone 6.7" (1290×2796): Required
- iPhone 6.5" (1284×2778): Required
- iPad 12.9" (2048×2732): Optional
- Format: PNG or JPEG, no alpha

### Google Play
- Min: 320px, Max: 3840px
- Aspect ratio: 16:9 or 9:16
- Format: PNG or JPEG, 24-bit
- Up to 8 screenshots

### RuStore
- Min: 320×320 px
- Format: PNG or JPEG
- Up to 10 screenshots
