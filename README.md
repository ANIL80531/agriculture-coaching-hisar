# 🌾 Agriculture Coaching Hisar - Online Teaching & Learning Platform (Flutter Android App)

A production-grade Android mobile application built with the **Flutter Framework** for educators to teach online and students to learn interactively.

---

## 🌟 Key Features

### 1. 🔐 Google Sign-In & Role Management
- **Google Authentication**: Frictionless login with Google accounts.
- **Role-Based Workspaces**:
  - **Student Mode**: Browse courses, purchase via UPI, watch lectures, attend live classes, take quizzes, and view presentation decks.
  - **Educator Mode**: Author courses, launch live lectures, create MCQ tests with solutions, and share PPT slides.
  - **Instant Role Switcher**: One-tap toggle in the Profile screen to test both viewpoints.

### 2. ⚡ Third-Party UPI Payment Integration
- Supports **all major Indian UPI applications**:
  - Google Pay (`com.google.android.apps.nbu.paisa.user`)
  - PhonePe (`com.phonepe.app`)
  - Paytm (`net.one97.paytm`)
  - BHIM UPI (`in.org.npci.upiapp`)
  - CRED UPI (`com.dreamplug.androidapp`)
  - Amazon Pay (`in.amazon.mShop.android.shopping`)
  - Custom UPI ID (VPA) / QR input
- **NPCI Compliant URI**: Dispatches standard `upi://pay?pa=...&pn=...&am=...&cu=INR&tn=...` deep-link intents.
- **Instant Course Unlock**: Once payment is verified, the course status immediately switches from locked to enrolled with digital receipt generation.

### 3. 🔒 Course Access Control & Content Viewer
- **Syllabus & Previews**: Non-enrolled students can browse curriculum and watch free trial previews.
- **Paywalled Modules**: Video lessons, downloadable PDF notes, module quizzes, and live classrooms are locked until course purchase.
- **In-App Video Player**: Seekbar, playback speed controls (0.75x to 2.0x), and lesson completion checkboxes.

### 4. 🔴 Live Interactive Classroom
- **Real-time Live Lectures**: Direct access for enrolled students with pulsing live badge.
- **Audio/Video Controls**: Toggle Microphone, Camera, and Raise Hand.
- **Synchronized Slide Mode**: Teacher can switch stage from camera stream to presentation slides during class.
- **Live In-Class Chat**: Real-time Q&A stream with educator priority badges.

### 5. 📝 MCQ Questions Maker & Student Quiz System
- **For Educators ("Make MCQ Questions")**:
  - Add quiz title, description, time limit, and passing score percentage.
  - Add questions with 4 distinct options (A, B, C, D).
  - Select the correct answer with radio buttons.
  - Add detailed explanations and solutions.
- **For Students ("Take MCQ Test")**:
  - Real-time countdown timer with color alert.
  - Clean question-by-question layout with option tiles.
  - Instant scoring with percentage, pass/fail status, and detailed review with explanations.

### 6. 📊 PPT Presentation Sharing & Slide Viewer
- **For Educators ("Share PPT")**:
  - Upload/share lecture slide decks, chapter notes, and code snippets with enrolled students.
- **For Students ("View PPT")**:
  - Slide-by-slide viewer with horizontal swipe and previous/next controls.
  - Full-screen presentation mode.
  - Instructor slide notes drawer.
  - Offline caching support.

---

## 📁 Project Architecture & Directory Structure

```
edupulse_app/
├── android/
│   ├── app/
│   │   ├── src/main/AndroidManifest.xml    # Android 11+ UPI <queries> and permissions
│   │   ├── build.gradle                    # Gradle configuration (minSdkVersion 21, targetSdkVersion 34)
│   │   └── kotlin/.../MainActivity.kt
│   ├── build.gradle
│   └── settings.gradle
├── pubspec.yaml                             # Dependencies: provider, url_launcher, google_fonts, intl
├── lib/
│   ├── main.dart                           # MultiProvider initialization & app theme
│   ├── config/
│   │   ├── app_constants.dart              # Merchant UPI VPA, app branding, storage keys
│   │   ├── app_theme.dart                  # Indigo/Slate design system & Google Fonts
│   │   └── upi_constants.dart              # NPCI UPI URI builder & package identifiers
│   ├── models/
│   │   ├── user_model.dart                 # Student & Educator profile schema
│   │   ├── course_model.dart               # Course details, pricing & syllabus
│   │   ├── lesson_model.dart               # Video lectures & curriculum modules
│   │   ├── live_lecture_model.dart         # Live streams & interactive chat messages
│   │   ├── mcq_model.dart                  # Quizzes, questions, options, & grading attempts
│   │   ├── ppt_model.dart                  # Presentation decks & slide notes
│   │   └── payment_model.dart              # UPI transaction log & receipts
│   ├── providers/
│   │   ├── auth_provider.dart              # Authentication & role switching state
│   │   ├── course_provider.dart            # Course catalog & search state
│   │   ├── payment_provider.dart           # UPI checkout & payment processing
│   │   ├── live_lecture_provider.dart      # In-class audio/video & chat state
│   │   ├── mcq_provider.dart               # Quiz creation & active exam timer
│   │   └── ppt_provider.dart               # Slide presentation navigation & full-screen
│   ├── services/
│   │   ├── google_auth_service.dart        # Google OAuth handling
│   │   ├── upi_payment_service.dart        # Deep-link launcher for 3rd-party UPI apps
│   │   ├── mock_database.dart              # Preloaded courses, MCQs, & slide decks
│   │   └── storage_service.dart            # Persistent storage for enrollments & authored content
│   ├── screens/
│   │   ├── splash_screen.dart              # Animated splash & session routing
│   │   ├── auth/google_login_screen.dart   # Google Sign-In with role selector
│   │   ├── student/
│   │   │   ├── student_main_navigation.dart
│   │   │   ├── student_home_screen.dart    # Live banner, categories, course list
│   │   │   ├── student_my_courses_screen.dart # Enrolled courses & progress
│   │   │   └── student_profile_screen.dart # Profile, settings, role switch
│   │   ├── educator/
│   │   │   └── educator_dashboard_screen.dart # Studio with MCQ Maker & PPT Share
│   │   ├── course/
│   │   │   ├── course_detail_screen.dart   # Syllabus & sticky UPI enroll button
│   │   │   └── course_content_viewer_screen.dart # Video stage, unlocked lessons & materials
│   │   ├── payment/
│   │   │   ├── upi_payment_screen.dart     # Order summary & 3rd-party UPI selector
│   │   │   └── payment_receipt_screen.dart # Digital receipt with UTR & start button
│   │   ├── live/
│   │   │   └── live_lecture_room_screen.dart # Interactive classroom with chat & stage
│   │   ├── mcq/
│   │   │   ├── mcq_creator_screen.dart     # Author questions, options, & solutions
│   │   │   ├── mcq_quiz_screen.dart        # Student test taking with timer
│   │   │   └── mcq_result_screen.dart      # Score report & question breakdown
│   │   └── ppt/
│   │       ├── ppt_upload_screen.dart      # Slide presentation uploader
│   │       └── ppt_viewer_screen.dart      # Slide-by-slide viewer with full-screen
│   └── widgets/
│       ├── course_card.dart
│       ├── live_status_indicator.dart
│       └── upi_app_selector.dart
└── test/
    └── widget_test.dart                    # Automated tests for UPI, access control, & MCQs
```

---

## 🛠️ Android Configuration for Third-Party UPI Apps

Starting with **Android 11 (API level 30)**, apps must declare package visibility inside `android/app/src/main/AndroidManifest.xml` to interact with external UPI apps. This is already fully configured in this project:

```xml
<queries>
    <!-- Generic UPI scheme query -->
    <intent>
        <action android:name="android.intent.action.VIEW" />
        <data android:scheme="upi" />
    </intent>
    
    <!-- 3rd-party UPI application packages -->
    <package android:name="com.google.android.apps.nbu.paisa.user" />  <!-- Google Pay -->
    <package android:name="com.phonepe.app" />                         <!-- PhonePe -->
    <package android:name="net.one97.paytm" />                         <!-- Paytm -->
    <package android:name="in.org.npci.upiapp" />                      <!-- BHIM UPI -->
    <package android:name="com.dreamplug.androidapp" />                 <!-- CRED -->
    <package android:name="in.amazon.mShop.android.shopping" />        <!-- Amazon Pay -->
</queries>
```

---

## 🚀 How to Build and Run the App

### Option 1: Build with Apache Maven (Recommended on Linux aarch64 / ARM64)
You can build the Android debug APK directly with Maven:
```bash
cd /root/agriculture_coaching_hisar
mvn package
```
The output APK is generated at:
- [build/app/outputs/flutter-apk/app-debug.apk](file:///root/agriculture_coaching_hisar/build/app/outputs/flutter-apk/app-debug.apk)
- [target/app-debug.apk](file:///root/agriculture_coaching_hisar/target/app-debug.apk)

### Option 2: Run with Flutter CLI
```bash
cd /root/agriculture_coaching_hisar
flutter pub get
flutter run
```

### Option 3: Automated Verification
Run the end-to-end verification script:
```bash
python3 verify_project.py
```

---

## 💳 Configured Merchant UPI Details
The app is configured for:
- **Institute Name**: `Agriculture Coaching Hisar`
- **Merchant VPA**: `8053127034@sbi`

In [lib/config/app_constants.dart](file:///root/edupulse_app/lib/config/app_constants.dart):
```dart
static const String merchantUpiId = '8053127034@sbi';
static const String merchantName = 'Agriculture Coaching Hisar';
```
All student course purchases made using PhonePe, Google Pay, Paytm, BHIM, CRED, or any other UPI app will be credited directly to `8053127034@sbi`.
