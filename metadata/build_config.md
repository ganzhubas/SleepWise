# SleepWise — Build Configuration Guide

## App Identity

| Parameter         | Value                        |
|-------------------|------------------------------|
| App Name          | SleepWise                    |
| Bundle ID (iOS)   | `com.sleepwise.sleepwise`    |
| Application ID    | `com.sleepwise.sleepwise`    |
| Version           | `1.0.0`                      |
| Build Number      | `1`                          |
| Min iOS           | 16.0                         |
| Min Android SDK   | 26 (Android 8.0)             |
| Category          | Health & Fitness             |

## iOS Configuration

### Prerequisites
- Xcode 15+
- Apple Developer Account (Team ID required)
- Provisioning Profile (App Store Distribution)

### Signing Setup
1. Open `ios/Runner.xcworkspace` in Xcode
2. Select Runner target → Signing & Capabilities
3. Set Team to your Apple Developer Team
4. Enable Automatic Signing (or configure manual provisioning)
5. Verify Bundle Identifier: `com.sleepwise.sleepwise`

### Capabilities (already configured)
- Background Modes: Audio
- HealthKit (via entitlements)

### Build Release
```bash
# Clean build
flutter clean

# Build iOS archive
flutter build ios --release

# Or build IPA directly
flutter build ipa --release --export-options-plist=ios/ExportOptions.plist
```

### ExportOptions.plist (create for CI/CD)
```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
  "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>method</key>
    <string>app-store</string>
    <key>teamID</key>
    <string>YOUR_TEAM_ID</string>
    <key>uploadBitcode</key>
    <false/>
    <key>uploadSymbols</key>
    <true/>
</dict>
</plist>
```

## Android Configuration

### Prerequisites
- JDK 17
- Android SDK (API 26+)
- Release keystore

### Generate Keystore
```bash
keytool -genkey -v \
  -keystore android/keystore/sleepwise-release.jks \
  -keyalg RSA -keysize 2048 -validity 10000 \
  -alias sleepwise \
  -storepass <YOUR_STORE_PASSWORD> \
  -keypass <YOUR_KEY_PASSWORD> \
  -dname "CN=SleepWise, O=SleepWise, L=Moscow, C=RU"
```

### Configure Signing

#### Option A: key.properties (local development)
Create `android/key.properties`:
```properties
storePassword=<password>
keyPassword=<password>
keyAlias=sleepwise
storeFile=../keystore/sleepwise-release.jks
```

#### Option B: Environment variables (CI/CD)
```bash
export KEYSTORE_PATH=/path/to/sleepwise-release.jks
export KEYSTORE_PASSWORD=<password>
export KEY_ALIAS=sleepwise
export KEY_PASSWORD=<password>
```

### Build Release
```bash
# Build App Bundle (for Google Play)
flutter build appbundle --release

# Build APK (for RuStore or direct distribution)
flutter build apk --release --split-per-abi

# Output locations:
# - build/app/outputs/bundle/release/app-release.aab
# - build/app/outputs/flutter-apk/app-arm64-v8a-release.apk
```

## Version Management

Update version in `pubspec.yaml`:
```yaml
version: 1.0.0+1
#        ^^^^^  ^ build number (versionCode for Android)
#        |
#        semantic version (CFBundleShortVersionString / versionName)
```

### Incrementing for updates
```yaml
# Patch release (bug fixes)
version: 1.0.1+2

# Minor release (new features)
version: 1.1.0+3

# Major release
version: 2.0.0+4
```

## Pre-Release Checklist

### Code
- [ ] All tests pass: `flutter test`
- [ ] No analyzer warnings: `flutter analyze`
- [ ] Localization complete (EN + RU)
- [ ] Version bumped in pubspec.yaml

### iOS
- [ ] Bundle ID set
- [ ] Team & signing configured
- [ ] HealthKit entitlement enabled
- [ ] Privacy descriptions in Info.plist
- [ ] App icon configured (1024x1024)
- [ ] Launch screen configured
- [ ] `flutter build ios --release` succeeds

### Android
- [ ] applicationId set
- [ ] Release keystore created and secured
- [ ] ProGuard rules configured
- [ ] Permissions in AndroidManifest.xml
- [ ] App icon configured (adaptive)
- [ ] `flutter build appbundle --release` succeeds

### Store Assets
- [ ] Screenshots (5 per device size)
- [ ] App description (RU + EN)
- [ ] Privacy Policy URL live
- [ ] Terms of Service URL live
- [ ] App icon (512x512 for Play, 1024x1024 for App Store)
- [ ] Feature graphic (1024x500 for Play)
