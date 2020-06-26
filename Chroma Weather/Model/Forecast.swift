//
//  CurrentForecast.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 20.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm

// MARK: - Forecast
@objcMembers class Forecast: Object, Codable {
    var coord: Coord? = nil
    var weather = List<Weather>()
    var base: String = ""
    var main: Stats? = nil
    var visibility: Int = 0
    var wind: Wind? = nil
    var clouds: Clouds? = nil
    var dt: Int = 0
    var sys: Sys? = nil
    var timezone: Int = 0
    var id: Int = 0
    var name: String = ""
    var cod: Int = 0
    var hourlyForecast = List<HourlyForecast>()
    
    enum CodingKeys: String, CodingKey {
        case coord
        case weather
        case base
        case main
        case visibility
        case wind
        case clouds
        case dt
        case sys
        case timezone
        case id
        case name
        case cod
        case hourlyForecast
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coord = try container.decode(Coord.self, forKey: .coord)
        
        let weatherArr = try! container.decodeIfPresent([Weather].self, forKey: .weather) ?? [Weather()]
        weather.append(objectsIn: weatherArr)
        
        base = try container.decode(String.self, forKey: .base)
        main = try container.decodeIfPresent(Stats.self, forKey: .main)
        visibility = try container.decode(Int.self, forKey: .visibility)
        wind = try container.decodeIfPresent(Wind.self, forKey: .wind)
        clouds = try container.decodeIfPresent(Clouds.self, forKey: .clouds)
        dt = try container.decode(Int.self, forKey: .dt)
        sys = try container.decodeIfPresent(Sys.self, forKey: .sys)
        timezone = try container.decode(Int.self, forKey: .timezone)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cod = try container.decode(Int.self, forKey: .cod)
        
        let forecasts = try container.decodeIfPresent([HourlyForecast].self, forKey: .hourlyForecast) ?? [HourlyForecast()]
        hourlyForecast.append(objectsIn: forecasts)

    }
}

// MARK: - Clouds
@objcMembers class Clouds: Object, Codable {
    var all: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case all
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        all = try container.decode(Int.self, forKey: .all)
    }
}

// MARK: - Coord
@objcMembers class Coord: Object, Codable {
    var lon: Double = 0.0
    var lat: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case lon
        case lat
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lon = try container.decode(Double.self, forKey: .lon)
        lat = try container.decode(Double.self, forKey: .lat)
    }
}

// MARK: - Main
@objcMembers class Stats: Object, Codable {
    var temp: Double = 0.0
    var feelsLike: Double = 0.0
    var tempMin: Double = 0.0
    var tempMax: Double = 0.0
    var pressure: Int = 0
    var humidity: Int = 0

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure
        case humidity
    }
    
    public required convenience init(from decoder: Decoder) throws {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        temp = try container.decode(Double.self, forKey: .temp)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        tempMin = try container.decode(Double.self, forKey: .tempMin)
        tempMax = try container.decode(Double.self, forKey: .tempMax)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
    }
}

// MARK: - Sys
@objcMembers class Sys: Object, Codable {
    var type: Int = 0
    var id: Int = 0
    var country: String = ""
    var sunrise: Int = 0
    var sunset: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case type
        case id
        case country
        case sunrise
        case sunset
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(Int.self, forKey: .type)
        id = try container.decode(Int.self, forKey: .id)
        country = try container.decode(String.self, forKey: .country)
        sunrise = try container.decode(Int.self, forKey: .sunrise)
        sunset = try container.decode(Int.self, forKey: .sunset)
    }
}

// MARK: - Wind
@objcMembers class Wind: Object, Codable {
    var speed: Double = 0.0
    var deg: Double = 0.0
    
    enum CodingKeys: String, CodingKey {
        case speed
        case deg
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        speed = try container.decode(Double.self, forKey: .speed)
        deg = try container.decode(Double.self, forKey: .deg)
    }
}
