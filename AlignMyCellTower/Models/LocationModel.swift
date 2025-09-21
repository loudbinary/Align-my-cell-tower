import Foundation
import CoreLocation

/// Represents a location with coordinates and optional height/name
struct LocationModel: Identifiable, Codable {
    let id = UUID()
    var latitude: Double
    var longitude: Double
    var altitude: Double?
    var name: String?
    
    init(latitude: Double, longitude: Double, altitude: Double? = nil, name: String? = nil) {
        self.latitude = latitude
        self.longitude = longitude
        self.altitude = altitude
        self.name = name
    }
    
    init(coordinate: CLLocationCoordinate2D, altitude: Double? = nil, name: String? = nil) {
        self.latitude = coordinate.latitude
        self.longitude = coordinate.longitude
        self.altitude = altitude
        self.name = name
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var location: CLLocation {
        CLLocation(
            coordinate: coordinate,
            altitude: altitude ?? 0,
            horizontalAccuracy: 1,
            verticalAccuracy: 1,
            timestamp: Date()
        )
    }
}