#if canImport(SwiftUI)
import SwiftUI
#endif

/// Main library file for AlignMyCellTower
/// 
/// This library provides a complete Swift/SwiftUI solution for location-based applications
/// that need to display GPS coordinates and compass heading information in real-time.
/// 
/// Key Features:
/// - Real-time GPS coordinate tracking
/// - Compass heading (azimuth) display
/// - Modern SwiftUI interface
/// - Core Location integration
/// - Permission handling
/// - Error management
/// 
/// Example Usage:
/// ```swift
/// import AlignMyCellTower
/// 
/// struct MyApp: App {
///     var body: some Scene {
///         WindowGroup {
///             ContentView()
///         }
///     }
/// }
/// ```

#if canImport(SwiftUI) && canImport(CoreLocation)
// MARK: - App Entry Point

/// Sample app structure for demonstration
@available(iOS 15.0, macOS 12.0, *)
public struct AlignMyCellTowerApp: App {
    public var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    
    public init() {}
}
#endif