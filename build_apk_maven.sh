#!/usr/bin/env bash
set -e

PROJECT_DIR="/root/agriculture_coaching_hisar"
OUTPUT_DIR="$PROJECT_DIR/build/app/outputs/flutter-apk"
TARGET_DIR="$PROJECT_DIR/target"
TEMP_BUILD="/tmp/apk_build"

echo "=========================================================="
echo " Building Agriculture Coaching Hisar (Android Debug APK)  "
echo " Target Architecture: Linux aarch64 / arm64-v8a           "
echo " Build Engine: Maven & Android Tools Pipeline             "
echo "=========================================================="

mkdir -p "$TEMP_BUILD"

echo ">>> [1/6] Compiling Flutter Dart Bundle & Assets..."
export PATH="$PATH:/opt/flutter/bin"
cd "$PROJECT_DIR"
flutter build bundle

echo ">>> [2/6] Compiling Android Java Sources..."
mkdir -p "$TEMP_BUILD/classes"
javac -cp "/opt/android-sdk/platforms/android-34/android.jar:$PROJECT_DIR/build/maven-libs/flutter_embedding_debug.jar:$PROJECT_DIR/build/maven-libs/lifecycle-common.jar" \
  -d "$TEMP_BUILD/classes" \
  "$PROJECT_DIR/android/app/src/main/java/com/edupulse/online_teaching_app/MainActivity.java"

echo ">>> [3/6] Building Dalvik Executable (classes.dex) with D8..."
mkdir -p "$TEMP_BUILD/dex"
java -cp /opt/android-sdk/cmdline-tools/latest/lib/r8.jar com.android.tools.r8.D8 \
  --lib /opt/android-sdk/platforms/android-34/android.jar \
  --output "$TEMP_BUILD/dex" \
  "$PROJECT_DIR/build/maven-libs/flutter_embedding_debug.jar" \
  "$PROJECT_DIR/build/maven-libs/lifecycle-common.jar" \
  "$TEMP_BUILD/classes/com/edupulse/online_teaching_app/MainActivity.class"

echo ">>> [4/6] Packaging Base APK with AAPT..."
rm -f "$TEMP_BUILD/unsigned.apk"
aapt package -F "$TEMP_BUILD/unsigned.apk" \
  -M "$PROJECT_DIR/android/app/src/main/AndroidManifest.xml" \
  -S "$PROJECT_DIR/android/app/src/main/res" \
  -I /opt/android-sdk/platforms/android-34/android.jar -f

echo ">>> [5/6] Injecting classes.dex, Flutter assets, and arm64-v8a native libraries..."
cd "$TEMP_BUILD"
cp "$TEMP_BUILD/dex/classes.dex" .
zip -u -0 "$TEMP_BUILD/unsigned.apk" classes.dex

# Add assets/flutter_assets
mkdir -p "$TEMP_BUILD/assets"
rm -rf "$TEMP_BUILD/assets/flutter_assets"
cp -r "$PROJECT_DIR/build/flutter_assets" "$TEMP_BUILD/assets/"
cd "$TEMP_BUILD"
zip -u -r "$TEMP_BUILD/unsigned.apk" assets/

# Add lib/arm64-v8a/libflutter.so
mkdir -p "$TEMP_BUILD/lib/arm64-v8a"
unzip -p "$PROJECT_DIR/build/maven-libs/arm64_v8a_debug.jar" lib/arm64-v8a/libflutter.so > "$TEMP_BUILD/lib/arm64-v8a/libflutter.so"
cd "$TEMP_BUILD"
zip -u -0 "$TEMP_BUILD/unsigned.apk" lib/arm64-v8a/libflutter.so

echo ">>> [6/6] Signing Debug APK with Android Keystore..."
mkdir -p "$OUTPUT_DIR" "$TARGET_DIR"
FINAL_APK="$OUTPUT_DIR/app-debug.apk"
cp "$TEMP_BUILD/unsigned.apk" "$FINAL_APK"

jarsigner -sigalg SHA256withRSA -digestalg SHA-256 \
  -keystore /root/.android/debug.keystore \
  -storepass android -keypass android \
  "$FINAL_APK" androiddebugkey

# Copy to Maven target
cp "$FINAL_APK" "$TARGET_DIR/app-debug.apk"
cp "$FINAL_APK" "$TARGET_DIR/agriculture-coaching-hisar-1.0.0-SNAPSHOT.apk"

echo ""
echo "=========================================================="
echo " BUILD SUCCESSFUL! DEBUG APK GENERATED                    "
echo " Path: $FINAL_APK"
echo " Size: $(ls -lh "$FINAL_APK" | awk '{print $5}')"
echo "=========================================================="
