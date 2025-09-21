# Align My Cell Tower

A modern, responsive Swift/SwiftUI application for real-time GPS and compass data display, designed to help with precise cell tower alignment using mobile devices.

## Features

- **Real-time GPS Tracking**: Displays current latitude, longitude, and altitude with accuracy information
- **Compass Integration**: Shows magnetic heading and compass direction using device magnetometer
- **Modern SwiftUI Interface**: Responsive, accessible design that works across different iOS devices
- **Core Location Integration**: Seamless integration with Apple's Core Location framework
- **Permission Management**: Handles location service permissions gracefully
- **Error Handling**: Comprehensive error reporting and status information
- **Real-time Updates**: Live data updates with visual indicators

## Architecture

The application follows modern iOS development patterns with a clean architecture:

```
Sources/AlignMyCellTower/
├── Models/
│   └── LocationData.swift        # Core data model for location information
├── Managers/
│   └── LocationManager.swift     # Core Location service management
├── ViewModels/
│   └── LocationViewModel.swift   # Business logic and data binding
├── Views/
│   ├── ContentView.swift         # Main interface
│   └── DetailedStatusView.swift  # Detailed system information
└── AlignMyCellTower.swift        # Main library file
```

## Requirements

- iOS 15.0+ / macOS 12.0+
- Xcode 13+
- Swift 5.9+
- Device with GPS and magnetometer capabilities (for full functionality)

## Installation

### Using Swift Package Manager

Add this package to your Xcode project:

1. In Xcode, go to **File → Add Package Dependencies**
2. Enter the repository URL: `https://github.com/loudbinary/Align-my-cell-tower`
3. Select the version and add to your target

### Using Package.swift

Add the dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/loudbinary/Align-my-cell-tower", from: "1.0.0")
]
```

## Usage

### Basic Implementation

```swift
import SwiftUI
import AlignMyCellTower

@main
struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

### Using Individual Components

```swift
import AlignMyCellTower

// Create a location view model
let locationViewModel = LocationViewModel()

// Request location permission
locationViewModel.requestLocationPermission()

// Start tracking
locationViewModel.startLocationTracking()

// Access location data
if let location = locationViewModel.locationData {
    print("Coordinates: \(location.formattedLatitude), \(location.formattedLongitude)")
    print("Heading: \(location.formattedHeading)")
}
```

### Custom Location Handling

```swift
import AlignMyCellTower

// Create custom location data
let locationData = LocationData(
    latitude: 37.7749,
    longitude: -122.4194,
    altitude: 10.0,
    horizontalAccuracy: 5.0,
    verticalAccuracy: 10.0,
    heading: 45.0
)

print("Direction: \(locationData.compassDirection)")
print("Formatted: \(locationData.coordinatesDisplayString)")
```

## Permissions

The app requires location access to function properly. Add these keys to your `Info.plist`:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>This app needs location access to provide GPS coordinates and compass heading for cell tower alignment.</string>

<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>This app needs location access to provide GPS coordinates and compass heading for cell tower alignment.</string>
```

## Features in Detail

### LocationData Model

The core model representing location information:

- GPS coordinates (latitude, longitude, altitude)
- Accuracy measurements
- Compass heading and direction
- Timestamp information
- Formatted display properties

### LocationManager

Handles Core Location integration:

- Permission management
- Real-time location updates
- Compass heading updates
- Error handling and status reporting
- Battery-efficient location tracking

### LocationViewModel

Provides SwiftUI-ready data binding:

- Observable location data
- Status management
- Error message handling
- Computed properties for UI display
- Location data freshness tracking

### User Interface

Modern SwiftUI interface featuring:

- **Main View**: Real-time GPS and compass display
- **Status Indicators**: Visual feedback for tracking state
- **Compass Visualization**: Graphical compass with needle
- **Detailed Status**: Comprehensive system information
- **Responsive Design**: Adapts to different screen sizes

## Development

### Building the Project

```bash
# Clone the repository
git clone https://github.com/loudbinary/Align-my-cell-tower.git
cd Align-my-cell-tower

# Build the package
swift build

# Run tests
swift test
```

### Testing

The project includes comprehensive unit tests:

```bash
# Run all tests
swift test

# Run specific test suite
swift test --filter LocationDataTests
```

### Cross-Platform Compatibility

The code uses conditional compilation to support different platforms:

- **iOS/macOS**: Full functionality with Core Location and SwiftUI
- **Linux**: Core models and data structures (for development/testing)

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## Future Enhancements

- **Cell Tower Database Integration**: Connect to cell tower location databases
- **Augmented Reality**: AR overlay for tower direction visualization
- **Signal Strength**: Integration with cellular signal strength measurement
- **Historical Tracking**: Save and review location history
- **Export Functionality**: Export location data in various formats
- **Advanced Compass**: True north correction and calibration
- **Offline Maps**: Basic mapping functionality for remote areas

## Technical Notes

### Accuracy Considerations

- GPS accuracy depends on device capability and environmental conditions
- Compass readings may be affected by magnetic interference
- Best accuracy achieved in open areas with clear sky view
- Indoor use may result in degraded performance

### Performance

- Uses Core Location's standard location services
- Implements distance filtering to reduce battery usage
- Automatic pause/resume based on app state
- Efficient SwiftUI updates with Combine framework

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Apple's Core Location framework documentation
- SwiftUI best practices and design guidelines
- iOS development community contributions

---

**Note**: This application is designed for technical and educational purposes. For professional cell tower work, always use certified equipment and follow industry safety standards.
