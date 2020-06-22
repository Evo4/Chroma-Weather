//
//  Extensions.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 20.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import AFDateHelper

// MARK: - Double
extension Double {
    
    func toCelsius()->String {
        return "\(Int(self - 273.15))°"
    }
}

// MARK: - String
extension String {
    
    func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
}

// MARK: - Date
extension Date {
    func isEqualToDateIgnoringTime(date: Date) -> Bool
    {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date1Components = calendar.dateComponents([.year, .month, .day], from: self)
        let date2Components = calendar.dateComponents([.year, .month, .day], from: date)
        return (date1Components.year == date2Components.year) && (date1Components.month == date2Components.month) && (date1Components.day == date2Components.day)
//        let comp1 = Date.components(fromDate: self)
//        let comp2 = Date.components(fromDate: date)
//        return ((comp1.year == comp2.year) && (comp1.month == comp2.month) && (comp1.day == comp2.day))
    }
    
    /**
    Returns true if date is tomorrow.
    */
    func isTomorrow() -> Bool
    {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(byAdding: .day, value: 1, to: date) {
            return self.isEqualToDateIgnoringTime(date: date)
        } else {
            return self.isEqualToDateIgnoringTime(date: date)
        }
//        return self.isEqualToDateIgnoringTime(Date().dateByAddingDays(1))
//        return self.isEqualToDateIgnoringTime(date: )
    }
}
