//
//  UserSettings.swift
//  BrandMaster20
//
//  Created by Алексей on 18/08/2020.
//  Copyright © 2020 Alexey Orekhov. All rights reserved.
//

import Foundation

final class UserSettings {
    
    let defaults = UserDefaults.standard
	
	func saveSettings() {
        defaults.set(Parameters.shared.deviceType.rawValue, forKey: "deviceType")
        defaults.set(Parameters.shared.measureType.rawValue, forKey: "measureType")
		defaults.set(Parameters.shared.enterPressureData, forKey: "enterPressureData")
		defaults.set(Parameters.shared.firePressureData, forKey: "firePressureData")
		defaults.set(Parameters.shared.fallPressureData, forKey: "fallPressureData")
		defaults.set(Parameters.shared.airVolume, forKey: "cylinderVolume")
		defaults.set(Parameters.shared.airRate, forKey: "airRate")
		defaults.set(Parameters.shared.airIndex, forKey: "airIndex")
		defaults.set(Parameters.shared.reductorPressure, forKey: "reductionStability")
		defaults.set(Parameters.shared.accuracyMode, forKey: "handInputMode")
		defaults.set(Parameters.shared.airSignal, forKey: "airSignal")
		defaults.set(Parameters.shared.airSignalMode, forKey: "airSignalMode")
		defaults.set(Parameters.shared.showSimpleSolution, forKey: "simpleSolution")
		defaults.set(Parameters.shared.fontSize, forKey: "fontSize")
        defaults.set(Parameters.shared.teamSize, forKey: "teamSize")
		defaults.synchronize()
		
        print("Settings saved")
    }
    
    func loadSettings() {
		
		if let deviceType = DeviceType(rawValue: defaults.string(forKey: "deviceType") ?? "") {
            Parameters.shared.deviceType = deviceType
		}
        
		if let measureType = MeasureType(rawValue: defaults.string(forKey: "measureType") ?? "") {
            Parameters.shared.measureType = measureType
		}
		
		if let enterPressureData = defaults.object(forKey: "enterPressureData")  {
            Parameters.shared.enterPressureData = enterPressureData as! [Double]
		}
		
		if let firePressureData = defaults.object(forKey: "firePressureData")  {
			Parameters.shared.firePressureData = firePressureData as! [Double]
		}
		
		if let fallPressureData = defaults.object(forKey: "fallPressureData")  {
			Parameters.shared.fallPressureData = fallPressureData as! [Double]
		}
		
		if UserDefaults.standard.object(forKey: "cylinderVolume") != nil {
			Parameters.shared.airVolume = defaults.double(forKey: "cylinderVolume")
		}
		
		if UserDefaults.standard.object(forKey: "airRate") != nil {
			Parameters.shared.airRate = defaults.double(forKey: "airRate")
		}
		
		if UserDefaults.standard.object(forKey: "airIndex") != nil {
			Parameters.shared.airIndex = defaults.double(forKey: "airIndex")
		}
		
		if UserDefaults.standard.object(forKey: "reductionStability") != nil {
			Parameters.shared.reductorPressure = defaults.double(forKey: "reductionStability")
		}
		
		if UserDefaults.standard.object(forKey: "handInputMode") != nil {
			Parameters.shared.accuracyMode = defaults.bool(forKey: "handInputMode")
		}
		
		if UserDefaults.standard.object(forKey: "airSignal") != nil {
			Parameters.shared.airSignal = defaults.double(forKey: "airSignal")
		}
		
		if UserDefaults.standard.object(forKey: "airSignalMode") != nil {
			Parameters.shared.airSignalMode = defaults.bool(forKey: "airSignalMode")
		}
		
		if UserDefaults.standard.object(forKey: "simpleSolution") != nil {
			Parameters.shared.showSimpleSolution = defaults.bool(forKey: "simpleSolution")
		}
		
		if UserDefaults.standard.object(forKey: "fontSize") != nil {
			Parameters.shared.fontSize = defaults.double(forKey: "fontSize")
		}
        
        if UserDefaults.standard.object(forKey: "teamSize") != nil {
            Parameters.shared.teamSize = defaults.integer(forKey: "teamSize")
        }
        
		defaults.synchronize()
        
        print("Settings load")
    }
    
    func loadDefaultSettings() {
		let dictionary = defaults.dictionaryRepresentation()
		
		dictionary.keys.forEach { key in
			defaults.removeObject(forKey: key)
		}
		defaults.synchronize()
		
		Parameters.shared.teamSize = 3 //
		Parameters.shared.enterPressureData = [300.0, 300.0, 300.0]
		Parameters.shared.firePressureData = [250.0, 250.0, 250.0]
		Parameters.shared.fallPressureData = [50.0, 50.0, 50.0]
		Parameters.shared.deviceType = DeviceType.air
		Parameters.shared.measureType = MeasureType.kgc
		Parameters.shared.airVolume = 6.8
		Parameters.shared.airIndex = 1.1
		Parameters.shared.airRate = 40.0
		Parameters.shared.reductorPressure = 10.0
		Parameters.shared.airSignal = 63
		Parameters.shared.accuracyMode = false
		Parameters.shared.airSignalMode = true
		Parameters.shared.showSimpleSolution = false
		Parameters.shared.airSignal = 55
    }
}
