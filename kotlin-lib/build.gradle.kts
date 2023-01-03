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
}

java {
    sourceCompatibility = JavaVersion.VERSION_1_7
    targetCompatibility = JavaVersion.VERSION_1_7
}