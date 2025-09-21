# Align My Cell Tower

A GPS-based iOS app that helps users align their mobile device to target cell tower locations using real-time compass and tilt feedback.

## Features

### 🎯 Real-Time Alignment
- **GPS Position Tracking**: Uses CoreLocation for precise positioning
- **Azimuth Calculations**: Real-time bearing calculations to target locations
- **Tilt Calculations**: Elevation angle calculations accounting for tower height
- **Live Compass**: Visual compass with device and target direction indicators
- **Alignment Feedback**: Color-coded accuracy indicators and status updates

### 🗺️ Interactive Map
- **Pin Dropping**: Tap to select target cell tower locations
- **Dual View**: Shows both current location and target simultaneously
- **Tower Height Input**: Customize tower height for accurate tilt calculations
- **Distance Display**: Real-time distance and direction information

### 📱 Motion Sensing
- **Device Orientation**: Uses CoreMotion for real-time device heading
- **Tilt Detection**: Accelerometer data for device tilt measurements
- **Gyroscope Integration**: Smooth orientation tracking
- **Real-time Updates**: 10Hz update rate for responsive feedback

### 🎨 User Interface
- **Tab-Based Navigation**: Separate Map and Alignment views
- **Visual Indicators**: Color-coded alignment status (Red/Yellow/Green)
- **Metric Cards**: Clear display of heading difference, tilt, and device orientation
- **Progress Visualization**: Circular progress indicators and linear progress bars
- **Accessibility**: VoiceOver support and large text compatibility

## Architecture

The app follows the **MVVM (Model-View-ViewModel)** pattern for clean separation of concerns:

### Models
- **`LocationManager`**: Handles GPS location services and permissions
- **`MotionManager`**: Manages device motion and orientation sensors
- **`AlignmentCalculator`**: Utility functions for azimuth, tilt, and alignment calculations

### ViewModels
- **`AlignmentViewModel`**: Coordinates data flow between models and views using Combine

### Views
- **`ContentView`**: Main tab interface
- **`MapView`**: Interactive map for target selection
- **`AlignmentView`**: Real-time alignment feedback interface
- **`CompassView`**: Custom compass visualization

## Getting Started

### Prerequisites
- iOS 16.0 or later
- Xcode 15.0 or later
- Physical iOS device (simulator has limited location/motion support)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/loudbinary/Align-my-cell-tower.git
   ```

2. Open `AlignMyCellTower.xcodeproj` in Xcode

3. Build and run on a physical iOS device

### Permissions
The app requires the following permissions:
- **Location Access**: For GPS positioning (`NSLocationWhenInUseUsageDescription`)
- **Motion Sensors**: For device orientation (`NSMotionUsageDescription`)

## Usage

### Setting a Target
1. Open the **Map** tab
2. Navigate to your desired cell tower location
3. Tap on the map to drop a pin at the target location
4. Set the tower height in meters when prompted
5. The target location is now set for alignment

### Aligning Your Device
1. Switch to the **Align** tab
2. Hold your device pointing toward the target
3. Use the compass to align the blue device arrow with the red target arrow
4. Watch the alignment accuracy percentage increase
5. When accuracy reaches 90%+, you're aligned! 🎯

### Understanding the Interface

#### Compass View
- **Blue Arrow**: Your device's current heading
- **Red Arrow**: Target direction
- **Green Arc**: Alignment accuracy visualization
- **Cardinal Directions**: N, E, S, W labels for reference

#### Alignment Metrics
- **Heading**: Degrees off from target direction
- **Tilt**: Required upward/downward angle
- **Device Tilt**: Current device orientation
- **Accuracy**: Percentage of alignment precision

#### Status Indicators
- **🔴 ADJUST** (0-69%): Significant adjustment needed
- **🟡 CLOSE** (70-89%): Minor adjustments needed
- **🟢 ALIGNED** (90-100%): Successfully aligned!

## Technical Details

### Calculation Methods

#### Azimuth (Bearing)
```swift
// Calculate bearing between two GPS coordinates
let bearing = atan2(
    sin(deltaLongitude) * cos(toLatitude),
    cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(deltaLongitude)
)
```

#### Tilt Angle
```swift
// Calculate elevation angle accounting for tower height
let distance = currentLocation.distance(from: targetLocation)
let altitudeDifference = targetLocation.altitude - currentLocation.altitude + targetHeight
let tiltRadians = atan(altitudeDifference / distance)
```

#### Alignment Accuracy
```swift
// Calculate accuracy based on heading difference
let headingDifference = abs(deviceHeading - targetAzimuth)
let normalizedDifference = min(headingDifference, 360 - headingDifference)
let accuracy = max(0, 100 - (normalizedDifference / 180.0 * 100))
```

### Performance Optimizations
- **Reactive Updates**: Uses Combine for efficient data flow
- **Battery Management**: Stops location/motion updates when app is inactive
- **Smooth Animations**: 60fps UI updates with proper animation curves
- **Memory Efficient**: Automatic cleanup of observation subscriptions

### Accuracy Considerations
- **GPS Accuracy**: Typically 3-5 meters in open areas
- **Magnetic Declination**: Uses magnetic north (can be adjusted for true north)
- **Device Calibration**: Compass may need calibration for best results
- **Environmental Factors**: Buildings and metal objects can affect readings

## File Structure

```
AlignMyCellTower/
├── AlignMyCellTowerApp.swift          # App entry point
├── Views/
│   ├── ContentView.swift              # Main tab interface
│   ├── MapView.swift                  # Interactive map
│   ├── AlignmentView.swift            # Alignment interface
│   └── CompassView.swift              # Custom compass
├── ViewModels/
│   └── AlignmentViewModel.swift       # MVVM coordinator
├── Models/
│   ├── LocationManager.swift          # GPS location services
│   ├── MotionManager.swift            # Device motion sensors
│   └── AlignmentCalculator.swift      # Calculation utilities
├── Assets.xcassets/                   # App icons and colors
├── Preview Content/                   # SwiftUI previews
└── Info.plist                        # App configuration
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/amazing-feature`
3. Commit your changes: `git commit -m 'Add amazing feature'`
4. Push to the branch: `git push origin feature/amazing-feature`
5. Open a Pull Request

## Future Enhancements

- [ ] True north vs magnetic north toggle
- [ ] Augmented reality overlay mode
- [ ] Multiple target location management
- [ ] Alignment history and logging
- [ ] Export target locations
- [ ] Offline maps support
- [ ] Voice guidance features
- [ ] Integration with cell tower databases

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Uses Apple's CoreLocation framework for GPS positioning
- Uses Apple's CoreMotion framework for device orientation
- Built with SwiftUI for modern iOS development
- Inspired by professional antenna alignment tools
