{ pkgs, lib, config, inputs, ... }:

{
  # https://devenv.sh/packages/
  packages = [ pkgs.git ];

  # https://devenv.sh/languages/
  languages.java.enable = true;
  languages.java.jdk.package = pkgs.zulu25;
  languages.java.gradle.enable = true;
  languages.java.gradle.package = pkgs.gradle_9;

  # https://devenv.sh/basics/
  enterShell = ''
    java --version
    gradle --version
  '';

  # https://devenv.sh/tasks/
  tasks = {
    "gradle:build".exec = "gradle build --stacktrace";
  };

  # https://devenv.sh/tests/
  enterTest = ''
    echo "Running tests"
    java --version | grep --color=auto "Zulu$(echo ${pkgs.zulu25.version}| awk -F '.' '{print $1}')"
    gradle --version | grep --color=auto "Gradle ${pkgs.gradle_9.version}"
  '';

 android = {
    enable = true;
    platforms.version = [ "36" ];
    systemImageTypes = [ "google_apis_playstore" ];
    abis = [ "arm64-v8a" "x86_64" ];
    cmake.version = [ "3.22.1" ];
    cmdLineTools.version = "20.0";
    tools.version = "26.1.1";
    # platformTools.version defaults to latest from nixpkgs
    buildTools.version = [ "36.0.0" "37.0.0" ];
    emulator = {
      enable = false;
      # version defaults to latest from nixpkgs
    };
    sources.enable = false;
    systemImages.enable = false;
    ndk.enable = false;
    googleAPIs.enable = false;
    googleTVAddOns.enable = false;
    extras = [ "extras;google;gcm" ];
    extraLicenses = [
      "android-sdk-license"
      "android-sdk-preview-license"
    ];
    android-studio = {
      enable = false;
      package = pkgs.android-studio;
    };
  };
}
