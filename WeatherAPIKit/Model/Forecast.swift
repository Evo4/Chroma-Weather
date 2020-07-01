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
@objcMembers public class Forecast: Object, Codable {
    public var coord: Coord? = nil
    public var weather = List<Weather>()
    public var base: String = ""
    public var main: Stats? = nil
    public var visibility: Int = 0
    public var wind: Wind? = nil
    public var clouds: Clouds? = nil
    public var dt: Int = 0
    public var sys: Sys? = nil
    public var timezone: Int = 0
    public var id: Int = 0
    public var name: String = ""
    public var cod: Int = 0
    public var hourlyForecast = List<HourlyForecast>()
    public var forecastType: String = ""
    
    override public class func primaryKey() -> String? {
        return "forecastType"
    }
    
    public enum CodingKeys: String, CodingKey {
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
        case forecastType
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
        
        forecastType = try container.decodeIfPresent(String.self, forKey: .forecastType) ?? ""
    }
}

// MARK: - Clouds
@objcMembers public class Clouds: Object, Codable {
    public var all: Int = 0
    
    public enum CodingKeys: String, CodingKey {
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
@objcMembers public class Coord: Object, Codable {
    public var lon: Double = 0.0
    public var lat: Double = 0.0
    
    public enum CodingKeys: String, CodingKey {
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
@objcMembers public class Stats: Object, Codable {
    public var temp: Double = 0.0
    public var feelsLike: Double = 0.0
    public var tempMin: Double = 0.0
    public var tempMax: Double = 0.0
    public var pressure: Int = 0
    public var humidity: Int = 0

    public enum CodingKeys: String, CodingKey {
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
@objcMembers public class Sys: Object, Codable {
    public var type: Int = 0
    public var id: Int = 0
    public var country: String = ""
    public var sunrise: Int = 0
    public var sunset: Int = 0
    
    public enum CodingKeys: String, CodingKey {
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
@objcMembers public class Wind: Object, Codable {
    public var speed: Double = 0.0
    public var deg: Double = 0.0
    
    public enum CodingKeys: String, CodingKey {
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
