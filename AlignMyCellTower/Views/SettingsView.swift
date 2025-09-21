import SwiftUI

struct SettingsView: View {
    @AppStorage("useMetricUnits") private var useMetricUnits = true
    @AppStorage("compassAccuracy") private var compassAccuracy = 1.0
    @AppStorage("showDebugInfo") private var showDebugInfo = false
    
    var body: some View {
        NavigationView {
            Form {
                Section("Units") {
                    Toggle("Use Metric Units", isOn: $useMetricUnits)
                        .tint(.blue)
                }
                
                Section("Accuracy") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Compass Update Frequency")
                        HStack {
                            Text("Low")
                                .font(.caption)
                            Slider(value: $compassAccuracy, in: 0.1...2.0, step: 0.1)
                            Text("High")
                                .font(.caption)
                        }
                        Text("Current: \(compassAccuracy, specifier: "%.1f") Hz")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section("Debug") {
                    Toggle("Show Debug Information", isOn: $showDebugInfo)
                        .tint(.orange)
                }
                
                Section("About") {
                    VStack(alignment: .leading, spacing: 12) {
                        HStack {
                            Image(systemName: "antenna.radiowaves.left.and.right")
                                .foregroundColor(.blue)
                            VStack(alignment: .leading) {
                                Text("Align My Cell Tower")
                                    .font(.headline)
                                Text("Version 1.0")
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                        
                        Text("This app helps you align your device to point directly at a target GPS location by calculating the required azimuth and elevation angles.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding(.vertical, 4)
                }
                
                Section("Features") {
                    FeatureRow(
                        icon: "location.circle",
                        title: "GPS Location",
                        description: "Uses CoreLocation for precise positioning"
                    )
                    
                    FeatureRow(
                        icon: "gyroscope",
                        title: "Motion Sensors",
                        description: "Integrates compass and accelerometer data"
                    )
                    
                    FeatureRow(
                        icon: "map",
                        title: "Interactive Map",
                        description: "Select target locations on a map interface"
                    )
                    
                    FeatureRow(
                        icon: "calculator",
                        title: "Precise Calculations",
                        description: "Calculates azimuth and elevation angles"
                    )
                }
                
                Section("Permissions") {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Required Permissions:")
                            .font(.subheadline)
                            .fontWeight(.semibold)
                        
                        PermissionRow(
                            icon: "location",
                            title: "Location Services",
                            description: "Required to determine your current position"
                        )
                        
                        PermissionRow(
                            icon: "gyroscope",
                            title: "Motion & Fitness",
                            description: "Required to access device orientation sensors"
                        )
                    }
                }
                
                Section {
                    Link(destination: URL(string: "https://github.com/loudbinary/Align-my-cell-tower")!) {
                        HStack {
                            Image(systemName: "link")
                            Text("View on GitHub")
                            Spacer()
                            Image(systemName: "arrow.up.right")
                                .font(.caption)
                        }
                    }
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 2)
    }
}

struct PermissionRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(.orange)
                .frame(width: 20)
            
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
                Text(description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
    }
}

#Preview {
    SettingsView()
}