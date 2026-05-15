#!/usr/bin/env bash
set -eo pipefail

removeModulePrompt() {
    read -p "Do you want to remove the $1 sample (y/n)? " -r answer
    case ${answer:0:1} in
        y|Y )
            # Safely remove module include line from settings.gradle.kts
            local escaped_module=$(printf '%s\n' "$2" | sed -e 's/[[\.*^$/]/\\&/g')
            sed -i.bak "\|^include(\":${escaped_module}\")|d" ./settings.gradle.kts && rm -f ./settings.gradle.kts.bak
            rm -rf ./"$2"
            ;;
        *)
            ;;
    esac
}

# Validates that the project name follows Gradle naming conventions
validate_project_name() {
    local name="$1"

    # Trim whitespace
    name=$(echo "$name" | xargs)

    # Check not empty after trim
    if [[ -z "$name" ]]; then
        echo "Project name cannot be empty"
        return 1
    fi

    # Validate format: start with letter, alphanumeric + hyphens/underscores
    if ! [[ "$name" =~ ^[a-zA-Z][a-zA-Z0-9_-]*$ ]]; then
        echo "Invalid project name."
        echo "Requirements:"
        echo "  - Must start with a letter"
        echo "  - Only alphanumeric characters, hyphens, and underscores allowed"
        echo "  - Examples: myProject, my-project, my_project"
        return 1
    fi

    echo "$name"
    return 0
}

# Ensure script is run from project root directory
if [[ ! -f "setup.sh" ]]; then
    echo "Error: Must run this script from the project root directory"
    exit 1
fi

# Check if project has already been configured
if ! grep -q "gradle-kotlin-zero" settings.gradle.kts 2>/dev/null; then
    echo "Warning: Project appears to already be configured (gradle-kotlin-zero not found in settings.gradle.kts)"
    read -p "Continue anyway? This may cause unexpected results (y/n)? " -r
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Setup cancelled"
        exit 0
    fi
fi

# Read project name with validation
echo "This script will set up your new Kotlin project."
while true; do
    read -p "Enter your project name: " -r projectName
    if validated=$(validate_project_name "$projectName"); then
        projectName="$validated"
        break
    fi
    echo "Please try again."
done

# Remove license file if confirmed
read -p "Do you want to remove the license file (y/n)? " -r answer
case ${answer:0:1} in
    y|Y )
        if [[ -f LICENSE.txt ]]; then
            rm LICENSE.txt
            echo "Removed LICENSE.txt"
        fi
        ;;
    *)
        ;;
esac

# Remove modules if confirmed
removeModulePrompt "Kotlin library" "kotlin-lib"
removeModulePrompt "Kotlin MPP library" "kotlin-multiplatform-lib"
removeModulePrompt "Kotlin Android library" "kotlin-android-lib"
removeModulePrompt "Kotlin Android app" "kotlin-android-app"

echo "Configuring project '$projectName'..."

# Update license if it's not deleted
if [[ -f LICENSE.txt ]]; then
    date=$(date +%Y)
    # Fallback for missing git config and suppress errors
    gitUser=$(git config --global --get user.name 2>/dev/null || echo "")
    if [[ -z "$gitUser" ]]; then
        gitUser="Unknown"
    fi

    # Escape special sed characters to prevent injection or regex failures
    safeDate=$(printf '%s\n' "$date" | sed -e 's/[\/&]/\\&/g')
    safeName=$(printf '%s\n' "$gitUser" | sed -e 's/[\/&]/\\&/g')

    # Use portable sed in-place with backup
    sed -i.bak "s/^   Copyright.*/   Copyright $safeDate $safeName/" LICENSE.txt && rm -f LICENSE.txt.bak
fi

# Change root project name
# Escape special sed characters
safeProjectName=$(printf '%s\n' "$projectName" | sed -e 's/[\/&]/\\&/g')

if [[ -f settings.gradle.kts ]]; then
    sed -i.bak "s/^rootProject\.name[[:space:]]*=[[:space:]]*\"[^\"]*\"/rootProject.name = \"$safeProjectName\"/" settings.gradle.kts && rm -f settings.gradle.kts.bak
fi

if [[ -f buildSrc/settings.gradle.kts ]]; then
    sed -i.bak "s/^rootProject\.name[[:space:]]*=[[:space:]]*\"[^\"]*\"/rootProject.name = \"$safeProjectName\"/" buildSrc/settings.gradle.kts && rm -f buildSrc/settings.gradle.kts.bak
fi

# Update README with project title
if [[ -f README.md ]]; then
    rm README.md
fi
echo "# ${projectName}" >> README.md

# Remove renovate config
if [[ -f .github/renovate.json5 ]]; then
    rm .github/renovate.json5
fi

read -p "Do you want to remove GitHub actions config (y/n)? " -r answer
case ${answer:0:1} in
    y|Y )
        rm -rf .github
        echo "✓ Removed GitHub configuration"
        ;;
    *)
        echo "✓ Kept GitHub configuration (renovate.json5 has been removed)"
        ;;
esac

echo ""
echo "✓ Project '${projectName}' configured successfully!"
echo ""
echo "Next steps:"
echo "1. Review changes in settings.gradle.kts"
echo "2. Commit your changes: git add -A && git commit -m 'Initial project setup'"
echo "3. Start building: ./gradlew build"
echo ""

exit 0
