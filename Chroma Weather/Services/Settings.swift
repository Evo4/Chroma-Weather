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
    
    var googleAPIKey: String {
        return "AIzaSyAF8L1Zmi-zbzyhRNOuEPHQML4Qi9_UFuQ"
    }
    
    var locationName: String? {
        return deserilizeLocationName()
    }
    
    var currentForecast: Forecast? {
        return deserializeCurrentForecast()
    }
    
    var badgeCounter: NSNumber {
        return deserilizeBadgeCounter()
    }
    
    private init() {    }
    
    func serializeUserIdToken(token: String?) {
        defs.set(token, forKey: "idToken")
    }
    
    private func deserializeUserIdToken()-> String? {
        let token = defs.string(forKey: "idToken")
        return token
    }
    
    func serializeLocationName(of: String) {
        defs.set(of, forKey: "locationName")
    }
    
    private func deserilizeLocationName()->String? {
        let locationName = defs.string(forKey: "locationName")
        return locationName
    }
    
    func serializeCurrentForecast(currentForecast: Forecast) {
        defs.set(try? PropertyListEncoder().encode(currentForecast), forKey: "currentForecast")
    }
    
    private func deserializeCurrentForecast() -> Forecast? {
        guard let data = defs.object(forKey: "currentForecast") as? Data,
            let lang = try? PropertyListDecoder().decode(Forecast.self, from: data) else {
                return nil
        }
        return lang
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
}
