plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter Gradle Plugin must be after Android/Kotlin
    id("dev.flutter.flutter-gradle-plugin")

    // Firebase google-services plugin
    id("com.google.gms.google-services")
}

android {
    namespace = "com.TezXizmat"

    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.TezXizmat"

        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion

        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11

        isCoreLibraryDesugaringEnabled = true
    }

    kotlinOptions {
        jvmTarget = "11"
    }

    buildTypes {
        release {
            // hozircha debug signing bilan ishlayveradi
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

dependencies {
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.5")
}

flutter {
    source = "../.."
}