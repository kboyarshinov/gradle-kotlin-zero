plugins {
    alias(libs.plugins.kotlin.jvm)
}

kotlin {
    // libraries should have explicit API by default
    explicitApi()
}

dependencies {
    implementation(libs.kotlin.common)
    implementation(libs.kotlin.stdlib)

    testImplementation(libs.testing.kotlin.test.common)
    testImplementation(libs.testing.kotlin.test.junit)
}

java {
    sourceCompatibility = JavaVersion.VERSION_1_8
    targetCompatibility = JavaVersion.VERSION_1_8
}