//
//  Settings.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 18.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation

class Settings {
    
    static var shared: Settings = {
        let settings = Settings()
        return settings
    }()
    
    var userIdToken: String? {
        return deserializeUserIdToken()
    }
    private let defs = UserDefaults.standard
    
    var openWeatherAPIKey: String {
        return "ae23d67b60e778a5f2e70166f6953419"
    }
    
    var badgeCounter: NSNumber {
        return deserilizeBadgeCounter()
    }
    
    var locationStatus: Int32? {
        return deserializeLocationStatus()?.status
    }
    
    var locationName: String? {
        return deserializeLocationName()
    }
    
    private init() {    }
    
    func serializeUserIdToken(token: String?) {
        defs.set(token, forKey: "idToken")
    }
    
    private func deserializeUserIdToken()-> String? {
        let token = defs.string(forKey: "idToken")
        return token
    }
    
    func serializeBangeCounter(badge: NSNumber) {
        defs.set(badge, forKey: "badge")
    }
    
    private func deserilizeBadgeCounter()->NSNumber {
        if let badge = defs.object(forKey: "badge") {
            return (badge as? NSNumber)!
        } else {
            return NSNumber(value: 1)
        }
    }
    
    func serializeLocationStatus(status: LocationStatus?) {
        defs.set(try? PropertyListEncoder().encode(status), forKey: "locationStatus")
    }
    
    private func deserializeLocationStatus()-> LocationStatus? {
        guard let data = defs.object(forKey: "locationStatus") as? Data,
            let status = try? PropertyListDecoder().decode(LocationStatus.self, from: data) else {
                return nil
        }
        return status
    }
    
    func serializeLocationName(of: String) {
        defs.string(forKey: "locationName")
    }
    
    private func deserializeLocationName()->String? {
        let name = defs.string(forKey: "locationName")
        return name
    }
}
