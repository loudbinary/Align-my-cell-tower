import SwiftUI

/// CompassView provides a visual compass with real-time alignment feedback
/// Shows device heading, target direction, and alignment accuracy
struct CompassView: View {
    let deviceHeading: Double
    let targetAzimuth: Double
    let alignmentAccuracy: Double
    
    private let compassSize: CGFloat = 280
    private let centerSize: CGFloat = 20
    
    var body: some View {
        ZStack {
            // Outer compass ring
            compassRing
            
            // Cardinal direction labels
            cardinalDirections
            
            // Target direction indicator
            targetIndicator
            
            // Device heading indicator
            deviceIndicator
            
            // Center dot
            centerDot
            
            // Alignment arc
            alignmentArc
        }
        .frame(width: compassSize, height: compassSize)
        .background(Color(.systemBackground))
        .clipShape(Circle())
        .overlay {
            Circle()
                .stroke(Color(.systemGray4), lineWidth: 2)
        }
    }
    
    /// Compass ring with degree markings
    private var compassRing: some View {
        ZStack {
            // Major degree markings (every 30 degrees)
            ForEach(0..<12) { index in
                let angle = Double(index) * 30.0
                Rectangle()
                    .fill(Color(.systemGray2))
                    .frame(width: 2, height: 20)
                    .offset(y: -compassSize / 2 + 20)
                    .rotationEffect(.degrees(angle))
            }
            
            // Minor degree markings (every 10 degrees)
            ForEach(0..<36) { index in
                let angle = Double(index) * 10.0
                if index % 3 != 0 { // Skip major markings
                    Rectangle()
                        .fill(Color(.systemGray3))
                        .frame(width: 1, height: 12)
                        .offset(y: -compassSize / 2 + 16)
                        .rotationEffect(.degrees(angle))
                }
            }
        }
    }
    
    /// Cardinal direction labels
    private var cardinalDirections: some View {
        ZStack {
            // North
            Text("N")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.red)
                .offset(y: -compassSize / 2 + 45)
            
            // East
            Text("E")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .offset(x: compassSize / 2 - 45)
            
            // South
            Text("S")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .offset(y: compassSize / 2 - 45)
            
            // West
            Text("W")
                .font(.title3)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
                .offset(x: -compassSize / 2 + 45)
        }
    }
    
    /// Target direction indicator (red arrow)
    private var targetIndicator: some View {
        ZStack {
            // Target direction line
            Rectangle()
                .fill(Color.red)
                .frame(width: 3, height: compassSize / 2 - 30)
                .offset(y: -(compassSize / 4 + 15))
                .rotationEffect(.degrees(targetAzimuth))
            
            // Target arrowhead
            Triangle()
                .fill(Color.red)
                .frame(width: 12, height: 20)
                .offset(y: -compassSize / 2 + 35)
                .rotationEffect(.degrees(targetAzimuth))
        }
    }
    
    /// Device heading indicator (blue arrow)
    private var deviceIndicator: some View {
        ZStack {
            // Device direction line
            Rectangle()
                .fill(Color.blue)
                .frame(width: 4, height: compassSize / 2 - 40)
                .offset(y: -(compassSize / 4 + 10))
                .rotationEffect(.degrees(deviceHeading))
            
            // Device arrowhead
            Triangle()
                .fill(Color.blue)
                .frame(width: 16, height: 24)
                .offset(y: -compassSize / 2 + 40)
                .rotationEffect(.degrees(deviceHeading))
        }
    }
    
    /// Center dot
    private var centerDot: some View {
        Circle()
            .fill(Color(.systemGray))
            .frame(width: centerSize, height: centerSize)
    }
    
    /// Alignment accuracy arc
    private var alignmentArc: some View {
        let alignmentColor = getAlignmentColor()
        let arcRadius = compassSize / 3
        
        return Circle()
            .trim(from: 0, to: alignmentAccuracy / 100.0)
            .stroke(
                alignmentColor,
                style: StrokeStyle(lineWidth: 6, lineCap: .round)
            )
            .frame(width: arcRadius, height: arcRadius)
            .rotationEffect(.degrees(-90)) // Start from top
            .animation(.easeInOut(duration: 0.3), value: alignmentAccuracy)
    }
    
    /// Get color based on alignment accuracy
    private func getAlignmentColor() -> Color {
        switch alignmentAccuracy {
        case 90...100:
            return .green
        case 70..<90:
            return .yellow
        case 50..<70:
            return .orange
        default:
            return .red
        }
    }
}

/// Triangle shape for arrow indicators
private struct Triangle: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.midX, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.midX, y: rect.minY))
        
        return path
    }
}

#Preview {
    VStack(spacing: 30) {
        Text("Compass Preview")
            .font(.title)
        
        CompassView(
            deviceHeading: 45,
            targetAzimuth: 90,
            alignmentAccuracy: 75
        )
        
        HStack {
            VStack {
                Text("Device")
                    .font(.caption)
                Rectangle()
                    .fill(Color.blue)
                    .frame(width: 20, height: 4)
            }
            
            VStack {
                Text("Target")
                    .font(.caption)
                Rectangle()
                    .fill(Color.red)
                    .frame(width: 20, height: 4)
            }
        }
    }
    .padding()
}