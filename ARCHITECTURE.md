# App Architecture Overview

## MVVM Pattern Implementation

```
┌─────────────────────────────────────────────────────────────┐
│                        Views Layer                          │
├─────────────────────────────────────────────────────────────┤
│  ContentView (Tab Container)                                │
│  ├── MapView (Target Selection)                             │
│  │   ├── Interactive Map with Pin Dropping                 │
│  │   ├── Current Location Marker                           │
│  │   ├── Target Location Marker                            │
│  │   └── Info Panel with Distance/Direction                │
│  │                                                          │
│  └── AlignmentView (Real-time Alignment)                   │
│      ├── Target Status Section                             │
│      ├── CompassView (Custom Compass)                      │
│      ├── Alignment Metrics Cards                           │
│      └── Accuracy Visualization                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ Data Binding (SwiftUI)
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                    ViewModel Layer                          │
├─────────────────────────────────────────────────────────────┤
│  AlignmentViewModel                                         │
│  ├── Coordinates data flow between Models and Views        │
│  ├── Reactive bindings using Combine                       │
│  ├── Alignment calculations orchestration                  │
│  ├── UI state management                                   │
│  └── Formatted data for display                            │
└─────────────────────────────────────────────────────────────┘
                              │
                              │ Data Updates
                              ▼
┌─────────────────────────────────────────────────────────────┐
│                     Models Layer                            │
├─────────────────────────────────────────────────────────────┤
│  LocationManager                                            │
│  ├── CoreLocation integration                              │
│  ├── GPS positioning                                       │
│  ├── Permission handling                                   │
│  └── Real-time location updates                            │
│                                                             │
│  MotionManager                                              │
│  ├── CoreMotion integration                                │
│  ├── Device heading detection                              │
│  ├── Tilt/Roll measurements                                │
│  └── Compass calibration                                   │
│                                                             │
│  AlignmentCalculator (Utility)                             │
│  ├── Azimuth calculations                                  │
│  ├── Tilt angle calculations                               │
│  ├── Distance measurements                                 │
│  ├── Alignment accuracy                                    │
│  └── Cardinal direction conversion                         │
└─────────────────────────────────────────────────────────────┘
```

## Data Flow

```
GPS Location ──┐
               ├──► AlignmentViewModel ──► UI Updates
Device Motion ─┘

User Input ──► MapView ──► Target Selection ──► Calculations ──► Visual Feedback
```

## Key Features Implementation

### 1. Real-Time Azimuth & Tilt Calculations ✅
- Uses spherical trigonometry for bearing calculations
- Accounts for Earth's curvature and target height
- Updates continuously with location changes

### 2. Compass & Tilt Feedback ✅
- Custom SwiftUI compass with visual indicators
- Color-coded accuracy feedback (Red/Yellow/Green)
- Real-time device orientation tracking

### 3. MapKit Enhancements ✅
- Interactive pin dropping for target selection
- Dual location display (current + target)
- Distance and direction information panel

### 4. UI/UX Improvements ✅
- Tab-based navigation for workflow separation
- Visual alignment indicators and progress bars
- Responsive design with smooth animations

### 5. Code Structure & Documentation ✅
- Clean MVVM architecture with proper separation
- Comprehensive inline documentation
- Detailed README with usage instructions