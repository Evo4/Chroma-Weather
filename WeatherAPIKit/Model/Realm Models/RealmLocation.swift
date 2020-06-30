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

class RealmLocation: Object {
    @objc dynamic var latitude: Double = 0.0
    @objc dynamic var longitude: Double = 0.0
}
