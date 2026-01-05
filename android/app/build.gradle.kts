plugins {
    id("com.android.application")
    id("kotlin-android")
    // El plugin de Flutter debe ir después de Android y Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.castrodev.recetas"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = "29.0.13599879" 
    
    
    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.castrodev.recetas"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = project.findProperty("RELEASE_KEY_ALIAS") as String
            keyPassword = project.findProperty("RELEASE_KEY_PASSWORD") as String
            storeFile = file(project.findProperty("RELEASE_STORE_FILE") as String)
            storePassword = project.findProperty("RELEASE_STORE_PASSWORD") as String
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
            isMinifyEnabled = false
            isShrinkResources = false
            // Puedes activar ProGuard/R8 más adelante si quieres ofuscación
        }
    }
}

flutter {
    source = "../.."
}
