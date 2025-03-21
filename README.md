# GTrack Nartec

<p align="center">
  <img src="assets/images/logo.png" alt="GTrack Logo" width="200"/>
</p>

A comprehensive Flutter application for GS1 standards-based tracking, identification, and inventory management with digital link capabilities.

## Overview

GTrack Nartec is a mobile application built with Flutter that provides solutions for product tracking, inventory management, and GS1 standard identifiers. The application supports both Android and iOS platforms and integrates with GS1 systems for product information and traceability.

## Features

- **Identify**: Manage GS1 identifiers including GTIN, GLN, SSCC, and GIAI
- **Share**: Product information sharing and digital link capabilities
- **Capture**: Barcode scanning and RFID integration
- **Supply Chain Visibility**: Track products throughout the supply chain
- **Inventory Management**: Real-time inventory tracking and management
- **Digital Link**: Connect physical products to online resources
- **GS1 Standards Compliance**: Full compliance with GS1 standards

- **GTIN Management**: Global Trade Item Number handling with digital link capabilities
- **GLN Management**: Global Location Number management with geolocation support
- **SSCC Handling**: Serial Shipping Container Code tracking and management
- **GIAI Support**: Global Individual Asset Identifier management

### Capture

- **Aggregation**: Product grouping and aggregation functionality
- **Serialization**: Product serialization and tracking
- **Mapping**: Location and item mapping with RFID support

### Share

- **Digital Links**: Product information sharing via digital links
- **Product Catalogue**: Comprehensive product information display
- **Product Certificates**: Support for product certification
- **Traceability**: End-to-end product traceability

### Additional Features

- **Google Maps Integration**: Location services with mapping
- **Image Capture and Processing**: Product image management
- **Barcode/QR Scanning**: GS1 standard barcode support

## Technical Architecture

- **Framework**: Flutter for cross-platform development
- **State Management**: BLoC/Cubit pattern
- **API Communication**: RESTful APIs with HTTP services
- **Storage**: Shared preferences for local configuration
- **Geolocation**: Integration with Google Maps
- **CI/CD**: Codemagic for build automation and deployment

## CI/CD Pipeline

The project uses Codemagic for continuous integration and deployment:

- **Build Automation**: The `codemagic.yaml` file defines workflows for building the Android release. The build process includes running scripts such as `flutter build apk --release` and executing `upload_apk_new.sh` to upload the APK to Google Drive.

- **APK Upload**: The `upload_apk_new.sh` script automates the process of uploading the APK to a specified Google Drive folder using a service account for authentication.

## Dependencies

Key dependencies used in the project include:

- **Flutter SDK**: The core framework for building the application.
- **BLoC/Cubit**: State management solution for managing application state.
- **HTTP**: For RESTful API communication.
- **Google Maps Flutter**: Integrates Google Maps for geolocation services.
- **Image Picker**: Allows image selection from the device gallery or camera.

## Getting Started

### Prerequisites

- Flutter SDK (latest stable version)
- Android Studio with SDK tools
- Xcode (for iOS development)
- Google Maps API key
- GS1 credentials (for full functionality)

### Installation

1. Clone the repository:

```bash
git clone https://github.com/GTrack-Nartec/gtrack_nartec.git
cd gtrack_nartec
```

2. Install dependencies

```bash
flutter pub get
```

3. Set up Google Maps API key

   - For Android: Add the key in AndroidManifest.xml
   - For iOS: The key is already set in AppDelegate.swift

4. Build and run

```bash
flutter run
```

### Building for Release

#### Platform-Specific Instructions

### Android

To build the Android application, ensure you have the Flutter SDK installed and run the following command:

```bash
flutter build apk --release
```

### iOS

For iOS, ensure you have Xcode installed and run:

```bash
flutter build ios --release
```

Ensure all necessary configurations and permissions are set in the `ios` directory for a successful build.

## Project Structure

- **lib/blocs/**: State management using BLoC pattern
  - Identify: GTIN, GLN, SSCC handlers
  - Share: Product information sharing
  - Global: Application-wide state management
- **lib/controllers/**: Business logic and API communication
- **lib/models/**: Data models for different functionalities
- **lib/constants/**: Configuration and constant values
- **lib/global/**: Common utilities and services

## Configuration

API endpoints and services are configured in `lib/constants/app_urls.dart`.

## License

Copyright 2025 GS1 Saudi Arabia. All rights reserved.
