import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = AlignmentViewModel()
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            // Map View Tab
            MapView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(0)
            
            // Alignment View Tab
            AlignmentView(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "location.north")
                    Text("Align")
                }
                .tag(1)
        }
        .onAppear {
            viewModel.startLocationUpdates()
            viewModel.startMotionUpdates()
        }
        .onDisappear {
            viewModel.stopLocationUpdates()
            viewModel.stopMotionUpdates()
        }
    }
}

#Preview {
    ContentView()
}