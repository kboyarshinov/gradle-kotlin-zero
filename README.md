# Empty Gradle template for Kotlin based projects 

This is a completely empty (no kotlin code) Gradle project template for Kotlin, Kotlin multiplatform
and Android. It only contains Gradle configuration with `.gradle.kts` files and includes the
following features:

- shared version catalogue for libraries in
  default [`gradle/libs.versions.toml`](gradle/libs.versions.toml).
- separate configuration files for [library repositories](gradle/repositories.gradle.kts)
  and [plugin repositories](gradle/plugin-repositories.gradle.kts).
- typesafe project accessors enabled.
- stable configuration cache enabled.

You may want to use this template when you need just Gradle setup and don't want to remove
all the empty classes, resource files or rename packages.

# License

    Copyright 2023 Kirill Boyarshinov

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at
    
        http://www.apache.org/licenses/LICENSE-2.0
    
    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
