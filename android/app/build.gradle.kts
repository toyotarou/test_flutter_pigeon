plugins {
    id("com.android.application")
    id("kotlin-android")
    // Flutter プラグインは最後
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.battery_pigeon_demo"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.battery_pigeon_demo"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

flutter {
    source = "../.."
}

/* ---- ここが今回追加した依存宣言 ---- */
dependencies {
    implementation("org.jetbrains.kotlinx:kotlinx-coroutines-core:1.8.0")
    // Coroutine を Android 用に最適化したい場合はこちらも追加
    // implementation("org.jetbrains.kotlinx:kotlinx-coroutines-android:1.8.0")
}
