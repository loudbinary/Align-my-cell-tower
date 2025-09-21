import XCTest
@testable import AlignMyCellTower

#if canImport(CoreLocation)
import CoreLocation
#endif

/// Test suite for LocationData model
final class LocationDataTests: XCTestCase {
    
    func testLocationDataInitialization() {
        // Given
        let latitude = 37.7749
        let longitude = -122.4194
        let altitude = 10.0
        let horizontalAccuracy = 5.0
        let verticalAccuracy = 10.0
        let heading = 45.0
        let headingAccuracy = 2.0
        let timestamp = Date()
        
        // When
        let locationData = LocationData(
            latitude: latitude,
            longitude: longitude,
            altitude: altitude,
            horizontalAccuracy: horizontalAccuracy,
            verticalAccuracy: verticalAccuracy,
            heading: heading,
            headingAccuracy: headingAccuracy,
            timestamp: timestamp
        )
        
        // Then
        XCTAssertEqual(locationData.latitude, latitude)
        XCTAssertEqual(locationData.longitude, longitude)
        XCTAssertEqual(locationData.altitude, altitude)
        XCTAssertEqual(locationData.horizontalAccuracy, horizontalAccuracy)
        XCTAssertEqual(locationData.verticalAccuracy, verticalAccuracy)
        XCTAssertEqual(locationData.heading, heading)
        XCTAssertEqual(locationData.headingAccuracy, headingAccuracy)
        XCTAssertEqual(locationData.timestamp, timestamp)
    }
    
    #if canImport(CoreLocation)
    func testLocationDataFromCLLocation() {
        // Given
        let coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        let clLocation = CLLocation(
            coordinate: coordinate,
            altitude: 10.0,
            horizontalAccuracy: 5.0,
            verticalAccuracy: 10.0,
            timestamp: Date()
        )
        
        // When
        let locationData = LocationData(from: clLocation)
        
        // Then
        XCTAssertEqual(locationData.latitude, clLocation.coordinate.latitude)
        XCTAssertEqual(locationData.longitude, clLocation.coordinate.longitude)
        XCTAssertEqual(locationData.altitude, clLocation.altitude)
        XCTAssertEqual(locationData.horizontalAccuracy, clLocation.horizontalAccuracy)
        XCTAssertEqual(locationData.verticalAccuracy, clLocation.verticalAccuracy)
        XCTAssertNil(locationData.heading)
        XCTAssertNil(locationData.headingAccuracy)
    }
    #endif
    
    func testFormattedProperties() {
        // Given
        let locationData = LocationData(
            latitude: 37.774929,
            longitude: -122.419416,
            altitude: 10.5,
            horizontalAccuracy: 5.0,
            verticalAccuracy: 10.0,
            heading: 45.7
        )
        
        // When & Then
        XCTAssertEqual(locationData.formattedLatitude, "37.774929°")
        XCTAssertEqual(locationData.formattedLongitude, "-122.419416°")
        XCTAssertEqual(locationData.formattedAltitude, "10.5 m")
        XCTAssertEqual(locationData.formattedHeading, "45.7°")
    }
    
    func testCompassDirection() {
        // Test various headings and their corresponding compass directions
        let testCases: [(heading: Double, expected: String)] = [
            (0.0, "N"),
            (45.0, "NE"),
            (90.0, "E"),
            (135.0, "SE"),
            (180.0, "S"),
            (225.0, "SW"),
            (270.0, "W"),
            (315.0, "NW"),
            (360.0, "N")
        ]
        
        for testCase in testCases {
            // Given
            let locationData = LocationData(
                latitude: 0,
                longitude: 0,
                altitude: 0,
                horizontalAccuracy: 0,
                verticalAccuracy: 0,
                heading: testCase.heading
            )
            
            // When & Then
            XCTAssertEqual(locationData.compassDirection, testCase.expected, 
                          "Heading \(testCase.heading) should be \(testCase.expected)")
        }
    }
    
    func testEquality() {
        // Given
        let timestamp = Date()
        let locationData1 = LocationData(
            latitude: 37.7749,
            longitude: -122.4194,
            altitude: 10.0,
            horizontalAccuracy: 5.0,
            verticalAccuracy: 10.0,
            heading: 45.0,
            headingAccuracy: 2.0,
            timestamp: timestamp
        )
        
        let locationData2 = LocationData(
            latitude: 37.7749,
            longitude: -122.4194,
            altitude: 10.0,
            horizontalAccuracy: 5.0,
            verticalAccuracy: 10.0,
            heading: 45.0,
            headingAccuracy: 2.0,
            timestamp: timestamp
        )
        
        let locationData3 = LocationData(
            latitude: 37.7750, // Different latitude
            longitude: -122.4194,
            altitude: 10.0,
            horizontalAccuracy: 5.0,
            verticalAccuracy: 10.0,
            heading: 45.0,
            headingAccuracy: 2.0,
            timestamp: timestamp
        )
        
        // When & Then
        XCTAssertEqual(locationData1, locationData2)
        XCTAssertNotEqual(locationData1, locationData3)
    }
}