import Foundation
import CoreMotion
import CoreLocation
import Combine

/// Manages device motion and orientation data
class MotionManager: ObservableObject {
    @Published var heading: Double = 0.0 // Compass heading in degrees (0-360)
    @Published var pitch: Double = 0.0   // Device tilt forward/backward in degrees
    @Published var roll: Double = 0.0    // Device tilt left/right in degrees
    @Published var isMotionAvailable = false
    @Published var errorMessage: String?
    
    private let motionManager = CMMotionManager()
    private let locationManager = CLLocationManager()
    
    init() {
        setupMotionManager()
    }
    
    private func setupMotionManager() {
        // Check if motion sensors are available
        isMotionAvailable = motionManager.isDeviceMotionAvailable
        
        if isMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.1 // 10 Hz updates
        }
    }
    
    func startMotionUpdates() {
        guard isMotionAvailable else {
            errorMessage = "Motion sensors not available on this device"
            return
        }
        
        motionManager.startDeviceMotionUpdates(to: .main) { [weak self] motion, error in
            guard let self = self else { return }
            
            if let error = error {
                self.errorMessage = "Motion error: \(error.localizedDescription)"
                return
            }
            
            guard let motion = motion else { return }
            
            // Convert attitude to degrees
            let pitchDegrees = motion.attitude.pitch * 180.0 / .pi
            let rollDegrees = motion.attitude.roll * 180.0 / .pi
            
            DispatchQueue.main.async {
                self.pitch = pitchDegrees
                self.roll = rollDegrees
                self.errorMessage = nil
            }
        }
        
        // Start heading updates if available
        if CLLocationManager.headingAvailable() {
            locationManager.delegate = self
            locationManager.startUpdatingHeading()
        }
    }
    
    func stopMotionUpdates() {
        motionManager.stopDeviceMotionUpdates()
        locationManager.stopUpdatingHeading()
    }
}

// MARK: - CLLocationManagerDelegate
extension MotionManager: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        DispatchQueue.main.async {
            // Use magnetic heading, adjust if needed
            self.heading = newHeading.magneticHeading >= 0 ? newHeading.magneticHeading : newHeading.trueHeading
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        DispatchQueue.main.async {
            self.errorMessage = "Heading error: \(error.localizedDescription)"
        }
    }
}