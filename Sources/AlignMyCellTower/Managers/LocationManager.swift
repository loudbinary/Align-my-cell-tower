#if canImport(CoreLocation)
import Foundation
import CoreLocation
import Combine

/// Manager class responsible for handling Core Location services including GPS and compass data
@MainActor
public class LocationManager: NSObject, ObservableObject {
    
    // MARK: - Published Properties
    
    /// Current location data including GPS coordinates and compass heading
    @Published public private(set) var currentLocation: LocationData?
    
    /// Current authorization status for location services
    @Published public private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    
    /// Whether location services are currently active
    @Published public private(set) var isLocationServicesEnabled: Bool = false
    
    /// Error message for display to user
    @Published public private(set) var errorMessage: String?
    
    // MARK: - Private Properties
    
    /// Core Location manager instance
    private let locationManager = CLLocationManager()
    
    /// Current compass heading data
    private var currentHeading: CLHeading?
    
    /// Whether heading updates are available on this device
    public var isHeadingAvailable: Bool {
        return CLLocationManager.headingAvailable()
    }
    
    // MARK: - Initialization
    
    public override init() {
        super.init()
        setupLocationManager()
    }
    
    // MARK: - Setup
    
    /// Configure the location manager with appropriate settings
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 1.0 // Update every meter
        
        // Check if location services are enabled
        isLocationServicesEnabled = CLLocationManager.locationServicesEnabled()
        
        // Set initial authorization status
        authorizationStatus = locationManager.authorizationStatus
    }
    
    // MARK: - Public Methods
    
    /// Request permission to access location services
    public func requestLocationPermission() {
        switch authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            errorMessage = "Location access denied. Please enable location services in Settings."
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        @unknown default:
            break
        }
    }
    
    /// Start receiving location and heading updates
    public func startLocationUpdates() {
        guard isLocationServicesEnabled else {
            errorMessage = "Location services are not enabled on this device."
            return
        }
        
        guard authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways else {
            requestLocationPermission()
            return
        }
        
        // Clear any previous error messages
        errorMessage = nil
        
        // Start location updates
        locationManager.startUpdatingLocation()
        
        // Start heading updates if available
        if isHeadingAvailable {
            locationManager.startUpdatingHeading()
        }
    }
    
    /// Stop receiving location and heading updates
    public func stopLocationUpdates() {
        locationManager.stopUpdatingLocation()
        if isHeadingAvailable {
            locationManager.stopUpdatingHeading()
        }
    }
    
    /// Get current location status for debugging
    public func getLocationStatus() -> String {
        var status = "Location Services: \(isLocationServicesEnabled ? "Enabled" : "Disabled")\n"
        status += "Authorization: \(authorizationStatusString)\n"
        status += "Heading Available: \(isHeadingAvailable ? "Yes" : "No")\n"
        
        if let location = currentLocation {
            status += "Last Update: \(location.timestamp)\n"
            status += "Accuracy: H:\(location.horizontalAccuracy)m V:\(location.verticalAccuracy)m"
        } else {
            status += "No location data available"
        }
        
        return status
    }
    
    // MARK: - Private Helpers
    
    /// Convert authorization status to readable string
    private var authorizationStatusString: String {
        switch authorizationStatus {
        case .notDetermined: return "Not Determined"
        case .restricted: return "Restricted"
        case .denied: return "Denied"
        case .authorizedAlways: return "Authorized Always"
        case .authorizedWhenInUse: return "Authorized When In Use"
        @unknown default: return "Unknown"
        }
    }
    
    /// Update the current location data by combining location and heading
    private func updateLocationData(from location: CLLocation) {
        let locationData = LocationData(from: location, heading: currentHeading)
        currentLocation = locationData
    }
}

// MARK: - CLLocationManagerDelegate

extension LocationManager: CLLocationManagerDelegate {
    
    /// Handle authorization status changes
    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        authorizationStatus = manager.authorizationStatus
        
        switch authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startLocationUpdates()
        case .denied, .restricted:
            errorMessage = "Location access denied. Please enable location services in Settings."
            stopLocationUpdates()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    /// Handle new location updates
    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Filter out old or inaccurate readings
        guard location.timestamp.timeIntervalSinceNow > -5.0 else { return }
        guard location.horizontalAccuracy < 100 else { return }
        
        updateLocationData(from: location)
    }
    
    /// Handle location update errors
    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        errorMessage = "Location update failed: \(error.localizedDescription)"
    }
    
    /// Handle new heading updates
    public func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        // Filter out inaccurate headings
        guard newHeading.headingAccuracy >= 0 else { return }
        
        currentHeading = newHeading
        
        // Update location data with new heading if we have a location
        if let lastLocation = locationManager.location {
            updateLocationData(from: lastLocation)
        }
    }
}
#endif