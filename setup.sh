#!/usr/bin/env bash
set -eo pipefail

removeModulePrompt() {
    read -p "Do you want to remove the $1 sample (y/n)? " answer
    case ${answer:0:1} in
        y|Y )
            sed -i "/^include(\":$2\")/d" ./settings.gradle.kts
            rm -rf ./$2
        ;;
    esac
}

# read project name
echo "This script will set up your new Kotlin project."
read -p "Enter your project name: " projectName
if [[ -z "$projectName" ]]; then
    echo "Project name can not be empty"
    exit 1
fi

# remove license file if confirmed
read -p "Do you want to remove the license file (y/n)? " answer
case ${answer:0:1} in
    y|Y )
        rm LICENSE.txt
    ;;
esac

# remove modules if confirmed
removeModulePrompt "Kotlin library" "kotlin-lib"
removeModulePrompt "Kotlin MPP library" "kotlin-multiplatform-lib"
removeModulePrompt "Kotlin Android library" "kotlin-android-lib"
removeModulePrompt "Kotlin Android app" "kotlin-android-app"

echo "Configuring project '$projectName'..."

# update license if it's not deleted
if [[ -e LICENSE.txt ]]; then
    sed -i 's/^   Copyright.*/   Copyright "$(date +%Y)" "$(git config --global --get user.name)"/g' ./LICENSE.txt
fi

# change root project name
sed -i "s/^rootProject.name = \"[a-zA-Z-_0-9]+\"$/rootProject.name = \"$projectName\"/g" ./settings.gradle.kts

# update readme
rm README.md
echo "# $projectName" >> README.md

echo "Project '$projectName' configured. Changes can be committed."
exit 0
