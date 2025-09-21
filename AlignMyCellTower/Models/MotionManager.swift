import CoreMotion
import Foundation

/// MotionManager handles device orientation and motion data
/// Provides real-time device heading and tilt information for alignment
class MotionManager: ObservableObject {
    private let motionManager = CMMotionManager()
    private let headingManager = CMHeadingManager()
    
    @Published var deviceHeading: Double = 0.0 // Magnetic heading in degrees
    @Published var deviceTilt: Double = 0.0 // Device tilt in degrees
    @Published var deviceRoll: Double = 0.0 // Device roll in degrees
    @Published var isMotionAvailable: Bool = false
    @Published var isHeadingAvailable: Bool = false
    
    init() {
        checkAvailability()
    }
    
    /// Check if motion and heading sensors are available
    private func checkAvailability() {
        isMotionAvailable = motionManager.isDeviceMotionAvailable
        isHeadingAvailable = CMHeadingManager.headingAvailable()
    }
    
    /// Start motion and heading updates
    func startMotionUpdates() {
        startDeviceMotionUpdates()
        startHeadingUpdates()
    }
    
    /// Stop all motion updates to save battery
    func stopMotionUpdates() {
        stopDeviceMotionUpdates()
        stopHeadingUpdates()
    }
    
    /// Start device motion updates for tilt and roll
    private func startDeviceMotionUpdates() {
        guard motionManager.isDeviceMotionAvailable else {
            print("Device motion is not available")
            return
        }
        
        motionManager.deviceMotionUpdateInterval = 0.1 // 10 Hz
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self, let motion = motion else {
                if let error = error {
                    print("Device motion error: \(error.localizedDescription)")
                }
                return
            }
            
            // Calculate device tilt (pitch) and roll
            let pitch = motion.attitude.pitch
            let roll = motion.attitude.roll
            
            // Convert to degrees and update published properties
            self.deviceTilt = pitch.radiansToDegrees
            self.deviceRoll = roll.radiansToDegrees
        }
    }
    
    /// Start magnetic heading updates
    private func startHeadingUpdates() {
        guard CMHeadingManager.headingAvailable() else {
            print("Heading is not available")
            return
        }
        
        headingManager.headingFilter = kCLHeadingFilterNone
        headingManager.startUpdatingHeading(to: .main) { [weak self] heading, error in
            guard let self = self, let heading = heading else {
                if let error = error {
                    print("Heading error: \(error.localizedDescription)")
                }
                return
            }
            
            // Use magnetic heading
            self.deviceHeading = heading.magneticHeading
        }
    }
    
    /// Stop device motion updates
    private func stopDeviceMotionUpdates() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    /// Stop heading updates
    private func stopHeadingUpdates() {
        if headingManager.headingAvailable {
            headingManager.stopUpdatingHeading()
        }
    }
    
    /// Get the current device orientation as a string for debugging
    var orientationDescription: String {
        let headingDirection = AlignmentCalculator.azimuthToCardinalDirection(deviceHeading)
        return "Heading: \(headingDirection) (\(String(format: "%.1f", deviceHeading))°), Tilt: \(String(format: "%.1f", deviceTilt))°"
    }
}

// MARK: - Extensions
private extension Double {
    var radiansToDegrees: Double {
        return self * 180.0 / .pi
    }
}