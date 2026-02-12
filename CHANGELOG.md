# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2025-02-12

### Added
- **RollDrawer**: Unique drawer with paper roll animation effect
  - Cylindrical roll animation that simulates paper rolling
  - Customizable roll effect or simple slide-in drawer mode
  - Smooth animations with customizable duration and curves
  - Option to enable/disable animations
  - Customizable drawer width and padding

- **ScreenStackController**: Controller for managing screen stack/previews
  - Track and manage recent screens
  - Configurable maximum number of screens
  - Methods to add, remove, and clear screens

- **ScreenPreview**: Model for screen previews in drawer
  - Display mini screen previews in drawer
  - Support for custom icons, colors, and preview widgets
  - Tap callbacks for navigation

- **RollDrawerController**: Controller for programmatic drawer control
  - Open, close, and toggle drawer state
  - Listen to drawer state changes

### Features
- Full null safety support
- Light and dark theme support
- Fully responsive design
- Smooth animations
- Clean architecture
- Production ready
- No deprecated APIs
