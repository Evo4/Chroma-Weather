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
    
    private init() {    }
    
    func serializeUserIdToken(token: String?) {
        defs.set(token, forKey: "idToken")
    }
    
    private func deserializeUserIdToken()-> String? {
        let token = defs.string(forKey: "idToken")
        return token
    }
}
