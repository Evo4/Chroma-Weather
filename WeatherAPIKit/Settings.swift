//
//  Settings.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 18.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation

public class Settings {
    
    public static var shared: Settings = {
        let settings = Settings()
        return settings
    }()
    
    public var userIdToken: String? {
        return deserializeUserIdToken()
    }
    private let defs = UserDefaults.standard
    
    public var openWeatherAPIKey: String {
        return "ae23d67b60e778a5f2e70166f6953419"
    }
    
    public var badgeCounter: NSNumber {
        return deserilizeBadgeCounter()
    }
    
    public var locationStatus: Int32? {
        return deserializeLocationStatus()?.status
    }
    
    public var locationName: String? {
        return deserializeLocationName()
    }
    
    private init() {    }
    
    public func serializeUserIdToken(token: String?) {
        defs.set(token, forKey: "idToken")
    }
    
    private func deserializeUserIdToken()-> String? {
        let token = defs.string(forKey: "idToken")
        return token
    }
    
    public func serializeBangeCounter(badge: NSNumber) {
        defs.set(badge, forKey: "badge")
    }
    
    private func deserilizeBadgeCounter()->NSNumber {
        if let badge = defs.object(forKey: "badge") {
            return (badge as? NSNumber)!
        } else {
            return NSNumber(value: 1)
        }
    }
    
    public func serializeLocationStatus(status: LocationStatus?) {
        defs.set(try? PropertyListEncoder().encode(status), forKey: "locationStatus")
    }
    
    private func deserializeLocationStatus()-> LocationStatus? {
        guard let data = defs.object(forKey: "locationStatus") as? Data,
            let status = try? PropertyListDecoder().decode(LocationStatus.self, from: data) else {
                return nil
        }
        return status
    }
    
    public func serializeLocationName(of: String) {
        defs.string(forKey: "locationName")
    }
    
    private func deserializeLocationName()->String? {
        let name = defs.string(forKey: "locationName")
        return name
    }
}
