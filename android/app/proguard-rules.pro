# SleepWise ProGuard Rules

# Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

# Hive
-keep class * extends com.google.protobuf.GeneratedMessageLite { *; }
-keep class hive.** { *; }

# Health plugin
-keep class androidx.health.** { *; }

# Keep model classes for Hive serialization
-keep class com.sleepwise.sleepwise.** { *; }

# Google Play Core (for in-app updates if used)
-keep class com.google.android.play.core.** { *; }
