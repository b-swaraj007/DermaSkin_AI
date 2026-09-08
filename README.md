# DermaScan AI

AI-assisted skin health monitoring application built with Flutter, combining camera-based face processing with Google ML Kit and Face++ analysis services.

> **Note:** This project integrates existing computer-vision/analysis services; it does **not** contain a proprietary skin-analysis model trained by the project author. Results should not be treated as a medical diagnosis.

## Overview

DermaScan AI is a mobile application designed to turn a guided facial scan into structured skin-health insights. The application captures a suitable camera frame, performs face detection and analysis, combines results from multiple analysis paths, and presents the output through a user-facing experience.

The project uses a hybrid analysis approach:

```text
Camera Input
     |
     v
Best Face / Frame Selection
     |
     +----------------------+
     |                      |
     v                      v
Face++ Analysis        Google ML Kit
     |                Face / Mesh Analysis
     |                      |
     +----------+-----------+
                |
                v
       Combined Parameters
                |
                v
      Results + Recommendations
```

## Key Features

- Guided camera-based face scanning
- Face detection using Google ML Kit
- Face mesh processing for facial analysis workflows
- Face++ integration for skin-related analysis
- Hybrid analysis combining external analysis with local processing
- Fallback analysis path when Face++ analysis is unavailable
- Structured skin parameters and severity labels
- Scan results and user-facing dashboards
- Personalized recommendation workflows
- Image processing and asynchronous processing support
- Flutter mobile application architecture

## Analysis Pipeline

The central `HybridSkinAnalyzer` coordinates the analysis workflow.

1. The application selects and stores the best captured face frame.
2. Face++ skin analysis and local elasticity analysis are executed as parallel tasks.
3. Face++ results are combined with the locally derived elasticity result.
4. If Face++ fails, the application falls back to the local analysis path.
5. The final data is converted into structured skin parameters for presentation.

The current implementation exposes parameters such as:

- Skin Type & Moisture
- Wrinkles & Fine Lines
- Pigmentation & Spots
- Pore Size & Congestion
- Redness & Sensitivity
- UV Damage
- Skin Texture & Smoothness
- Elasticity & Firmness
- Estimated Skin Age

## Tech Stack

| Area | Technology |
|---|---|
| Application | Flutter / Dart |
| Camera | Flutter Camera |
| Face Detection | Google ML Kit |
| Face Mesh | Google ML Kit Face Mesh |
| Skin Analysis | Face++ API |
| Image Processing | Dart `image` package |
| Async Processing | `flutter_isolate` |
| Charts | `fl_chart` |
| Navigation | `go_router` |
| HTTP | `http` |

## Project Structure

```text
DermaSkin_AI/
├── android/
├── ios/
├── web/
├── assets/
├── lib/
│   └── services/
│       ├── hybrid_skin_analyzer.dart
│       ├── face_plus_service.dart
│       └── skin_analyzer.dart
├── test/
├── pubspec.yaml
└── README.md
```

## Getting Started

### Prerequisites

- Flutter SDK
- Dart SDK compatible with the version specified in `pubspec.yaml`
- Android Studio / Xcode as required by the target platform
- A configured Face++ API credential for features that depend on the external service

### Installation

```bash
git clone https://github.com/b-swaraj007/DermaSkin_AI.git
cd DermaSkin_AI
flutter pub get
```

Run the application:

```bash
flutter run
```

For platform-specific setup, follow the Flutter documentation and the project's platform configuration.

## API / Configuration

Do not commit API keys or other credentials to the repository.

Before running Face++-dependent functionality, configure the required credentials using the project's existing configuration approach.

## Limitations

- The project does not train a proprietary skin-diagnosis model.
- Some analysis depends on external services and network availability.
- Computer-vision output can vary with lighting, camera quality, framing, and image conditions.
- The application is intended for skin-health monitoring and educational/personalization use, not medical diagnosis.

## Future Improvements

- Add a dedicated trained skin-analysis model with a documented evaluation pipeline.
- Add explicit model-quality benchmarking and validation datasets.
- Improve robustness across lighting, skin-tone, and camera-condition variations.
- Add reproducible test cases for the analysis pipeline.
- Improve privacy controls for facial imagery and scan history.

## Author

**Swaraj Bhosale**

GitHub: https://github.com/b-swaraj007
