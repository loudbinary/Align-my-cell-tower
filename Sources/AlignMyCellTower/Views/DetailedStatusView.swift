#if canImport(SwiftUI) && canImport(CoreLocation)
import SwiftUI

/// Detailed status view showing comprehensive location and system information
public struct DetailedStatusView: View {
    
    // MARK: - Properties
    
    /// Location view model reference
    @ObservedObject var viewModel: LocationViewModel
    
    /// Environment value for dismissing the sheet
    @Environment(\.dismiss) private var dismiss
    
    /// State for refreshing the detailed status
    @State private var detailedStatus: String = ""
    
    // MARK: - Body
    
    public var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Overview Section
                    overviewSection
                    
                    // Location Data Section
                    if viewModel.hasValidLocationData {
                        locationDataSection
                    }
                    
                    // System Information Section
                    systemInformationSection
                    
                    // Raw Status Information
                    rawStatusSection
                }
                .padding()
            }
            .navigationTitle("System Status")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Refresh") {
                        refreshStatus()
                    }
                }
            }
            .onAppear {
                refreshStatus()
            }
        }
    }
    
    // MARK: - View Sections
    
    /// Overview section with key status indicators
    private var overviewSection: some View {
        StatusSection(title: "Overview") {
            VStack(spacing: 12) {
                StatusRow(
                    label: "Location Authorized",
                    value: viewModel.isLocationAuthorized ? "Yes" : "No",
                    isGood: viewModel.isLocationAuthorized
                )
                
                StatusRow(
                    label: "Currently Tracking",
                    value: viewModel.isTrackingLocation ? "Yes" : "No",
                    isGood: viewModel.isTrackingLocation
                )
                
                StatusRow(
                    label: "Heading Supported",
                    value: viewModel.isHeadingSupported ? "Yes" : "No",
                    isGood: viewModel.isHeadingSupported
                )
                
                StatusRow(
                    label: "Location Data Available",
                    value: viewModel.hasValidLocationData ? "Yes" : "No",
                    isGood: viewModel.hasValidLocationData
                )
                
                if let age = viewModel.locationAge {
                    StatusRow(
                        label: "Data Age",
                        value: String(format: "%.1f seconds", age),
                        isGood: viewModel.isLocationDataFresh
                    )
                }
            }
        }
    }
    
    /// Detailed location data section
    private var locationDataSection: some View {
        StatusSection(title: "Location Data") {
            VStack(spacing: 12) {
                if let location = viewModel.locationData {
                    DetailRow(label: "Latitude", value: location.formattedLatitude)
                    DetailRow(label: "Longitude", value: location.formattedLongitude)
                    DetailRow(label: "Altitude", value: location.formattedAltitude)
                    DetailRow(label: "Horizontal Accuracy", value: String(format: "±%.1f m", location.horizontalAccuracy))
                    DetailRow(label: "Vertical Accuracy", value: String(format: "±%.1f m", location.verticalAccuracy))
                    
                    if let heading = location.heading {
                        DetailRow(label: "Magnetic Heading", value: String(format: "%.1f°", heading))
                        DetailRow(label: "Compass Direction", value: location.compassDirection)
                        
                        if let headingAccuracy = location.headingAccuracy {
                            DetailRow(label: "Heading Accuracy", value: String(format: "±%.1f°", headingAccuracy))
                        }
                    }
                    
                    DetailRow(label: "Timestamp", value: formatTimestamp(location.timestamp))
                }
            }
        }
    }
    
    /// System information section
    private var systemInformationSection: some View {
        StatusSection(title: "System Information") {
            VStack(spacing: 12) {
                DetailRow(label: "Device Model", value: deviceModel)
                DetailRow(label: "iOS Version", value: iosVersion)
                DetailRow(label: "App Status", value: viewModel.statusMessage)
                
                if let errorMessage = viewModel.errorMessage {
                    DetailRow(label: "Last Error", value: errorMessage, isError: true)
                }
            }
        }
    }
    
    /// Raw status information section
    private var rawStatusSection: some View {
        StatusSection(title: "Raw Status Information") {
            Text(detailedStatus)
                .font(.caption)
                .fontFamily(.monospaced)
                .foregroundColor(.secondary)
                .padding()
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 8))
        }
    }
    
    // MARK: - Helper Methods
    
    /// Refresh the detailed status information
    private func refreshStatus() {
        detailedStatus = viewModel.getDetailedStatus()
    }
    
    /// Format timestamp for display
    private func formatTimestamp(_ timestamp: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter.string(from: timestamp)
    }
    
    /// Get device model string
    private var deviceModel: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value))!)
        }
        return identifier.isEmpty ? "Unknown" : identifier
    }
    
    /// Get iOS version string
    private var iosVersion: String {
        let version = ProcessInfo.processInfo.operatingSystemVersion
        return "\(version.majorVersion).\(version.minorVersion).\(version.patchVersion)"
    }
    
    // MARK: - Initializer
    
    public init(viewModel: LocationViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: - Supporting Views

/// Section container for status information
struct StatusSection<Content: View>: View {
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundColor(.primary)
            
            content
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
    }
}

/// Status row with good/bad indicator
struct StatusRow: View {
    let label: String
    let value: String
    let isGood: Bool
    
    init(label: String, value: String, isGood: Bool = true) {
        self.label = label
        self.value = value
        self.isGood = isGood
    }
    
    var body: some View {
        HStack {
            Circle()
                .fill(isGood ? .green : .red)
                .frame(width: 8, height: 8)
            
            Text(label)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .fontWeight(.medium)
        }
    }
}

/// Detail row for displaying information
struct DetailRow: View {
    let label: String
    let value: String
    let isError: Bool
    
    init(label: String, value: String, isError: Bool = false) {
        self.label = label
        self.value = value
        self.isError = isError
    }
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.secondary)
                .frame(maxWidth: 120, alignment: .leading)
            
            Text(value)
                .fontWeight(.medium)
                .fontFamily(.monospaced)
                .foregroundColor(isError ? .red : .primary)
            
            Spacer()
        }
    }
}

// MARK: - Preview

#if DEBUG
struct DetailedStatusView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedStatusView(viewModel: LocationViewModel())
    }
}
#endif

#endif