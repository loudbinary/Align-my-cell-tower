#if canImport(CoreLocation)
import Foundation
import Combine
import CoreLocation

/// ViewModel for managing location data and providing it to SwiftUI views
@MainActor
public class LocationViewModel: ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current location data
    @Published public private(set) var locationData: LocationData?
    
    /// Whether location services are authorized and working
    @Published public private(set) var isLocationAuthorized: Bool = false
    
    /// Whether location updates are currently active
    @Published public private(set) var isTrackingLocation: Bool = false
    
    /// Current error message to display to user
    @Published public private(set) var errorMessage: String?
    
    /// Status information for debugging
    @Published public private(set) var statusMessage: String = "Initializing..."
    
    // MARK: - Private Properties
    
    /// Location manager instance
    private let locationManager = LocationManager()
    
    /// Set to store Combine cancellables
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initialization
    
    public init() {
        setupBindings()
    }
    
    // MARK: - Setup
    
    /// Set up Combine bindings to observe location manager changes
    private func setupBindings() {
        // Observe location updates
        locationManager.$currentLocation
            .receive(on: DispatchQueue.main)
            .assign(to: &$locationData)
        
        // Observe authorization status
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .map { status in
                status == .authorizedWhenInUse || status == .authorizedAlways
            }
            .assign(to: &$isLocationAuthorized)
        
        // Observe error messages
        locationManager.$errorMessage
            .receive(on: DispatchQueue.main)
            .assign(to: &$errorMessage)
        
        // Observe location services status
        locationManager.$isLocationServicesEnabled
            .receive(on: DispatchQueue.main)
            .sink { [weak self] isEnabled in
                self?.updateStatusMessage()
            }
            .store(in: &cancellables)
        
        // Update status when authorization changes
        locationManager.$authorizationStatus
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.updateStatusMessage()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Public Methods
    
    /// Request location permission from the user
    public func requestLocationPermission() {
        locationManager.requestLocationPermission()
        updateStatusMessage()
    }
    
    /// Start tracking location updates
    public func startLocationTracking() {
        guard isLocationAuthorized else {
            requestLocationPermission()
            return
        }
        
        locationManager.startLocationUpdates()
        isTrackingLocation = true
        updateStatusMessage()
    }
    
    /// Stop tracking location updates
    public func stopLocationTracking() {
        locationManager.stopLocationUpdates()
        isTrackingLocation = false
        updateStatusMessage()
    }
    
    /// Toggle location tracking on/off
    public func toggleLocationTracking() {
        if isTrackingLocation {
            stopLocationTracking()
        } else {
            startLocationTracking()
        }
    }
    
    /// Get detailed status information for debugging
    public func getDetailedStatus() -> String {
        return locationManager.getLocationStatus()
    }
    
    // MARK: - Computed Properties
    
    /// Whether the device supports compass/heading updates
    public var isHeadingSupported: Bool {
        return locationManager.isHeadingAvailable
    }
    
    /// Formatted display string for current coordinates
    public var coordinatesDisplayString: String {
        guard let location = locationData else {
            return "No location data"
        }
        return "\(location.formattedLatitude), \(location.formattedLongitude)"
    }
    
    /// Formatted display string for current altitude
    public var altitudeDisplayString: String {
        guard let location = locationData else {
            return "No altitude data"
        }
        return location.formattedAltitude
    }
    
    /// Formatted display string for current heading
    public var headingDisplayString: String {
        guard let location = locationData else {
            return "No heading data"
        }
        return location.formattedHeading
    }
    
    /// Compass direction string
    public var compassDirectionString: String {
        guard let location = locationData else {
            return "Unknown"
        }
        return location.compassDirection
    }
    
    /// Accuracy information string
    public var accuracyDisplayString: String {
        guard let location = locationData else {
            return "No accuracy data"
        }
        return String(format: "±%.1fm", location.horizontalAccuracy)
    }
    
    // MARK: - Private Methods
    
    /// Update the status message based on current state
    private func updateStatusMessage() {
        if !locationManager.isLocationServicesEnabled {
            statusMessage = "Location services disabled"
        } else if !isLocationAuthorized {
            statusMessage = "Location permission required"
        } else if isTrackingLocation {
            statusMessage = "Tracking location..."
        } else {
            statusMessage = "Ready to track location"
        }
    }
}

// MARK: - Convenience Extensions

extension LocationViewModel {
    
    /// Helper to check if we have valid location data
    public var hasValidLocationData: Bool {
        return locationData != nil
    }
    
    /// Helper to check if we have valid heading data
    public var hasValidHeadingData: Bool {
        return locationData?.heading != nil
    }
    
    /// Get location age in seconds
    public var locationAge: TimeInterval? {
        guard let location = locationData else { return nil }
        return Date().timeIntervalSince(location.timestamp)
    }
    
    /// Check if location data is recent (less than 10 seconds old)
    public var isLocationDataFresh: Bool {
        guard let age = locationAge else { return false }
        return age < 10.0
    }
}
#endif