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
    
    public func toCelsius()->String {
        return "\(Int(self - 273.15))°"
    }
}

// MARK: - String
extension String {
    
    public func capitalizingFirstLetter() -> String {
        return prefix(1).capitalized + dropFirst()
    }

    public mutating func capitalizeFirstLetter() {
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
    
    public func isNextHour()-> Bool {
        return self.isNextHourOfDay(date: Date())
    }
    
    /**
    Returns Returns true if date is today.
    */
    public func isToday() -> Bool {
        return self.isEqualToDateIgnoringTime(date: Date())
    }
    
    public func isDay(of date: Date)-> Bool {
        return self.isEqualToDateIgnoringTime(date: date)
    }
    
    /**
    Returns true if date is tomorrow.
    */
    public func isTomorrow() -> Bool {
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
    public func roundCorners(corners: UIRectCorner, radius: CGFloat) {
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
    
    public func setGradientBackground(color1: UIColor, color2: UIColor) {
        let colorTop = color1.cgColor
        let colorBottom = color2.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height)

        self.layer.insertSublayer(gradientLayer, at:0)
    }
    
    public func setGradientBackground(color1: UIColor, color2: UIColor, width: CGFloat, height: CGFloat) {
        let colorTop = color1.cgColor
        let colorBottom = color2.cgColor

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = CGRect(x: 0, y: 0, width: width, height: height)

        self.layer.insertSublayer(gradientLayer, at:0)
    }
}

//MARK: - UIColor

extension UIColor {
    // MARK: - methods for color brightness
    public func lighter(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: abs(percentage) )
    }
    
    public func darker(by percentage: CGFloat = 30.0) -> UIColor? {
        return self.adjust(by: -1 * abs(percentage) )
    }
    
    public func adjust(by percentage: CGFloat = 30.0) -> UIColor? {
        var red: CGFloat = 0, green: CGFloat = 0, blue: CGFloat = 0, alpha: CGFloat = 0
        if self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) {
            return UIColor(red: min(red + percentage/100, 1.0),
                           green: min(green + percentage/100, 1.0),
                           blue: min(blue + percentage/100, 1.0),
                           alpha: alpha)
        } else {
            return nil
        }
    }
    
    static public let dayColors: [String : UIColor] = [
        "Monday" : #colorLiteral(red: 0.1568627451, green: 0.8784313725, blue: 0.6823529412, alpha: 1),
        "Tuesday" : #colorLiteral(red: 1, green: 0, blue: 0.5647058824, alpha: 1),
        "Wednesday" : #colorLiteral(red: 1, green: 0.6823529412, blue: 0, alpha: 1),
        "Thursday" : #colorLiteral(red: 0, green: 0.5647058824, blue: 1, alpha: 1),
        "Friday" : #colorLiteral(red: 0.862745098, green: 0, blue: 0, alpha: 1),
        "Saturday" : #colorLiteral(red: 0, green: 0.3176470588, blue: 1, alpha: 1),
        "Sunday" : #colorLiteral(red: 0.842262849, green: 0.3658883037, blue: 0, alpha: 1),
    ]
    
    static public func getDayColor(day: String)-> UIColor {
        if day == "Monday" {
            return UIColor.dayColors["Monday"]!
        }
        return UIColor.dayColors[day] ?? #colorLiteral(red: 0.1568627451, green: 0.8784313725, blue: 0.6823529412, alpha: 1)
    }
}
