plugins {
    id("com.android.application")
    id("kotlin-android")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.sleepwise.sleepwise"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        applicationId = "com.sleepwise.sleepwise"
        minSdk = 26
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            // Configure via environment variables or local key.properties:
            //   storeFile = file(System.getenv("KEYSTORE_PATH") ?: "../keystore/sleepwise-release.jks")
            //   storePassword = System.getenv("KEYSTORE_PASSWORD") ?: ""
            //   keyAlias = System.getenv("KEY_ALIAS") ?: "sleepwise"
            //   keyPassword = System.getenv("KEY_PASSWORD") ?: ""
            //
            // To generate a keystore:
            //   keytool -genkey -v -keystore sleepwise-release.jks \
            //     -keyalg RSA -keysize 2048 -validity 10000 \
            //     -alias sleepwise -storepass <password>
            //
            // For CI/CD, set environment variables or use key.properties file.
            // Falling back to debug signing until release keystore is configured.
            storeFile = signingConfigs.getByName("debug").storeFile
            storePassword = signingConfigs.getByName("debug").storePassword
            keyAlias = signingConfigs.getByName("debug").keyAlias
            keyPassword = signingConfigs.getByName("debug").keyPassword
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = true
            isShrinkResources = true
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
    }

    bundle {
        language {
            enableSplit = true
        }
        density {
            enableSplit = true
        }
        abi {
            enableSplit = true
        }
    }
}

flutter {
    source = "../.."
}
