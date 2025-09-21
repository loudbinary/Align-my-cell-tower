import SwiftUI
import CoreLocation
import Combine

/// AlignmentViewModel coordinates location, motion, and alignment calculations
/// Serves as the main data source for all views in the MVVM architecture
class AlignmentViewModel: ObservableObject {
    @Published var locationManager = LocationManager()
    @Published var motionManager = MotionManager()
    
    // Target location properties
    @Published var targetLocation: CLLocation?
    @Published var targetHeight: Double = 30.0 // Default cell tower height in meters
    
    // Calculated alignment properties
    @Published var azimuth: Double = 0.0
    @Published var tilt: Double = 0.0
    @Published var distance: Double = 0.0
    @Published var alignmentAccuracy: Double = 0.0
    
    // UI state
    @Published var isAligned: Bool = false
    @Published var showingLocationError: Bool = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    /// Set up reactive bindings between location, motion, and calculations
    private func setupBindings() {
        // Combine location and target to calculate alignment
        Publishers.CombineLatest3(
            locationManager.$currentLocation,
            $targetLocation,
            $targetHeight
        )
        .compactMap { currentLocation, targetLocation, height in
            guard let current = currentLocation, let target = targetLocation else { return nil }
            return (current, target, height)
        }
        .sink { [weak self] currentLocation, targetLocation, height in
            self?.updateAlignmentCalculations(from: currentLocation, to: targetLocation, height: height)
        }
        .store(in: &cancellables)
        
        // Update alignment accuracy when device heading changes
        Publishers.CombineLatest(
            motionManager.$deviceHeading,
            $azimuth
        )
        .sink { [weak self] deviceHeading, targetAzimuth in
            self?.updateAlignmentAccuracy(deviceHeading: deviceHeading, targetAzimuth: targetAzimuth)
        }
        .store(in: &cancellables)
        
        // Monitor location errors
        locationManager.$locationError
            .compactMap { $0 }
            .sink { [weak self] _ in
                self?.showingLocationError = true
            }
            .store(in: &cancellables)
    }
    
    /// Update all alignment calculations when location or target changes
    private func updateAlignmentCalculations(from currentLocation: CLLocation, to targetLocation: CLLocation, height: Double) {
        azimuth = AlignmentCalculator.calculateAzimuth(from: currentLocation, to: targetLocation)
        tilt = AlignmentCalculator.calculateTilt(from: currentLocation, to: targetLocation, targetHeight: height)
        distance = AlignmentCalculator.calculateDistance(from: currentLocation, to: targetLocation)
    }
    
    /// Update alignment accuracy based on device orientation
    private func updateAlignmentAccuracy(deviceHeading: Double, targetAzimuth: Double) {
        alignmentAccuracy = AlignmentCalculator.calculateAlignmentAccuracy(
            deviceHeading: deviceHeading,
            targetAzimuth: targetAzimuth
        )
        
        // Consider aligned if accuracy is above 90%
        isAligned = alignmentAccuracy > 90.0
    }
    
    /// Set the target location for alignment
    /// - Parameter location: CLLocation of the target (e.g., cell tower)
    func setTargetLocation(_ location: CLLocation) {
        targetLocation = location
    }
    
    /// Set the target location using coordinates
    /// - Parameters:
    ///   - latitude: Target latitude
    ///   - longitude: Target longitude
    func setTargetLocation(latitude: Double, longitude: Double) {
        let location = CLLocation(latitude: latitude, longitude: longitude)
        setTargetLocation(location)
    }
    
    /// Start location and motion updates
    func startLocationUpdates() {
        locationManager.startLocationUpdates()
    }
    
    /// Stop location updates
    func stopLocationUpdates() {
        locationManager.stopLocationUpdates()
    }
    
    /// Start motion updates
    func startMotionUpdates() {
        motionManager.startMotionUpdates()
    }
    
    /// Stop motion updates
    func stopMotionUpdates() {
        motionManager.stopMotionUpdates()
    }
    
    /// Get formatted distance string
    var formattedDistance: String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }
    
    /// Get formatted azimuth string with cardinal direction
    var formattedAzimuth: String {
        let direction = AlignmentCalculator.azimuthToCardinalDirection(azimuth)
        return "\(direction) \(String(format: "%.0f", azimuth))°"
    }
    
    /// Get formatted tilt string
    var formattedTilt: String {
        let direction = tilt >= 0 ? "↑" : "↓"
        return "\(direction) \(String(format: "%.1f", abs(tilt)))°"
    }
    
    /// Get alignment status color
    var alignmentColor: Color {
        switch alignmentAccuracy {
        case 90...100:
            return .green
        case 70..<90:
            return .yellow
        default:
            return .red
        }
    }
    
    /// Get alignment status text
    var alignmentStatus: String {
        switch alignmentAccuracy {
        case 90...100:
            return "ALIGNED"
        case 70..<90:
            return "CLOSE"
        default:
            return "ADJUST"
        }
    }
}