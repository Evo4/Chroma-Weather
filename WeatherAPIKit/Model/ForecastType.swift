//
//  ForecastType.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation

public struct ForecastType {
    public let type: DayType
    
    public enum DayType: String {
        case today = "Today"
        case tomorrow = "Tomorrow"
        case nextWeek = "Next 7 Days"
    }
    
    public init(type: DayType) {
        self.type = type
    }
}
