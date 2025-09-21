import SwiftUI
import AlignMyCellTower

/// Example iOS app demonstrating AlignMyCellTower usage
@main
struct ExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light) // You can change this as needed
        }
    }
}

/// Alternative custom implementation showing how to use individual components
struct CustomExampleView: View {
    @StateObject private var locationViewModel = LocationViewModel()
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Custom Cell Tower Alignment")
                .font(.largeTitle)
                .fontWeight(.bold)
            
            if locationViewModel.hasValidLocationData {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Current Location:")
                        .font(.headline)
                    
                    Text("Coordinates: \(locationViewModel.coordinatesDisplayString)")
                    Text("Altitude: \(locationViewModel.altitudeDisplayString)")
                    
                    if locationViewModel.hasValidHeadingData {
                        Text("Heading: \(locationViewModel.headingDisplayString)")
                        Text("Direction: \(locationViewModel.compassDirectionString)")
                    }
                }
                .padding()
                .background(Color.blue.opacity(0.1))
                .cornerRadius(10)
            } else {
                Text("No location data available")
                    .foregroundColor(.secondary)
            }
            
            Button(action: {
                locationViewModel.toggleLocationTracking()
            }) {
                Text(locationViewModel.isTrackingLocation ? "Stop Tracking" : "Start Tracking")
                    .padding()
                    .background(locationViewModel.isTrackingLocation ? Color.red : Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(!locationViewModel.isLocationAuthorized)
            
            if !locationViewModel.isLocationAuthorized {
                Button("Request Location Permission") {
                    locationViewModel.requestLocationPermission()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(8)
            }
            
            Spacer()
        }
        .padding()
        .onAppear {
            locationViewModel.requestLocationPermission()
        }
    }
}