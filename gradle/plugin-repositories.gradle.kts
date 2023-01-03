// Declare repositories for plugins
pluginManagement {
    repositories {
        // Allow Gradle and Jetbrains plugins portal
        exclusiveContent {
            forRepository { gradlePluginPortal() }

            filter {
                includeGroupByRegex("com.gradle.*")
                includeGroupByRegex("org.gradle.*")
                includeGroupByRegex("org.jetbrains.*")
            }
        }

        // Allow Google Android plugins from google repository
        exclusiveContent {
            forRepository { google() }

            filter {
                includeGroupByRegex("com\\.android.*")
                includeGroupByRegex("androidx.*")
            }
        }

        // Maven central for the rest of plugins
        mavenCentral()
    }
}
