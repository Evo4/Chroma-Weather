//
//  LocationStatus.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 29.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import CoreLocation

public struct LocationStatus: Codable {
    public var status: Int32
    
    public init(status: Int32) {
        self.status = status
    }
}
