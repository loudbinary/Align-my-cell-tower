import CoreLocation
import Foundation

/// AlignmentCalculator provides utilities for calculating azimuth and tilt angles
/// between current position and target GPS coordinates
struct AlignmentCalculator {
    
    /// Calculate the azimuth (bearing) from current location to target location
    /// - Parameters:
    ///   - from: Current location
    ///   - to: Target location
    /// - Returns: Azimuth in degrees (0-360, where 0 is North)
    static func calculateAzimuth(from currentLocation: CLLocation, to targetLocation: CLLocation) -> Double {
        let fromLatitude = currentLocation.coordinate.latitude.degreesToRadians
        let fromLongitude = currentLocation.coordinate.longitude.degreesToRadians
        let toLatitude = targetLocation.coordinate.latitude.degreesToRadians
        let toLongitude = targetLocation.coordinate.longitude.degreesToRadians
        
        let deltaLongitude = toLongitude - fromLongitude
        
        let x = sin(deltaLongitude) * cos(toLatitude)
        let y = cos(fromLatitude) * sin(toLatitude) - sin(fromLatitude) * cos(toLatitude) * cos(deltaLongitude)
        
        let bearing = atan2(x, y)
        
        // Convert from radians to degrees and normalize to 0-360
        let bearingDegrees = bearing.radiansToDegrees
        return bearingDegrees < 0 ? bearingDegrees + 360 : bearingDegrees
    }
    
    /// Calculate the tilt angle from current location to target location
    /// - Parameters:
    ///   - from: Current location
    ///   - to: Target location
    ///   - targetHeight: Height of the target above ground level in meters
    /// - Returns: Tilt angle in degrees (positive for upward tilt, negative for downward)
    static func calculateTilt(from currentLocation: CLLocation, to targetLocation: CLLocation, targetHeight: Double) -> Double {
        let distance = currentLocation.distance(from: targetLocation)
        let altitudeDifference = targetLocation.altitude - currentLocation.altitude + targetHeight
        
        // Avoid division by zero
        guard distance > 0 else { return 0 }
        
        let tiltRadians = atan(altitudeDifference / distance)
        return tiltRadians.radiansToDegrees
    }
    
    /// Calculate the distance between two locations
    /// - Parameters:
    ///   - from: Starting location
    ///   - to: Destination location
    /// - Returns: Distance in meters
    static func calculateDistance(from currentLocation: CLLocation, to targetLocation: CLLocation) -> Double {
        return currentLocation.distance(from: targetLocation)
    }
    
    /// Calculate alignment accuracy based on device orientation vs target direction
    /// - Parameters:
    ///   - deviceHeading: Current device heading in degrees
    ///   - targetAzimuth: Target azimuth in degrees
    /// - Returns: Alignment accuracy as a percentage (0-100)
    static func calculateAlignmentAccuracy(deviceHeading: Double, targetAzimuth: Double) -> Double {
        let headingDifference = abs(deviceHeading - targetAzimuth)
        let normalizedDifference = min(headingDifference, 360 - headingDifference)
        
        // Convert to accuracy percentage (180° difference = 0%, 0° difference = 100%)
        let accuracy = max(0, 100 - (normalizedDifference / 180.0 * 100))
        return accuracy
    }
    
    /// Convert azimuth to cardinal direction string
    /// - Parameter azimuth: Azimuth in degrees
    /// - Returns: Cardinal direction (N, NE, E, SE, S, SW, W, NW)
    static func azimuthToCardinalDirection(_ azimuth: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((azimuth + 22.5) / 45.0) % 8
        return directions[index]
    }
}

// MARK: - Extensions for angle conversions
extension Double {
    var degreesToRadians: Double {
        return self * .pi / 180.0
    }
    
    var radiansToDegrees: Double {
        return self * 180.0 / .pi
    }
}