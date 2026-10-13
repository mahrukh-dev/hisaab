plugins {
    id("com.android.application")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.mahrukhdev.hisaab"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "30.0.16138531"

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    buildFeatures {
        resValues = true
    }

    defaultConfig {
        applicationId = "com.mahrukhdev.hisaab"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        resValue("string", "app_name", "Hisaab")
    }

    flavorDimensions.add("default")
    productFlavors {
        create("dev") {
            dimension = "default"
            applicationIdSuffix = ".dev"
            resValue("string", "app_name", "Hisaab Dev")
        }
        create("staging") {
            dimension = "default"
            applicationIdSuffix = ".staging"
            resValue("string", "app_name", "Hisaab Staging")
        }
        create("prod") {
            dimension = "default"
            resValue("string", "app_name", "Hisaab")
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("debug")
        }
    }
}

kotlin {
    compilerOptions {
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_17
    }
}

flutter {
    source = "../.."
}
