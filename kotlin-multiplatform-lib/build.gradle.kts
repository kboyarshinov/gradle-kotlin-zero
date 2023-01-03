plugins {
    alias(libs.plugins.kotlin.multiplatform)
}

kotlin {
    explicitApi()

    // targets
    jvm()

    // source sets & their configuration
    sourceSets {
        val commonMain by getting
        val commonTest by getting {
            dependencies {
                implementation(libs.testing.kotlin.test.common)
            }
        }
        val jvmMain by getting
        val jvmTest by getting
    }
}