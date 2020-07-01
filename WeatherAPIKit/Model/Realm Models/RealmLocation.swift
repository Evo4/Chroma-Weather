//
//  Location.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 24.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift
import CoreLocation

@objcMembers public class RealmLocation: Object {
    public dynamic var latitude: Double = 0.0
    public dynamic var longitude: Double = 0.0
    public dynamic var key: String = ""
    
    public override class func primaryKey() -> String? {
        return "key"
    }
}
