# AdiShakti

A comprehensive safety application designed to enhance women's security during travel and daily commutes.

## Features

- Live Location Sharing
- Real-time Video and Audio Streaming
- Emergency Contact Management
- Police Booth Integration
- SOS Alert System with Voice Alerts
- Safe Route Navigation

## Getting Started

This project is a Flutter application. To get started with development:

1. Install Flutter SDK from [flutter.dev](https://flutter.dev/docs/get-started/install)
2. Set up your development environment
3. Run the following commands:

```bash
flutter pub get
flutter run
```

## Technical Requirements

- Flutter SDK
- Android Studio / VS Code
- Google Maps API Key
- Firebase Project Setup

## Dependencies

- google_maps_flutter: For map integration
- geolocator: For location services
- firebase_core & firebase_database: For real-time data
- flutter_webrtc: For video/audio streaming
- flutter_local_notifications: For alerts
- flutter_secure_storage: For secure data storage

## Security Features

- End-to-end encryption for all communications
- Secure location sharing
- Privacy-focused design
- Emergency contact verification

## Project Structure

- `lib/` - Contains the Dart source code
- `pubspec.yaml` - Flutter project configuration and dependencies
- `android/` - Android-specific files
- `ios/` - iOS-specific files

## Development

To run the app in debug mode:

```bash
flutter run
```

To build the app for release:

```bash
flutter build apk  # for Android
flutter build ios  # for iOS
```

To add new dependencies, edit this file and run:

```bash
flutter pub get
``` 