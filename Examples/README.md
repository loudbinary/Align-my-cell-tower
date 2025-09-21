# Examples

This directory contains example implementations showing how to use the AlignMyCellTower library.

## iOS Example

The `iOSExample` directory contains:

- `ExampleApp.swift`: Complete iOS app implementation
- `Info.plist`: Required permissions and app configuration

### Running the iOS Example

1. Open Xcode
2. Create a new iOS app project
3. Copy the contents of `ExampleApp.swift` to your app's main Swift file
4. Copy the required permissions from `Info.plist` to your app's Info.plist
5. Add AlignMyCellTower as a package dependency
6. Run on a physical device for full GPS and compass functionality

### Key Points

- **Physical Device Required**: GPS and compass features require a physical iOS device
- **Permissions**: Make sure to include location permissions in Info.plist
- **Testing**: The app works best outdoors with clear sky view
- **Compass Calibration**: iOS may prompt users to calibrate the compass on first use

### Usage Patterns

The example shows two implementation approaches:

1. **Direct Use**: Simply import and use `ContentView()` from the library
2. **Custom Implementation**: Use individual components (`LocationViewModel`, `LocationData`) to build custom interfaces

### Troubleshooting

- **Location not updating**: Check that location permissions are granted
- **Compass not working**: Ensure the device has a magnetometer and is calibrated
- **Poor accuracy**: Move to an area with better GPS reception
- **App crashes**: Verify all required permissions are in Info.plist

### Building for Distribution

When building for the App Store:

1. Ensure all location permission descriptions clearly explain the app's purpose
2. Test on multiple device types and iOS versions
3. Handle edge cases like disabled location services
4. Consider battery usage implications for continuous tracking