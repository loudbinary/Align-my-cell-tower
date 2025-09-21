import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var locationManager = LocationManager()
    @StateObject private var motionManager = MotionManager()
    @State private var targetLocation: LocationModel?
    @State private var showingMapView = false
    @State private var targetLatitude = ""
    @State private var targetLongitude = ""
    @State private var targetAltitude = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Header
                    headerSection
                    
                    // Current Location Section
                    currentLocationSection
                    
                    // Target Location Section
                    targetLocationSection
                    
                    // Alignment Information Section
                    if let current = locationManager.currentLocation,
                       let target = targetLocation {
                        alignmentSection(current: current, target: target)
                    }
                    
                    // Motion Data Section
                    motionSection
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Cell Tower Alignment")
            .navigationBarTitleDisplayMode(.large)
            .onAppear {
                locationManager.requestLocationPermission()
                motionManager.startMotionUpdates()
            }
            .onDisappear {
                motionManager.stopMotionUpdates()
            }
            .sheet(isPresented: $showingMapView) {
                MapView(selectedLocation: $targetLocation)
            }
        }
    }
    
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 40))
                .foregroundColor(.blue)
            
            Text("Align your device to point directly at your target location")
                .font(.subheadline)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var currentLocationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.green)
                Text("Current Location")
                    .font(.headline)
                Spacer()
                
                if locationManager.isLocationAvailable {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            
            if let location = locationManager.currentLocation {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Latitude: \(location.latitude, specifier: "%.6f")")
                    Text("Longitude: \(location.longitude, specifier: "%.6f")")
                    if let altitude = location.altitude {
                        Text("Altitude: \(altitude, specifier: "%.1f") m")
                    }
                }
                .font(.caption)
                .foregroundColor(.secondary)
            } else {
                Text(locationManager.errorMessage ?? "Waiting for location...")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var targetLocationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "target")
                    .foregroundColor(.blue)
                Text("Target Location")
                    .font(.headline)
                Spacer()
            }
            
            // Manual input fields
            VStack(spacing: 8) {
                HStack {
                    Text("Latitude:")
                        .frame(width: 80, alignment: .leading)
                    TextField("e.g., 37.7749", text: $targetLatitude)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Longitude:")
                        .frame(width: 80, alignment: .leading)
                    TextField("e.g., -122.4194", text: $targetLongitude)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
                
                HStack {
                    Text("Altitude:")
                        .frame(width: 80, alignment: .leading)
                    TextField("e.g., 100 (optional)", text: $targetAltitude)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .keyboardType(.decimalPad)
                }
            }
            .font(.caption)
            
            // Buttons
            HStack {
                Button("Select on Map") {
                    showingMapView = true
                }
                .buttonStyle(.borderedProminent)
                
                Spacer()
                
                Button("Set Target") {
                    setTargetFromInput()
                }
                .buttonStyle(.bordered)
                .disabled(targetLatitude.isEmpty || targetLongitude.isEmpty)
            }
            
            // Display current target
            if let target = targetLocation {
                Divider()
                VStack(alignment: .leading, spacing: 4) {
                    Text("Current Target:")
                        .font(.caption)
                        .fontWeight(.semibold)
                    Text("Lat: \(target.latitude, specifier: "%.6f"), Lon: \(target.longitude, specifier: "%.6f")")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func alignmentSection(current: LocationModel, target: LocationModel) -> some View {
        let alignment = AlignmentCalculator.calculateAlignment(from: current, to: target)
        let distance = AlignmentCalculator.calculateDistance(from: current, to: target)
        
        return VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "compass.drawing")
                    .foregroundColor(.orange)
                Text("Alignment Information")
                    .font(.headline)
                Spacer()
            }
            
            VStack(spacing: 16) {
                // Azimuth
                VStack {
                    Text("AZIMUTH (Direction)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text("\(AlignmentCalculator.formatAngle(alignment.azimuth))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                    
                    Text(AlignmentCalculator.bearingToCardinal(alignment.azimuth))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(8)
                
                // Elevation
                VStack {
                    Text("ELEVATION (Tilt)")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text("\(AlignmentCalculator.formatAngle(alignment.elevation))")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    
                    Text(alignment.elevation > 0 ? "Look Up" : alignment.elevation < 0 ? "Look Down" : "Level")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green.opacity(0.1))
                .cornerRadius(8)
                
                // Distance
                VStack {
                    Text("DISTANCE")
                        .font(.caption)
                        .fontWeight(.semibold)
                        .foregroundColor(.secondary)
                    
                    Text(formatDistance(distance))
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.purple)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(8)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private var motionSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: "gyroscope")
                    .foregroundColor(.red)
                Text("Device Orientation")
                    .font(.headline)
                Spacer()
                
                if motionManager.isMotionAvailable {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                } else {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.red)
                }
            }
            
            if motionManager.isMotionAvailable {
                HStack(spacing: 20) {
                    VStack {
                        Text("Heading")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(motionManager.heading, specifier: "%.1f")°")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack {
                        Text("Pitch")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(motionManager.pitch, specifier: "%.1f")°")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                    
                    VStack {
                        Text("Roll")
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Text("\(motionManager.roll, specifier: "%.1f")°")
                            .font(.title3)
                            .fontWeight(.semibold)
                    }
                }
                .frame(maxWidth: .infinity)
            } else {
                Text(motionManager.errorMessage ?? "Motion sensors not available")
                    .font(.caption)
                    .foregroundColor(.red)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
    
    private func setTargetFromInput() {
        guard let lat = Double(targetLatitude),
              let lon = Double(targetLongitude),
              lat >= -90, lat <= 90,
              lon >= -180, lon <= 180 else {
            return
        }
        
        let altitude = Double(targetAltitude)
        targetLocation = LocationModel(
            latitude: lat,
            longitude: lon,
            altitude: altitude,
            name: "Target Location"
        )
    }
    
    private func formatDistance(_ distance: Double) -> String {
        if distance < 1000 {
            return String(format: "%.0f m", distance)
        } else {
            return String(format: "%.1f km", distance / 1000)
        }
    }
}

#Preview {
    HomeView()
}