import SwiftUI
import MapKit

struct MapView: View {
    @Binding var selectedLocation: LocationModel?
    @Environment(\.dismiss) private var dismiss
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var showingAltitudeInput = false
    @State private var altitudeText = ""
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                    MapPin(coordinate: annotation.coordinate, tint: .red)
                }
                .onTapGesture { location in
                    // Convert tap location to coordinate
                    let coordinate = convertTapToCoordinate(location)
                    selectedCoordinate = coordinate
                    showingAltitudeInput = true
                }
                
                // Crosshairs in center of map
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "plus")
                            .font(.title)
                            .foregroundColor(.red)
                        Spacer()
                    }
                    Spacer()
                }
                .allowsHitTesting(false)
            }
            .navigationTitle("Select Target Location")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Select Center") {
                        selectedCoordinate = region.center
                        showingAltitudeInput = true
                    }
                    .fontWeight(.semibold)
                }
            }
            .alert("Set Altitude", isPresented: $showingAltitudeInput) {
                TextField("Altitude in meters (optional)", text: $altitudeText)
                    .keyboardType(.decimalPad)
                
                Button("Confirm") {
                    confirmSelection()
                }
                
                Button("Cancel", role: .cancel) {
                    selectedCoordinate = nil
                    altitudeText = ""
                }
            } message: {
                if let coordinate = selectedCoordinate {
                    Text("Location: \(coordinate.latitude, specifier: "%.6f"), \(coordinate.longitude, specifier: "%.6f")")
                }
            }
        }
    }
    
    private var annotations: [LocationAnnotation] {
        guard let coordinate = selectedCoordinate else { return [] }
        return [LocationAnnotation(coordinate: coordinate)]
    }
    
    private func convertTapToCoordinate(_ location: CGPoint) -> CLLocationCoordinate2D {
        // This is a simplified conversion - in a real app, you'd use proper map coordinate conversion
        // For now, we'll use the center of the map as the selected coordinate
        return region.center
    }
    
    private func confirmSelection() {
        guard let coordinate = selectedCoordinate else { return }
        
        let altitude = Double(altitudeText)
        selectedLocation = LocationModel(
            coordinate: coordinate,
            altitude: altitude,
            name: "Selected Target"
        )
        
        dismiss()
    }
}

struct LocationAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

#Preview {
    MapView(selectedLocation: .constant(nil))
}