# Align My Cell Tower

An iOS app that helps users align their device to point directly at a target GPS location. The app calculates both the direction (azimuth) and tilt (elevation) needed to align the device based on the current location and orientation of the user.

## Features

- **GPS Location Services**: Uses CoreLocation to automatically detect your current position
- **Interactive Map**: Select target locations using an intuitive map interface
- **Precise Calculations**: Calculates azimuth (compass bearing) and elevation angles
- **Motion Sensors**: Integrates CoreMotion for real-time device orientation data
- **Clean UI**: Modern SwiftUI interface with intuitive design
- **Settings**: Customizable options for units and accuracy

## Screenshots

*Screenshots will be available once the app is built and running on a device or simulator.*

## Requirements

- iOS 16.0 or later
- iPhone or iPad with GPS capability
- Location Services permission
- Motion & Fitness permission (for compass and orientation data)

## Project Structure

```
AlignMyCellTower/
├── AlignMyCellTowerApp.swift          # Main app entry point
├── ContentView.swift                   # Root view with tab navigation
├── Views/
│   ├── HomeView.swift                 # Main alignment interface
│   ├── MapView.swift                  # Interactive map for location selection
│   └── SettingsView.swift             # Settings and configuration
├── ViewModels/
│   ├── LocationManager.swift          # CoreLocation management
│   └── MotionManager.swift            # CoreMotion management
├── Models/
│   └── LocationModel.swift            # Location data model
├── Utilities/
│   └── AlignmentCalculator.swift      # Mathematical calculations
└── Assets.xcassets/                   # App icons and assets
```

## How to Build and Run

1. **Prerequisites**:
   - Xcode 15.0 or later
   - macOS Ventura (13.0) or later
   - iOS 16.0 SDK

2. **Setup**:
   ```bash
   git clone https://github.com/loudbinary/Align-my-cell-tower.git
   cd Align-my-cell-tower
   open AlignMyCellTower.xcodeproj
   ```

3. **Build and Run**:
   - Select your target device or simulator
   - Press `Cmd+R` to build and run
   - Grant location and motion permissions when prompted

## How to Use

1. **Current Location**: The app automatically detects your current GPS position
2. **Set Target**: 
   - Enter coordinates manually, or
   - Use the map to select a target location
3. **View Alignment**: The app displays:
   - **Azimuth**: Direction to point (in degrees and cardinal direction)
   - **Elevation**: Tilt angle (positive = look up, negative = look down)
   - **Distance**: How far away the target is
4. **Device Orientation**: Real-time compass heading, pitch, and roll data

## Technical Details

### Coordinate System
- **Azimuth**: 0° = North, 90° = East, 180° = South, 270° = West
- **Elevation**: Positive angles = upward tilt, Negative angles = downward tilt
- **Distance**: Calculated using great circle distance formula

### Permissions Required
- **Location Services**: `NSLocationWhenInUseUsageDescription`
- **Motion Sensors**: `NSMotionUsageDescription`

### Frameworks Used
- **SwiftUI**: Modern declarative UI framework
- **CoreLocation**: GPS and location services
- **CoreMotion**: Accelerometer, gyroscope, and magnetometer
- **MapKit**: Interactive map interface

## Development

### Architecture
The app follows MVVM (Model-View-ViewModel) architecture:
- **Models**: Data structures (`LocationModel`)
- **Views**: SwiftUI user interface components
- **ViewModels**: Business logic and state management (`LocationManager`, `MotionManager`)
- **Utilities**: Helper functions for calculations

### Key Classes

- `LocationManager`: Handles GPS location updates and permissions
- `MotionManager`: Manages device motion and compass data
- `AlignmentCalculator`: Performs azimuth/elevation calculations
- `HomeView`: Main user interface for alignment
- `MapView`: Interactive map for target selection

## Future Enhancements

- [ ] Augmented Reality (AR) overlay for visual alignment
- [ ] Saved target locations and favorites
- [ ] Real-time feedback and guidance
- [ ] Offline map support
- [ ] More precise elevation calculations using terrain data
- [ ] Support for multiple coordinate systems

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Uses standard geodesic calculations for azimuth and elevation
- Built with Apple's CoreLocation and CoreMotion frameworks
- Icons from SF Symbols
