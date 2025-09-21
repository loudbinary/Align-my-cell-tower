import SwiftUI

/// AlignmentView provides real-time visual feedback for device alignment
/// Shows compass, tilt indicators, and alignment status
struct AlignmentView: View {
    @ObservableObject var viewModel: AlignmentViewModel
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Target status section
                    targetStatusSection
                    
                    // Compass section
                    if viewModel.targetLocation != nil {
                        compassSection
                        
                        // Alignment metrics
                        alignmentMetricsSection
                        
                        // Alignment accuracy
                        alignmentAccuracySection
                    } else {
                        noTargetSection
                    }
                }
                .padding()
            }
            .navigationTitle("Alignment")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
    
    /// Target status section
    private var targetStatusSection: some View {
        VStack(spacing: 12) {
            HStack {
                Image(systemName: "antenna.radiowaves.left.and.right")
                    .foregroundColor(.red)
                    .font(.title2)
                
                Text("Cell Tower Target")
                    .font(.headline)
                
                Spacer()
                
                if viewModel.targetLocation != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.green)
                        .font(.title2)
                }
            }
            
            if let targetLocation = viewModel.targetLocation {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Coordinates:")
                        Spacer()
                        Text("\(String(format: "%.6f", targetLocation.coordinate.latitude)), \(String(format: "%.6f", targetLocation.coordinate.longitude))")
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .monospaced))
                    }
                    
                    HStack {
                        Text("Distance:")
                        Spacer()
                        Text(viewModel.formattedDistance)
                            .foregroundColor(.secondary)
                            .font(.system(.body, design: .monospaced))
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    /// Compass section with direction indicator
    private var compassSection: some View {
        VStack(spacing: 16) {
            Text("Compass Alignment")
                .font(.headline)
            
            CompassView(
                deviceHeading: viewModel.motionManager.deviceHeading,
                targetAzimuth: viewModel.azimuth,
                alignmentAccuracy: viewModel.alignmentAccuracy
            )
            .frame(width: 280, height: 280)
            
            // Direction text
            HStack {
                VStack(alignment: .leading) {
                    Text("Device Direction")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(AlignmentCalculator.azimuthToCardinalDirection(viewModel.motionManager.deviceHeading))
                        .font(.title2)
                        .fontWeight(.semibold)
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Target Direction")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    Text(viewModel.formattedAzimuth)
                        .font(.title2)
                        .fontWeight(.semibold)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    /// Alignment metrics section
    private var alignmentMetricsSection: some View {
        VStack(spacing: 16) {
            Text("Alignment Metrics")
                .font(.headline)
            
            HStack(spacing: 20) {
                // Azimuth difference
                metricCard(
                    title: "Heading",
                    value: "\(String(format: "%.0f", abs(viewModel.azimuth - viewModel.motionManager.deviceHeading)))°",
                    subtitle: "Off Target",
                    color: .blue
                )
                
                // Tilt
                metricCard(
                    title: "Tilt",
                    value: viewModel.formattedTilt,
                    subtitle: "Required",
                    color: .orange
                )
                
                // Device tilt
                metricCard(
                    title: "Device Tilt",
                    value: "\(String(format: "%.1f", viewModel.motionManager.deviceTilt))°",
                    subtitle: "Current",
                    color: .purple
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    /// Alignment accuracy section with visual feedback
    private var alignmentAccuracySection: some View {
        VStack(spacing: 16) {
            Text("Alignment Status")
                .font(.headline)
            
            // Large status indicator
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(viewModel.alignmentColor.opacity(0.2))
                        .frame(width: 120, height: 120)
                    
                    Circle()
                        .stroke(viewModel.alignmentColor, lineWidth: 8)
                        .frame(width: 120, height: 120)
                    
                    VStack {
                        Text("\(String(format: "%.0f", viewModel.alignmentAccuracy))%")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(viewModel.alignmentColor)
                        
                        Text(viewModel.alignmentStatus)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .foregroundColor(viewModel.alignmentColor)
                    }
                }
                
                // Alignment progress bar
                ProgressView(value: viewModel.alignmentAccuracy / 100.0)
                    .progressViewStyle(LinearProgressViewStyle(tint: viewModel.alignmentColor))
                    .frame(height: 8)
                    .clipShape(Capsule())
                
                // Feedback text
                Group {
                    if viewModel.isAligned {
                        Text("🎯 Device is aligned with target!")
                            .foregroundColor(.green)
                            .fontWeight(.semibold)
                    } else {
                        Text("Adjust device orientation to align with target")
                            .foregroundColor(.secondary)
                    }
                }
                .font(.body)
                .multilineTextAlignment(.center)
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    /// No target selected section
    private var noTargetSection: some View {
        VStack(spacing: 16) {
            Image(systemName: "location.slash")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Target Selected")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Go to the Map tab to select a cell tower location by dropping a pin.")
                .font(.body)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    /// Helper method to create metric cards
    private func metricCard(title: String, value: String, subtitle: String, color: Color) -> some View {
        VStack(spacing: 4) {
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(color)
            
            Text(subtitle)
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}

#Preview {
    AlignmentView(viewModel: AlignmentViewModel())
}