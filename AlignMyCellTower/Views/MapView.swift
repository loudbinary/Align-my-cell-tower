import SwiftUI
import MapKit

/// MapView allows users to select target locations by dropping pins
/// Displays current location and target location on an interactive map
struct MapView: View {
    @ObservableObject var viewModel: AlignmentViewModel
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @State private var showingHeightAlert = false
    @State private var tempTargetCoordinate: CLLocationCoordinate2D?
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .bottom) {
                // Map with annotations
                Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
                    MapAnnotation(coordinate: annotation.coordinate) {
                        annotationView(for: annotation)
                    }
                }
                .onTapGesture { location in
                    handleMapTap(at: location)
                }
                .onReceive(viewModel.locationManager.$currentLocation) { location in
                    updateRegionForCurrentLocation(location)
                }
                
                // Info panel
                if viewModel.targetLocation != nil {
                    VStack {
                        Spacer()
                        infoPanel
                    }
                }
            }
            .navigationTitle("Select Target")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Center") {
                        centerOnCurrentLocation()
                    }
                }
            }
            .alert("Set Tower Height", isPresented: $showingHeightAlert) {
                TextField("Height in meters", value: $viewModel.targetHeight, format: .number)
                    .keyboardType(.decimalPad)
                Button("Set Target") {
                    if let coordinate = tempTargetCoordinate {
                        setTargetLocation(coordinate: coordinate)
                    }
                }
                Button("Cancel", role: .cancel) { }
            } message: {
                Text("Enter the height of the cell tower in meters.")
            }
        }
    }
    
    /// Get annotations for the map
    private var annotations: [MapAnnotation] {
        var items: [MapAnnotation] = []
        
        // Current location annotation
        if let currentLocation = viewModel.locationManager.currentLocation {
            items.append(MapAnnotation(
                id: "current",
                coordinate: currentLocation.coordinate,
                type: .current
            ))
        }
        
        // Target location annotation
        if let targetLocation = viewModel.targetLocation {
            items.append(MapAnnotation(
                id: "target",
                coordinate: targetLocation.coordinate,
                type: .target
            ))
        }
        
        return items
    }
    
    /// Create annotation view based on type
    @ViewBuilder
    private func annotationView(for annotation: MapAnnotation) -> some View {
        switch annotation.type {
        case .current:
            Circle()
                .fill(Color.blue)
                .frame(width: 20, height: 20)
                .overlay {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                }
        case .target:
            Image(systemName: "antenna.radiowaves.left.and.right")
                .foregroundColor(.red)
                .font(.title2)
                .background {
                    Circle()
                        .fill(Color.white)
                        .frame(width: 30, height: 30)
                }
        }
    }
    
    /// Info panel showing target details
    private var infoPanel: some View {
        VStack(spacing: 8) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Target Information")
                        .font(.headline)
                    
                    if viewModel.distance > 0 {
                        HStack {
                            Text("Distance:")
                            Spacer()
                            Text(viewModel.formattedDistance)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Direction:")
                            Spacer()
                            Text(viewModel.formattedAzimuth)
                                .foregroundColor(.secondary)
                        }
                        
                        HStack {
                            Text("Tower Height:")
                            Spacer()
                            Text("\(String(format: "%.0f", viewModel.targetHeight)) m")
                                .foregroundColor(.secondary)
                        }
                    }
                }
                Spacer()
                
                Button("Edit Height") {
                    showingHeightAlert = true
                }
                .buttonStyle(.bordered)
                .controlSize(.small)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
        .padding(.bottom)
    }
    
    /// Handle map tap to set target location
    private func handleMapTap(at point: CGPoint) {
        // Convert screen point to coordinate
        let coordinate = region.center // This is a simplified approach
        // In a real implementation, you'd convert the tap point to coordinate
        
        tempTargetCoordinate = coordinate
        showingHeightAlert = true
    }
    
    /// Set target location with coordinate
    private func setTargetLocation(coordinate: CLLocationCoordinate2D) {
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        viewModel.setTargetLocation(location)
    }
    
    /// Update map region when current location changes
    private func updateRegionForCurrentLocation(_ location: CLLocation?) {
        guard let location = location else { return }
        
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 1.0)) {
                region.center = location.coordinate
            }
        }
    }
    
    /// Center map on current location
    private func centerOnCurrentLocation() {
        guard let location = viewModel.locationManager.currentLocation else { return }
        
        withAnimation(.easeInOut(duration: 1.0)) {
            region.center = location.coordinate
        }
    }
}

// MARK: - Supporting Types
private struct MapAnnotation: Identifiable {
    let id: String
    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType
    
    enum AnnotationType {
        case current
        case target
    }
}

#Preview {
    MapView(viewModel: AlignmentViewModel())
}