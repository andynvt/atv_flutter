# ATV Flutter - Android TV App

A Flutter application designed specifically for Android TV and Google TV devices, featuring a Netflix-style interface with MVVM architecture and Provider state management.

## Features

- **Android TV Optimized**: Built specifically for TV navigation with D-pad support
- **MVVM Architecture**: Clean separation of concerns with ViewModels and ChangeNotifier
- **Provider State Management**: Lightweight state management without external dependencies
- **TV Navigation**: Full D-pad support (up/down/left/right, select, back)
- **Focus Management**: Visual focus indicators with scaling and borders
- **Video Player**: Integrated video player with TV remote controls
- **Responsive Design**: Optimized for 1080p and 4K displays

## Architecture

```
lib/
├── app/                    # App configuration
│   ├── app.dart           # Main app widget
│   ├── di.dart            # Dependency injection
│   ├── router.dart        # Navigation routes
│   └── theme.dart         # App theming
├── core/                   # Core utilities
│   ├── tv/                # TV-specific functionality
│   │   ├── tv_keys.dart   # Remote control key mapping
│   │   ├── tv_shortcuts.dart # Keyboard shortcuts
│   │   ├── tv_focusable.dart # Focus management widget
│   │   └── tv_traversal.dart # Navigation traversal
│   └── utils/             # Utility classes
│       ├── result.dart    # Result wrapper
│       └── logger.dart    # Logging utility
├── data/                   # Data layer
│   ├── models/            # Data models
│   ├── dtos/              # Data transfer objects
│   ├── repositories/      # Repository implementations
│   └── sources/           # Data sources
├── domain/                 # Domain layer
│   ├── entities/          # Business entities
│   └── usecases/          # Business logic
└── presentation/           # UI layer
    ├── viewmodels/        # ViewModels
    ├── widgets/            # Reusable widgets
    └── pages/             # Screen implementations
```

## Pages

1. **Home Page**: Netflix-style horizontal rails with movie categories
2. **Grid Page**: Movie grid layout for browsing
3. **List Page**: Vertical list view of movies
4. **Detail Page**: Movie information and actions
5. **Player Page**: Full-screen video player with TV controls

## TV Navigation

### Remote Control Support
- **D-pad**: Navigate between items and sections
- **Select/Enter**: Activate focused item
- **Back**: Navigate to previous screen
- **Space**: Alternative select key

### Focus Management
- Visual focus indicators with borders and shadows
- Smooth scaling animations (1.04x scale)
- Automatic focus restoration when returning to pages

## Getting Started

### Prerequisites
- Flutter SDK (>=3.2.3)
- Android Studio / VS Code
- Android TV emulator or device

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd atv_flutter
```

2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

### Android TV Setup

1. **Emulator**: Use Android TV emulator with API level 21+
2. **Device**: Enable Developer Options and USB Debugging
3. **Manifest**: Already configured for TV support

## Dependencies

- `provider`: State management
- `go_router`: Navigation
- `video_player`: Video playback
- `flutter_lints`: Code quality

## Testing

Run the test suite:
```bash
flutter test
```

### Test Coverage
- Widget tests for TV focus components
- Unit tests for navigation logic
- Integration tests for key workflows

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

## TV-Specific Features

### Focus Traversal
- Custom traversal policies for TV navigation
- Focus groups for organized navigation
- Automatic focus management

### Visual Design
- Large typography for TV viewing distances
- High contrast colors and borders
- Smooth animations and transitions

### Performance
- Optimized for TV hardware
- Efficient image loading and caching
- Smooth scrolling and navigation

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests for new functionality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and questions:
- Create an issue on GitHub
- Check the documentation
- Review the test suite for examples

## Roadmap

- [ ] Enhanced video player controls
- [ ] User preferences and settings
- [ ] Offline content support
- [ ] Multi-language support
- [ ] Accessibility improvements
- [ ] Performance optimizations
