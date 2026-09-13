# Anatomia 3D (Human Body Explorer)

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.44+-02569B?logo=flutter&logoColor=white" alt="Flutter Version" />
  <img src="https://img.shields.io/badge/Dart-3.12+-0175C2?logo=dart&logoColor=white" alt="Dart Version" />
  <img src="https://img.shields.io/badge/Material-Design%203-7B1FA2" alt="Material 3" />
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-0066FF" alt="Clean Architecture" />
  <img src="https://img.shields.io/badge/Package-com.butterflydevs.anatomia3d-00C2FF" alt="Package Name" />
</p>

> **"See it. Zoom it. Understand it."**  
> An interactive 3D Human Anatomy Learning & Medical Education application built with Flutter, Provider, and GoRouter.

---

## 📖 Overview

**Anatomia 3D** is a modern educational mobile app designed for students, biology learners, medical and nursing students, and anatomy enthusiasts. Users can explore the human body through interactive 3D models, multi-layer toggles, physiological simulations (heartbeats, lung breathing, neural synapses, kidney filtration), pathology comparisons, smart search, and interactive quizzes.

---

## ✨ 10 Core Screens & Features

### 1. 🚀 Splash Screen
- Premium medical technology style with dark navy ambient theme (`#060B17`).
- Glowing vector human silhouette with animated cardiac pulse and energy rings.
- Smooth scale & fade animations with the signature tagline: *"See it. Zoom it. Understand it."*

### 2. 🏠 Home Screen Dashboard
- **Header**: App logo, branding, and interactive profile avatar with user level badge.
- **Search Bar**: Instant search for organs, systems, and diseases.
- **Hero Feature Cards**:
  - `3D Body - Explore in 3D` (Direct 3D body viewer launcher)
  - `AR Mode - See in your world` (Augmented Reality mode preview)
- **Popular Organs Grid**: Quick access to Brain, Heart, Lungs, Kidney, Liver, Stomach, Bones, Muscles.
- **Body Systems Section**: Nervous, Cardiovascular, Respiratory, Digestive, Skeletal, Muscular, Urinary.
- **Bottom Navigation**: Home, Explore, Quiz, Profile.

### 3. 🧬 3D Body Explorer Screen
- **Interactive 3D Simulation**:
  - 360° touch drag rotation around the Y-axis.
  - Smooth pinch-to-zoom (0.6x to 3.0x scale).
  - Angle presets: **Front**, **Back**, **Left**, **Right**.
- **Gender Toggle**: Male and Female anatomical model modes.
- **Layer Control Sidebar**: Quick toggles for Skin, Muscles, Bones, Organs, Blood Vessels, Nervous System.
- **Organ Hotspot Radar Pins**: Tap directly on Heart, Lungs, Brain, Liver, Stomach, or Kidneys to view quick summary cards and navigate to full organ details.
- **Pluggable Architecture**: `IAnatomy3DEngine` interface ready for seamless Unity 3D engine integration.

### 4. 🫀 Organ Details Screen
- **360° Rotating 3D Organ Viewer**: Vector 3D renderer (`Organ3DRenderer`) with touch-based rotation.
- **Segmented Tabs**:
  - **Overview**: Detailed summary, Latin medical nomenclature, and "Did You Know?" fun facts.
  - **Structure**: Comprehensive anatomical components (chambers, valves, lobes, vessels).
  - **Function**: Physiological mechanism breakdown.
  - **Diseases**: Common clinical pathologies with direct links to Disease Comparison mode.
- **Direct Actions**: "Play Animation" CTA and bookmarking toggle.

### 5. 🎛️ Layer Control System
- Dedicated bottom sheet / full controls with switch toggles for:
  - **Skin**: Epidermis & protective surface barrier
  - **Muscles**: Skeletal musculature & abdominal segments
  - **Bones**: 206 articulated skeletal bones & joints
  - **Organs**: Vital thoracic & abdominal organs
  - **Blood Vessels**: Arterial aorta and venous circulation
  - **Nervous System**: Cranial brain, spinal cord, and peripheral nerves
- Real-time composite rendering on the 3D model canvas.

### 6. 🎬 Physiological Animation Screen
- **Living Physiological Simulations (`PhysiologicalAnimationCanvas`)**:
  - **Lungs**: Breathing process with moving diaphragm, expanding alveoli, and flowing oxygen (cyan) / CO2 (amber) particles.
  - **Heart**: Cardiac cycle with atrial/ventricular systole and blood flow dynamics.
  - **Brain**: Neural action potentials firing across synaptic pathways.
  - **Kidney**: Nephron glomerulus filtration of metabolic waste into urine.
- **Interactive Player Controls**: Play/Pause, scrubber slider timeline, replay/forward buttons, and educational step explanations.

### 7. 🔍 Smart Search Anatomy Screen
- Instant query matching across organs, functions, pathologies, and body systems.
- Filter chips: **All**, **Organs**, **Functions**, **Diseases**.
- One-tap navigation directly to corresponding organ details or disease modes.

### 8. 🧩 Anatomy Quiz System
- Dynamic multi-question quiz system with live progress indicator and level display.
- **Instant Visual Feedback**: Options turn green with checkmarks for correct answers, or red for incorrect answers.
- **Clinical Explanations**: In-depth medical context for every question.
- **Gamified Scoring**: XP points awarded directly to user profile progress, with completion summary modal.

### 9. ⚖️ Disease Mode (Healthy vs. Diseased Comparison)
- Side-by-side comparative diagnostics (e.g. *Healthy Lung vs. Pneumonia Lung*, *Healthy Heart vs. Myocardial Infarction*).
- **Comparative Diagnostic Table**: Structured side-by-side comparison across Color, Texture, Air sacs, Function, and Symptoms.
- Clinical breakdowns of Symptoms, Causes, and Preventive Healthcare.

### 10. 👤 Profile & Progress Screen
- User progress dashboard (*Ahmed Rahman*).
- Key metrics: **Chapters Completed (12)**, **Quiz Points (320 XP)**, **Level (5)**.
- Sheets for **My Badges**, **Quiz History**, and **Saved Bookmarks**.
- Theme switcher: Medical Sci-fi Dark Navy (`#060B17`) and Light Clinical theme.

---

## 🏗️ Folder Structure

```
lib/
├── core/
│   ├── constants/
│   │   └── app_constants.dart          # Medical palette, typography & constants
│   ├── routes/
│   │   └── app_router.dart             # GoRouter shell & deep linking
│   └── theme/
│       └── app_theme.dart              # Dark & Light Material 3 themes
│
├── features/
│   ├── anatomy/
│   │   ├── body_explorer_screen.dart   # Screen 3: 3D Body View
│   │   └── layer_control_sheet.dart    # Screen 5: Layer Control
│   ├── animation/
│   │   └── animation_screen.dart       # Screen 6: Physiological Animation
│   ├── disease/
│   │   └── disease_comparison_screen.dart # Screen 9: Disease Comparison
│   ├── home/
│   │   └── home_screen.dart            # Screen 2: Home Dashboard
│   ├── organs/
│   │   └── organ_detail_screen.dart    # Screen 4: Organ Details
│   ├── profile/
│   │   └── profile_screen.dart         # Screen 10: User Profile & Progress
│   ├── quiz/
│   │   └── quiz_screen.dart            # Screen 8: Quiz System
│   ├── search/
│   │   └── search_screen.dart          # Screen 7: Smart Search
│   └── splash/
│       └── splash_screen.dart          # Screen 1: Splash Screen
│
├── models/
│   ├── body_system_model.dart          # Body systems schema
│   ├── disease_model.dart              # Pathology & comparison schema
│   ├── organ_model.dart                # Organ structure & 3D data schema
│   ├── quiz_model.dart                 # Quiz questions & explanations
│   └── user_profile_model.dart         # Badges, XP & user stats
│
├── providers/
│   ├── anatomy_provider.dart           # 3D canvas layers, angles & organ selection
│   ├── quiz_provider.dart              # Quiz progress, score & feedback state
│   ├── theme_provider.dart             # Dark/Light theme toggle
│   └── user_provider.dart              # User profile, bookmarks & XP management
│
├── services/
│   └── anatomy_data_service.dart       # Comprehensive anatomical clinical database
│
├── widgets/
│   ├── custom_3d_body_canvas.dart      # Interactive multi-layer 3D body canvas
│   ├── glass_card.dart                 # Glassmorphic container with blur & border
│   ├── organ_3d_renderer.dart          # Rotating vector 3D organ visualizer
│   └── physiological_animation_canvas.dart # Real-time physiological simulations
│
└── main.dart                           # App entry point & MultiProvider setup
```

---

## 🛠️ Technology Stack

| Technology | Purpose |
|---|---|
| **Flutter 3.44+ / Dart 3.12+** | Core mobile application framework |
| **Material Design 3** | Modern medical UI design system |
| **Provider** | Reactive state management |
| **GoRouter** | Declarative routing & bottom navigation shell |
| **Google Fonts (Inter)** | Clean, clinical typography |
| **Custom Canvas Painters** | 60 FPS vector 3D rendering & living simulations |
| **IAnatomy3DEngine Bridge** | Future Unity 3D engine integration architecture |

---

## 🚀 Getting Started

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.44 or later)
- Android Studio / VS Code with Flutter and Dart extensions
- Android Device or Emulator (API 21+)

### Installation

1. **Clone or navigate to the project directory:**
   ```bash
   cd anatomia_3d
   ```

2. **Install dependencies:**
   ```bash
   flutter pub get
   ```

3. **Verify code quality:**
   ```bash
   flutter analyze
   flutter test
   ```

4. **Run the application:**
   ```bash
   flutter run
   ```

---

## 🔮 Future Roadmap

- [ ] **Unity 3D Integration**: Connect high-poly 3D models and CT/MRI scan reconstructions via `IAnatomy3DEngine`.
- [ ] **Augmented Reality (AR Mode)**: Overlay interactive 3D organs on real-world surfaces via ARKit / ARCore.
- [ ] **AI Anatomy Assistant**: Medical terminology QA bot explaining clinical queries in Student and Medical modes.
- [ ] **VR Medical Classroom**: Immersive virtual reality organ dissection for medical students.

---

## 📄 License & Credits

Developed by **Butterfly Devs**.  
Application ID: `com.butterflydevs.anatomia3d`
