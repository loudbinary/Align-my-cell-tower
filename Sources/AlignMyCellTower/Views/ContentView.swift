#if canImport(SwiftUI) && canImport(CoreLocation)
import SwiftUI

/// Main content view that displays GPS and compass information
public struct ContentView: View {
    
    // MARK: - Properties
    
    /// Location view model for managing location data
    @StateObject private var locationViewModel = LocationViewModel()
    
    /// State for controlling the display of detailed status
    @State private var showDetailedStatus = false
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(
                    gradient: Gradient(colors: [.blue.opacity(0.1), .cyan.opacity(0.2)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 20) {
                        // Header
                        headerSection
                        
                        // Location Status Card
                        locationStatusCard
                        
                        // GPS Coordinates Card
                        gpsCoordinatesCard
                        
                        // Compass Heading Card
                        compassHeadingCard
                        
                        // Control Buttons
                        controlButtonsSection
                        
                        // Error Message (if any)
                        if let errorMessage = locationViewModel.errorMessage {
                            errorMessageCard(errorMessage)
                        }
                        
                        Spacer(minLength: 20)
                    }
                    .padding()
                }
            }
            .navigationTitle("Cell Tower Alignment")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Status") {
                        showDetailedStatus.toggle()
                    }
                }
            }
            .sheet(isPresented: $showDetailedStatus) {
                DetailedStatusView(viewModel: locationViewModel)
            }
        }
        .onAppear {
            locationViewModel.requestLocationPermission()
        }
    }
    
    // MARK: - View Components
    
    /// Header section with app description
    private var headerSection: some View {
        VStack(spacing: 8) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 48))
                .foregroundColor(.blue)
            
            Text("Align My Cell Tower")
                .font(.title2)
                .fontWeight(.bold)
            
            Text("Real-time GPS coordinates and compass heading for precise cell tower alignment")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
    
    /// Location status indicator card
    private var locationStatusCard: some View {
        CardView {
            HStack {
                Circle()
                    .fill(locationViewModel.isTrackingLocation ? .green : .red)
                    .frame(width: 12, height: 12)
                
                Text(locationViewModel.statusMessage)
                    .font(.headline)
                
                Spacer()
                
                if locationViewModel.isTrackingLocation {
                    ProgressView()
                        .scaleEffect(0.8)
                }
            }
        }
    }
    
    /// GPS coordinates display card
    private var gpsCoordinatesCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "location")
                        .foregroundColor(.blue)
                    Text("GPS Coordinates")
                        .font(.headline)
                    Spacer()
                }
                
                if locationViewModel.hasValidLocationData {
                    VStack(alignment: .leading, spacing: 8) {
                        InfoRow(
                            label: "Latitude",
                            value: locationViewModel.locationData?.formattedLatitude ?? "N/A"
                        )
                        
                        InfoRow(
                            label: "Longitude", 
                            value: locationViewModel.locationData?.formattedLongitude ?? "N/A"
                        )
                        
                        InfoRow(
                            label: "Altitude",
                            value: locationViewModel.altitudeDisplayString
                        )
                        
                        InfoRow(
                            label: "Accuracy",
                            value: locationViewModel.accuracyDisplayString
                        )
                    }
                } else {
                    Text("No GPS data available")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
        }
    }
    
    /// Compass heading display card
    private var compassHeadingCard: some View {
        CardView {
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Image(systemName: "safari")
                        .foregroundColor(.orange)
                    Text("Compass Heading")
                        .font(.headline)
                    Spacer()
                }
                
                if locationViewModel.isHeadingSupported {
                    if locationViewModel.hasValidHeadingData {
                        VStack(spacing: 16) {
                            // Compass visual representation
                            ZStack {
                                Circle()
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 2)
                                    .frame(width: 120, height: 120)
                                
                                // Compass needle
                                if let heading = locationViewModel.locationData?.heading {
                                    Rectangle()
                                        .fill(.red)
                                        .frame(width: 4, height: 40)
                                        .offset(y: -20)
                                        .rotationEffect(.degrees(heading))
                                }
                                
                                // North indicator
                                Text("N")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .offset(y: -50)
                            }
                            
                            VStack(alignment: .leading, spacing: 8) {
                                InfoRow(
                                    label: "Heading",
                                    value: locationViewModel.headingDisplayString
                                )
                                
                                InfoRow(
                                    label: "Direction",
                                    value: locationViewModel.compassDirectionString
                                )
                            }
                        }
                    } else {
                        Text("No compass data available")
                            .foregroundColor(.secondary)
                            .italic()
                    }
                } else {
                    Text("Compass not supported on this device")
                        .foregroundColor(.secondary)
                        .italic()
                }
            }
        }
    }
    
    /// Control buttons section
    private var controlButtonsSection: some View {
        VStack(spacing: 12) {
            Button(action: {
                locationViewModel.toggleLocationTracking()
            }) {
                HStack {
                    Image(systemName: locationViewModel.isTrackingLocation ? "pause.fill" : "play.fill")
                    Text(locationViewModel.isTrackingLocation ? "Stop Tracking" : "Start Tracking")
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(locationViewModel.isTrackingLocation ? .red : .green)
                .foregroundColor(.white)
                .rounded()
            }
            .disabled(!locationViewModel.isLocationAuthorized)
            
            if !locationViewModel.isLocationAuthorized {
                Button("Grant Location Permission") {
                    locationViewModel.requestLocationPermission()
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.blue)
                .foregroundColor(.white)
                .rounded()
            }
        }
    }
    
    /// Error message card
    private func errorMessageCard(_ message: String) -> some View {
        CardView {
            HStack {
                Image(systemName: "exclamationmark.triangle")
                    .foregroundColor(.red)
                Text(message)
                    .foregroundColor(.red)
                    .font(.caption)
                Spacer()
            }
        }
    }
    
    // MARK: - Initializer
    
    public init() {}
}

// MARK: - Supporting Views

/// Reusable card view with consistent styling
struct CardView<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        content
            .padding()
            .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
            .shadow(radius: 2)
    }
}

/// Reusable info row for displaying label-value pairs
struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(width: 80, alignment: .leading)
            Text(value)
                .fontWeight(.medium)
                .fontFamily(.monospaced)
            Spacer()
        }
    }
}

/// Extension for view modifiers
extension View {
    func rounded() -> some View {
        self.clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

// MARK: - Preview

#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

#endif