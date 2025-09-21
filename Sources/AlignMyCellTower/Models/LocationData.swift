import Foundation
#if canImport(CoreLocation)
import CoreLocation
#endif

/// Model representing location data including GPS coordinates and compass heading
public struct LocationData {
    /// Current GPS latitude coordinate
    public let latitude: Double
    
    /// Current GPS longitude coordinate  
    public let longitude: Double
    
    /// Altitude in meters above sea level
    public let altitude: Double
    
    /// Horizontal accuracy of the location in meters
    public let horizontalAccuracy: Double
    
    /// Vertical accuracy of the location in meters
    public let verticalAccuracy: Double
    
    /// Compass heading in degrees (0-359.99) where 0 is magnetic north
    public let heading: Double?
    
    /// Heading accuracy in degrees
    public let headingAccuracy: Double?
    
    /// Timestamp when the location was recorded
    public let timestamp: Date
    
    /// Initialize LocationData with coordinate and heading information
    /// - Parameters:
    ///   - latitude: GPS latitude coordinate
    ///   - longitude: GPS longitude coordinate
    ///   - altitude: Altitude in meters
    ///   - horizontalAccuracy: Horizontal accuracy in meters
    ///   - verticalAccuracy: Vertical accuracy in meters
    ///   - heading: Compass heading in degrees (optional)
    ///   - headingAccuracy: Heading accuracy in degrees (optional)
    ///   - timestamp: When the data was recorded
    public init(
        latitude: Double,
        longitude: Double,
        altitude: Double,
        horizontalAccuracy: Double,
        verticalAccuracy: Double,
        heading: Double? = nil,
        headingAccuracy: Double? = nil,
        timestamp: Date = Date()
    ) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.horizontalAccuracy = horizontalAccuracy
        self.verticalAccuracy = verticalAccuracy
        self.heading = heading
        self.headingAccuracy = headingAccuracy
        self.timestamp = timestamp
    }
    
    #if canImport(CoreLocation)
    /// Convenience initializer from CLLocation and optional CLHeading
    /// - Parameters:
    ///   - location: Core Location CLLocation object
    ///   - heading: Core Location CLHeading object (optional)
    public init(from location: CLLocation, heading: CLHeading? = nil) {
        self.latitude = location.coordinate.latitude
        self.longitude = location.coordinate.longitude
        self.altitude = location.altitude
        self.horizontalAccuracy = location.horizontalAccuracy
        self.verticalAccuracy = location.verticalAccuracy
        self.heading = heading?.magneticHeading
        self.headingAccuracy = heading?.headingAccuracy
        self.timestamp = location.timestamp
    }
    #endif
}

/// Extension to make LocationData conform to Equatable for testing
extension LocationData: Equatable {
    public static func == (lhs: LocationData, rhs: LocationData) -> Bool {
        return lhs.latitude == rhs.latitude &&
               lhs.longitude == rhs.longitude &&
               lhs.altitude == rhs.altitude &&
               lhs.heading == rhs.heading &&
               lhs.timestamp == rhs.timestamp
    }
}

/// Extension with computed properties for display formatting
extension LocationData {
    /// Formatted latitude string with precision
    public var formattedLatitude: String {
        return String(format: "%.6f°", latitude)
    }
    
    /// Formatted longitude string with precision
    public var formattedLongitude: String {
        return String(format: "%.6f°", longitude)
    }
    
    /// Formatted altitude string with units
    public var formattedAltitude: String {
        return String(format: "%.1f m", altitude)
    }
    
    /// Formatted heading string with direction
    public var formattedHeading: String {
        guard let heading = heading else { return "No heading" }
        return String(format: "%.1f°", heading)
    }
    
    /// Compass direction as string (N, NE, E, SE, S, SW, W, NW)
    public var compassDirection: String {
        guard let heading = heading else { return "Unknown" }
        
        let directions = ["N", "NE", "E", "SE", "S", "SW", "W", "NW"]
        let index = Int((heading + 22.5) / 45.0) % 8
        return directions[index]
    }
}