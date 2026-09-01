#!/usr/bin/env bash
set -euo pipefail

project_dir="$(cd "$(dirname "$0")/.." && pwd)"
cd "$project_dir"

config_source="firebase/android/google-services.json"
config_target="android/app/google-services.json"

if [[ ! -f "$config_source" ]]; then
  echo "Firebase Android config not found: $config_source" >&2
  exit 1
fi

cp "$config_source" "$config_target"

settings_file="android/settings.gradle.kts"
app_gradle="android/app/build.gradle.kts"

if ! grep -q 'com.google.gms.google-services' "$settings_file"; then
  sed -i '/id("org.jetbrains.kotlin.android")/a\    id("com.google.gms.google-services") version "4.4.4" apply false' "$settings_file"
fi

if ! grep -q 'com.google.gms.google-services' "$app_gradle"; then
  sed -i '/id("com.android.application")/a\    id("com.google.gms.google-services")' "$app_gradle"
fi

sed -i 's/namespace = "com\.example\.body_quest"/namespace = "com.bodyquest.app"/' "$app_gradle"
sed -i 's/applicationId = "com\.example\.body_quest"/applicationId = "com.bodyquest.app"/' "$app_gradle"

old_activity="$(find android/app/src/main/kotlin -name MainActivity.kt -print -quit)"
new_dir="android/app/src/main/kotlin/com/bodyquest/app"
mkdir -p "$new_dir"

if [[ -n "$old_activity" && "$old_activity" != "$new_dir/MainActivity.kt" ]]; then
  sed 's/^package .*/package com.bodyquest.app/' "$old_activity" > "$new_dir/MainActivity.kt"
  rm "$old_activity"
fi

echo "Firebase Android configuration applied for com.bodyquest.app"
