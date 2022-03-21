//
//  MotionManager.swift
//  PIEMONS
//
//  Created by Ankush Dhawan on 3/19/22.
//

import Foundation
import CoreMotion
class MotionManager:NSObject
{
    private let manager = CMMotionManager()
    static let shared = MotionManager()
   
    private override init() {
        super.init()
        
    }

    func accelerometer() -> String {

        manager.deviceMotionUpdateInterval = 0.1
        manager.startDeviceMotionUpdates(to: .main) { (motion, error) in
            // Handle device motion updates
        }
        
        // Read the most recent accelerometer value
        let x = manager.accelerometerData?.acceleration.x
        let y = manager.accelerometerData?.acceleration.y
        let z = manager.accelerometerData?.acceleration.z
        var concat = ""
        if x != nil {
            concat = concat + String(format: "%f", x!)
        }
        if y != nil {
            concat = concat + String(format: "%f", y!)
        }
        if z != nil {
            concat = concat + String(format: "%f", z!)
        }
        
        // How frequently to read accelerometer updates, in seconds
        manager.accelerometerUpdateInterval = 0.1

        // Start accelerometer updates on a specific thread
        manager.startAccelerometerUpdates(to: .main) { (data, error) in
            // Handle acceleration update
            if error == nil {
                let x = data?.acceleration.x
                let y = data?.acceleration.y
                let z = data?.acceleration.z
            }
        }
        return concat
    }
    
    func gyroscope() -> String {
        let x =  manager.gyroData?.rotationRate.x
        let y = manager.gyroData?.rotationRate.y
        let z = manager.gyroData?.rotationRate.z
        
        
        var concat = ""
        if x != nil {
            concat = concat + String(format: "%f", x!)
        }
        if y != nil {
            concat = concat + String(format: "%f", y!)
        }
        if z != nil {
            concat = concat + String(format: "%f", z!)
        }
        
        
            

        // How frequently to read gyroscope updates,
        // in seconds
        manager.gyroUpdateInterval = 0.1

        // Start receiving gyroscope updates
        // on a specific thread
        manager.startGyroUpdates(to: .main) { (data, error) in
            // Handle rotation update
            if error == nil {
                let x = data?.rotationRate.x
                let y = data?.rotationRate.y
                let z = data?.rotationRate.z
            }
            
        }
        return concat

    }
    func Magnetometer() -> String {
        let x =  manager.magnetometerData?.magneticField.x
        let y = manager.magnetometerData?.magneticField.y
        let z = manager.magnetometerData?.magneticField.z
        var concat = ""
        if x != nil {
            concat = concat + String(format: "%f", x!)
        }
        if y != nil {
            concat = concat + String(format: "%f", y!)
        }
        if z != nil {
            concat = concat + String(format: "%f", z!)
        }
        

        // How frequently to read magnetometer updates,
        // in seconds
        manager.magnetometerUpdateInterval = 0.1

        // Start receiving magnetometer updates
        // on a specific thread
        manager.startMagnetometerUpdates(to: .main) { (data, error) in
            // Handle magnetic field update
            var x = data?.magneticField.x
            var y = data?.magneticField.y
            var z = data?.magneticField.z
        }
        return concat
    }
}
