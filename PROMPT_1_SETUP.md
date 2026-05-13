# Qoder Prompt — MediaPipe AR Setup (Phase 1)

> **Copy and paste this entire prompt into Qoder IDE chat.**

---

## Context

I am building a Flutter skin analysis app. Flutter version is `3.41.7`, Dart `3.11.5`.  
I need you to set up the full MediaPipe Face Landmarker integration via Flutter Platform Channels (Method Channel) for Android and iOS. Do NOT use Unity. Do NOT use google_mlkit_face_mesh as primary solution.

The `.task` model file `face_landmarker.task` is already downloaded and placed inside `assets/` folder and referenced in `pubspec.yaml` under flutter assets.

---

## Task 1 — pubspec.yaml

Open `pubspec.yaml` and add the following packages under `dependencies` if not already present:

```yaml
dependencies:
  camera: ^0.10.5+9
  permission_handler: ^11.3.0
  flutter_isolate: ^2.0.4
  image: ^4.2.0
  vector_math: ^2.1.4
```

Also confirm this exists under the `flutter:` section:

```yaml
flutter:
  assets:
    - assets/face_landmarker.task
```

Then run `flutter pub get`.

---

## Task 2 — android/app/build.gradle

Open `android/app/build.gradle` and ensure:

```groovy
android {
    compileSdkVersion 34

    defaultConfig {
        minSdkVersion 24
        targetSdkVersion 34
    }
}
```

Also add the MediaPipe dependency inside `dependencies {}` block:

```groovy
dependencies {
    implementation 'com.google.mediapipe:tasks-vision:0.10.14'
}
```

---

## Task 3 — android/build.gradle

Open `android/build.gradle` (project level) and make sure Google's Maven repo is included:

```groovy
allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

---

## Task 4 — AndroidManifest.xml

Open `android/app/src/main/AndroidManifest.xml` and add inside `<manifest>` tag before `<application>`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" android:required="false" />
<uses-feature android:name="android.hardware.camera.autofocus" android:required="false" />
```

---

## Task 5 — iOS Podfile

Open `ios/Podfile` and set platform to iOS 14 minimum:

```ruby
platform :ios, '14.0'
```

Also add MediaPipe pod inside the `target 'Runner'` block:

```ruby
target 'Runner' do
  pod 'MediaPipeTasksVision', '~> 0.10.14'
end
```

Then run `pod install` inside the `ios/` directory.

---

## Task 6 — ios/Runner/Info.plist

Open `ios/Runner/Info.plist` and add camera permission inside the root `<dict>`:

```xml
<key>NSCameraUsageDescription</key>
<string>This app uses the camera for real-time skin analysis AR features.</string>
```

---

## Task 7 — Copy model file for iOS

Copy `assets/face_landmarker.task` into `ios/Runner/` directory.  
Then open Xcode → right-click `Runner` folder → **Add Files to Runner** → select `face_landmarker.task` → check **Copy items if needed** → check **Add to targets: Runner** → click Add.

---

## Task 8 — Create empty native files

Create the following empty files (do not write any code in them yet, just create them):

**Android:**
- `android/app/src/main/kotlin/<your_package_path>/MediaPipePlugin.kt`
- `android/app/src/main/kotlin/<your_package_path>/FaceLandmarkerHelper.kt`

**iOS:**
- `ios/Runner/MediaPipePlugin.swift`
- `ios/Runner/FaceLandmarkerHelper.swift`

---

## Task 9 — Create empty Flutter AR files

Create the following empty Dart files inside the `lib/` folder:

```
lib/ar_features/mediapipe_channel.dart
lib/ar_features/face_mesh_painter.dart
lib/ar_features/skin_zone_overlay_painter.dart
lib/ar_features/treatment_painter.dart
lib/ar_features/ar_camera_screen.dart
lib/ar_features/treatment_animation_controller.dart
```

---

## Task 10 — Verify build

Run `flutter build apk --debug` for Android.  
Run `flutter build ios --debug --no-codesign` for iOS.  

Fix any build errors related to dependencies, SDK versions, or gradle sync. Report back what errors occur if any.

---

## Important Notes for Qoder

- Do NOT write any implementation logic yet. Only do setup.
- Replace `<your_package_path>` with the actual Kotlin package folder path from `MainActivity.kt`.
- If there are any version conflicts in gradle or pods, resolve them by using the latest compatible version and report what was changed.
- After all tasks are done, confirm each file was created/modified successfully.
