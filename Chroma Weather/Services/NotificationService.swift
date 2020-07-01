//
//  NotificationService.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 28.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import UserNotifications
import AFDateHelper
import RealmSwift
import CoreLocation
import WeatherAPIKit

class NotificationService {
    
    static var shared: NotificationService {
        let notificationService = NotificationService()
        return notificationService
    }
    
    private let realm = try! Realm()
    
    private var realmLocations: Results<RealmLocation> {
        return self.realm.objects(RealmLocation.self)
    }
    
    private let notificationCenter = UNUserNotificationCenter.current()
    private let options: UNAuthorizationOptions = [.alert, .sound, .badge]
    
    private init(){     }
    
    func initNotifications() {
        notificationCenter.requestAuthorization(options: options) {
            (didAllow, error) in
            if !didAllow {
                print("User has declined notifications")
            }
        }
    }
    
    func setupNotification() {
        let location = CLLocation(latitude: realmLocations[0].latitude, longitude: realmLocations[0].longitude)
        APIProvider.shared.getCurrentForecast(location: location) { (result) in
            switch result {
            case .success(let forecast):
                guard let temp = forecast.main?.temp.toCelsius(),
                    let humidity = forecast.main?.humidity,
                    let windSpeed = forecast.wind?.speed,
                    let feelsLike = forecast.main?.feelsLike.toCelsius(),
                    let pressure = forecast.main?.pressure else {return}
                let title = "\(temp)C - \(forecast.weather[0].weatherDescription.capitalizingFirstLetter())"
                let body = """
                Humidity: \(humidity)%
                Wind: \(windSpeed)km/hr
                Feels like: \(feelsLike)C
                Pressure: \(pressure)hPa
                """
                self.scheduleNotification(title: title, body: body)
                break
            case .failure(()):
                break
            }
        }
    }
    
    fileprivate func scheduleNotification(title: String, body: String) {
        
        let content = UNMutableNotificationContent()
        let userActions = "User Actions"

        let badge = Settings.shared.badgeCounter
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        content.badge = badge
        content.categoryIdentifier = userActions
        
        let calendar = Calendar.current
        let date = Date()

        let triggerDate: Date = date.addingTimeInterval(10)
        let triggerDateComponents = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: triggerDate)

        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDateComponents, repeats: false)

        let identifier = "\(title)\(Date().timeIntervalSince1970)"
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userActions, actions: [deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])
        Settings.shared.serializeBangeCounter(badge: NSNumber(value: badge.intValue + 1))
    }
}
