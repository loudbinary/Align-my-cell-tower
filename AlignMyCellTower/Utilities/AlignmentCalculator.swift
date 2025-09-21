import Foundation
import CoreLocation

/// Utility class for calculating alignment angles between locations
struct AlignmentCalculator {
    
    /// Calculates the azimuth (compass bearing) from source to target location
    /// - Parameters:
    ///   - source: The starting location
    ///   - target: The destination location
    /// - Returns: Azimuth in degrees (0-360, where 0 is North)
    static func calculateAzimuth(from source: LocationModel, to target: LocationModel) -> Double {
        let sourceLocation = source.location
        let targetLocation = target.location
        
        let lat1 = source.latitude * .pi / 180.0
        let lat2 = target.latitude * .pi / 180.0
        let deltaLon = (target.longitude - source.longitude) * .pi / 180.0
        
        let x = sin(deltaLon) * cos(lat2)
        let y = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(deltaLon)
        
        let bearing = atan2(x, y)
        let bearingDegrees = bearing * 180.0 / .pi
        
        // Normalize to 0-360 degrees
        return bearingDegrees >= 0 ? bearingDegrees : bearingDegrees + 360.0
    }
    
    /// Calculates the elevation angle from source to target location
    /// - Parameters:
    ///   - source: The starting location
    ///   - target: The destination location
    /// - Returns: Elevation angle in degrees (positive is upward, negative is downward)
    static func calculateElevation(from source: LocationModel, to target: LocationModel) -> Double {
        let sourceLocation = source.location
        let targetLocation = target.location
        
        // Calculate horizontal distance between points
        let horizontalDistance = sourceLocation.distance(from: targetLocation)
        
        // Calculate vertical distance (altitude difference)
        let sourceAltitude = source.altitude ?? 0
        let targetAltitude = target.altitude ?? 0
        let verticalDistance = targetAltitude - sourceAltitude
        
        // Calculate elevation angle using arctangent
        let elevationRadians = atan2(verticalDistance, horizontalDistance)
        return elevationRadians * 180.0 / .pi
    }
    
    /// Calculates the distance between two locations in meters
    /// - Parameters:
    ///   - source: The starting location
    ///   - target: The destination location
    /// - Returns: Distance in meters
    static func calculateDistance(from source: LocationModel, to target: LocationModel) -> Double {
        let sourceLocation = source.location
        let targetLocation = target.location
        return sourceLocation.distance(from: targetLocation)
    }
    
    /// Calculates both azimuth and elevation angles
    /// - Parameters:
    ///   - source: The starting location
    ///   - target: The destination location
    /// - Returns: A tuple containing (azimuth, elevation) in degrees
    static func calculateAlignment(from source: LocationModel, to target: LocationModel) -> (azimuth: Double, elevation: Double) {
        let azimuth = calculateAzimuth(from: source, to: target)
        let elevation = calculateElevation(from: source, to: target)
        return (azimuth, elevation)
    }
    
    /// Formats an angle to a readable string with specified decimal places
    /// - Parameters:
    ///   - angle: The angle in degrees
    ///   - decimalPlaces: Number of decimal places to show
    /// - Returns: Formatted string
    static func formatAngle(_ angle: Double, decimalPlaces: Int = 1) -> String {
        return String(format: "%.\(decimalPlaces)f°", angle)
    }
    
    /// Converts compass bearing to cardinal direction
    /// - Parameter bearing: Bearing in degrees (0-360)
    /// - Returns: Cardinal direction string (N, NE, E, SE, S, SW, W, NW)
    static func bearingToCardinal(_ bearing: Double) -> String {
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((bearing + 22.5) / 45.0) % 8
        return directions[index]
    }
}