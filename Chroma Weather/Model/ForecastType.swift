//
//  ForecastType.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 19.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation

struct ForecastType {
    let type: DayType
    
    enum DayType: String {
        case today = "Today"
        case tomorrow = "Tomorrow"
        case nextWeek = "Next Week"
    }
}
