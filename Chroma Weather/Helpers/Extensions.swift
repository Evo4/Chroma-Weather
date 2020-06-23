//
//  Extensions.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 20.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import UIKit
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
    private func isEqualToDateIgnoringTime(date: Date) -> Bool {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date1Components = calendar.dateComponents([.year, .month, .day], from: self)
        let date2Components = calendar.dateComponents([.year, .month, .day], from: date)
        return (date1Components.year == date2Components.year) && (date1Components.month == date2Components.month) && (date1Components.day == date2Components.day)
    }
    
    private func isNextHourOfDay(date: Date)-> Bool {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        let date1Components = calendar.dateComponents([.year, .month, .day, .hour], from: self)
        let date2Components = calendar.dateComponents([.year, .month, .day, .hour], from: date)
        return (date1Components.year == date2Components.year) && (date1Components.month == date2Components.month) && (date1Components.day == date2Components.day) && (date1Components.hour! > date2Components.hour!)
    }
    
    func isNextHour()-> Bool {
        return self.isNextHourOfDay(date: Date())
    }
    
    /**
    Returns Returns true if date is today.
    */
    func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(date: Date())
    }
    
    func isDay(of date: Date)-> Bool {
        return self.isEqualToDateIgnoringTime(date: date)
    }
    
    /**
    Returns true if date is tomorrow.
    */
    func isTomorrow() -> Bool {
        let date = Date()
        let calendar = Calendar(identifier: .gregorian)
        if let date = calendar.date(byAdding: .day, value: 1, to: date) {
            return self.isEqualToDateIgnoringTime(date: date)
        } else {
            return self.isEqualToDateIgnoringTime(date: date)
        }
    }
}

//MARK: - UIView
extension UIView {
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            self.clipsToBounds = true
            self.layer.cornerRadius = radius
            var masked = CACornerMask()
            if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
            if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
            if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
            if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
            self.layer.maskedCorners = masked
        }
        else {
            let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            layer.mask = mask
        }
    }
}
