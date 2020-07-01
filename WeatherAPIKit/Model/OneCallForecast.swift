//
//  Forecast.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 20.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation
import RealmSwift
import RxRealm

// MARK: - Forecast
@objcMembers public class OneCallForecast: Object, Codable {
    public var lat: Double = 0.0
    public var lon: Double = 0.0
    public var timezone: String = ""
    public var timezoneOffset: Int = 0
    public var current: Current? = nil
    public var hourly = List<HourlyForecast>()
    public var daily = List<DailyForecast>()

    public enum CodingKeys: String, CodingKey {
        case lat
        case lon
        case timezone
        case timezoneOffset = "timezone_offset"
        case current
        case hourly
        case daily
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        lat = try container.decode(Double.self, forKey: .lat)
        lon = try container.decode(Double.self, forKey: .lon)
        timezone = try container.decode(String.self, forKey: .timezone)
        timezoneOffset = try container.decode(Int.self, forKey: .timezoneOffset)
        current = try container.decode(Current.self, forKey: .current)
        
        let hourlyForecast = try container.decodeIfPresent([HourlyForecast].self, forKey: .hourly) ?? [HourlyForecast()]
        hourly.append(objectsIn: hourlyForecast)
        
        let dailyForecst = try container.decodeIfPresent([DailyForecast].self, forKey: .daily) ?? [DailyForecast()]
        daily.append(objectsIn: dailyForecst)
    }
}

// MARK: - Current
@objcMembers public class Current: Object, Codable {
    public var dt: Int = 0
    public var sunrise: Int = 0
    public var sunset: Int = 0
    public var temp: Double? = nil
    public var feelsLike: Double = 0.0
    public var pressure: Int = 0
    public var humidity: Int = 0
    public var dewPoint: Double = 0.0
    public var uvi: Double = 0.0
    public var clouds: Int = 0
    public var visibility: Int = 0
    public var windDeg: Int = 0
    public var windSpeed: Double = 0.0
    public var weather = List<Weather>()
    public var rain: Rain? = nil

    public enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case uvi, clouds, visibility
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dt = try container.decode(Int.self, forKey: .dt)
        sunrise = try container.decode(Int.self, forKey: .sunrise)
        sunset = try container.decode(Int.self, forKey: .sunset)
        temp = try container.decode(Double.self, forKey: .temp)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        dewPoint = try container.decode(Double.self, forKey: .dewPoint)
        uvi = try container.decode(Double.self, forKey: .uvi)
        clouds = try container.decode(Int.self, forKey: .clouds)
        visibility = try container.decode(Int.self, forKey: .visibility)
        windDeg = try container.decode(Int.self, forKey: .windDeg)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        
        let weatherArr = try container.decodeIfPresent([Weather].self, forKey: .weather) ?? [Weather()]
        weather.append(objectsIn: weatherArr)
    
        rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
    }
}

// MARK: - Rain
@objcMembers public class Rain: Object, Codable {
    public var the1H: Double = 0.0

    public enum CodingKeys: String, CodingKey {
        case the1H = "1h"
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        the1H = try container.decode(Double.self, forKey: .the1H)
    }
}

// MARK: - Weather
@objcMembers public class Weather: Object, Codable {
    public var id: Int = 0
    public var main: String = ""
    public var weatherDescription: String = ""
    public var icon: String = ""

    public enum CodingKeys: String, CodingKey {
        case id, main
        case weatherDescription = "description"
        case icon
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        main = try container.decode(String.self, forKey: .main)
        weatherDescription = try container.decode(String.self, forKey: .weatherDescription)
        icon = try container.decode(String.self, forKey: .icon)
    }
}

public enum Main: String, Codable {
    case clear = "Clear"
    case clouds = "Clouds"
    case rain = "Rain"
}

// MARK: - Daily
@objcMembers public class DailyForecast: Object, Codable {
    public var dt: Int = 0
    public var sunrise: Int = 0
    public var sunset: Int = 0
    public var temp: Temp? = nil
    public var feelsLike: FeelsLike? = nil
    public var pressure: Int = 0
    public var humidity: Int = 0
    public var dewPoint: Double = 0.0
    public var windSpeed: Double = 0.0
    public var windDeg: Double = 0.0
    public var weather = List<Weather>()
    public var clouds: Int = 0
    public var rain: Double? = nil
    public var uvi: Double? = nil

    public enum CodingKeys: String, CodingKey {
        case dt, sunrise, sunset, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, clouds, rain, uvi
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dt = try container.decode(Int.self, forKey: .dt)
        sunrise = try container.decode(Int.self, forKey: .sunrise)
        sunset = try container.decode(Int.self, forKey: .sunset)
        temp = try container.decode(Temp.self, forKey: .temp)
        feelsLike = try container.decode(FeelsLike.self, forKey: .feelsLike)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        dewPoint = try container.decode(Double.self, forKey: .dewPoint)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        windDeg = try container.decode(Double.self, forKey: .windDeg)
        
        let weatherArr = try container.decodeIfPresent([Weather].self, forKey: .weather) ?? [Weather()]
        weather.append(objectsIn: weatherArr)
        
        clouds = try container.decode(Int.self, forKey: .clouds)
        rain = try container.decodeIfPresent(Double.self, forKey: .rain)
        uvi = try container.decodeIfPresent(Double.self, forKey: .uvi)
    }
}

// MARK: - FeelsLike
@objcMembers public class FeelsLike: Object, Codable {
    public var day: Double = 0.0
    public var night: Double = 0.0
    public var eve: Double = 0.0
    public var morn: Double = 0.0
    
    public enum CodingKeys:String, CodingKey {
        case day, night, eve, morn
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Double.self, forKey: .day)
        night = try container.decode(Double.self, forKey: .night)
        eve = try container.decode(Double.self, forKey: .eve)
        morn = try container.decode(Double.self, forKey: .morn)
    }
}

// MARK: - Temp
@objcMembers public class Temp: Object, Codable {
    public var day: Double = 0.0
    public var min: Double = 0.0
    public var max: Double = 0.0
    public var night: Double = 0.0
    public var eve: Double = 0.0
    public var morn: Double = 0.0
    
    public enum CodingKeys:String, CodingKey {
        case day, min, max, night, eve, morn
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        day = try container.decode(Double.self, forKey: .day)
        min = try container.decode(Double.self, forKey: .min)
        max = try container.decode(Double.self, forKey: .max)
        night = try container.decode(Double.self, forKey: .night)
        eve = try container.decode(Double.self, forKey: .eve)
        morn = try container.decode(Double.self, forKey: .morn)
    }
}

// MARK: - Hourly
@objcMembers public class HourlyForecast: Object, Codable {
    public var dt: Int = 0
    public var temp: Double = 0.0
    public var feelsLike: Double = 0.0
    public var pressure: Int = 0
    public var humidity: Int = 0
    public var dewPoint: Double = 0.0
    public var clouds: Int = 0
    public var windSpeed: Double = 0.0
    public var windDeg: Int = 0
    public var weather = List<Weather>()
    public var rain: Rain? = nil
    
    public enum CodingKeys: String, CodingKey {
        case dt, temp
        case feelsLike = "feels_like"
        case pressure, humidity
        case dewPoint = "dew_point"
        case clouds
        case windSpeed = "wind_speed"
        case windDeg = "wind_deg"
        case weather, rain
    }
    
    public required convenience init(from decoder: Decoder) throws
    {
        self.init()
        let container = try decoder.container(keyedBy: CodingKeys.self)
        dt = try container.decode(Int.self, forKey: .dt)
        temp = try container.decode(Double.self, forKey: .temp)
        feelsLike = try container.decode(Double.self, forKey: .feelsLike)
        pressure = try container.decode(Int.self, forKey: .pressure)
        humidity = try container.decode(Int.self, forKey: .humidity)
        dewPoint = try container.decode(Double.self, forKey: .dewPoint)
        clouds = try container.decode(Int.self, forKey: .clouds)
        windSpeed = try container.decode(Double.self, forKey: .windSpeed)
        windDeg = try container.decode(Int.self, forKey: .windDeg)
        
        let weatherArr = try container.decodeIfPresent([Weather].self, forKey: .weather) ?? [Weather()]
        weather.append(objectsIn: weatherArr)
        
        rain = try container.decodeIfPresent(Rain.self, forKey: .rain)
    }
}
