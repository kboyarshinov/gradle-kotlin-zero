plugins {
    alias(libs.plugins.android.app)
}

android {
    namespace = "kotlin.android.app"
    compileSdk = libs.versions.android.compile.get().toInt()

    defaultConfig {
        minSdk = libs.versions.android.min.get().toInt()
        targetSdk = libs.versions.android.target.get().toInt()

        testInstrumentationRunner = "android.support.test.runner.AndroidJUnitRunner"
    }

}

kotlin {
    compilerOptions {
        languageVersion = org.jetbrains.kotlin.gradle.dsl.KotlinVersion.KOTLIN_2_2
        jvmTarget = org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_18
    }
}

dependencies {
    implementation(projects.kotlinAndroidLib)
}