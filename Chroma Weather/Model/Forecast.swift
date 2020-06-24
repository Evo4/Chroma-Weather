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
    dynamic var coord: Coord? = nil
    dynamic var weather: [Weather] = []
    dynamic var base: String = ""
    dynamic var main: Stats? = nil
    dynamic var visibility: Int = 0
    dynamic var wind: Wind? = nil
    dynamic var clouds: Clouds? = nil
    dynamic var dt: Int = 0
    dynamic var sys: Sys? = nil
    dynamic var timezone: Int = 0
    dynamic var id: Int = 0
    dynamic var name: String = ""
    dynamic var cod: Int = 0
//    dynamic var hourlyForecast: [HourlyForecast]? = []
    
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
//        case hourlyForecast
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        coord = try container.decode(Coord.self, forKey: .coord)
        weather = try container.decode([Weather].self, forKey: .weather)
        base = try container.decode(String.self, forKey: .base)
        main = try container.decode(Stats.self, forKey: .main)
        visibility = try container.decode(Int.self, forKey: .visibility)
        wind = try container.decode(Wind.self, forKey: .wind)
        clouds = try container.decode(Clouds.self, forKey: .clouds)
        dt = try container.decode(Int.self, forKey: .dt)
        sys = try container.decode(Sys.self, forKey: .sys)
        timezone = try container.decode(Int.self, forKey: .timezone)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        cod = try container.decode(Int.self, forKey: .cod)
        
        
//        let forecasts = try container.decodeIfPresent([HourlyForecast].self, forKey: .hourlyForecast) ?? [HourlyForecast()]
//        hourlyForecast.append(objectsIn: forecasts)

    }
}

// MARK: - Clouds
@objcMembers class Clouds: Object, Codable {
    dynamic var all: Int = 0
    
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
    dynamic var lon: Double = 0.0
    dynamic var lat: Double = 0.0
    
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
    dynamic var temp: Double = 0.0
    dynamic var feelsLike: Double = 0.0
    dynamic var tempMin: Double = 0.0
    dynamic var tempMax: Double = 0.0
    dynamic var pressure: Int = 0
    dynamic var humidity: Int = 0

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
    dynamic var type: Int = 0
    dynamic var id: Int = 0
    dynamic var country: String = ""
    dynamic var sunrise: Int = 0
    dynamic var sunset: Int = 0
    
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
    dynamic var speed: Double = 0.0
    dynamic var deg: Double = 0.0
    
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

//// MARK: - Forecast
//struct Forecast: Codable {
//    let coord: Coord
//    let weather: [Weather]
//    let base: String
//    let main: Stats
//    let visibility: Int
//    let wind: Wind
//    let clouds: Clouds
//    let dt: Int
//    let sys: Sys
//    let timezone, id: Int
//    let name: String
//    let cod: Int
//    var hourlyForecast: [HourlyForecast]? = []
//}
//
//// MARK: - Clouds
//struct Clouds: Codable {
//    let all: Int
//}
//
//// MARK: - Coord
//struct Coord: Codable {
//    let lon, lat: Double
//}
//
//// MARK: - Main
//struct Stats: Codable {
//    let temp, feelsLike, tempMin, tempMax: Double
//    let pressure, humidity: Int
//
//    enum CodingKeys: String, CodingKey {
//        case temp
//        case feelsLike = "feels_like"
//        case tempMin = "temp_min"
//        case tempMax = "temp_max"
//        case pressure, humidity
//    }
//}
//
//// MARK: - Sys
//struct Sys: Codable {
//    let type, id: Int
//    let country: String
//    let sunrise, sunset: Int
//}
//
//// MARK: - Wind
//struct Wind: Codable {
//    let speed, deg: Double
//}
