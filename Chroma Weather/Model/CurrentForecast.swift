//
//  CurrentForecast.swift
//  Chroma Weather
//
//  Created by Vyacheslav on 20.06.2020.
//  Copyright © 2020 Vyacheslav. All rights reserved.
//

import Foundation

// MARK: - Forecast
struct CurrentForecast: Codable {
    let coord: Coord
    let weather: [Weather]
    let base: String
    let main: Stats
    let visibility: Int
    let wind: Wind
    let clouds: Clouds
    let dt: Int
    let sys: Sys
    let timezone, id: Int
    let name: String
    let cod: Int
}

// MARK: - Clouds
struct Clouds: Codable {
    let all: Int
}

// MARK: - Coord
struct Coord: Codable {
    let lon, lat: Double
}

// MARK: - Main
struct Stats: Codable {
    let temp, feelsLike, tempMin, tempMax: Double
    let pressure, humidity: Int

    enum CodingKeys: String, CodingKey {
        case temp
        case feelsLike = "feels_like"
        case tempMin = "temp_min"
        case tempMax = "temp_max"
        case pressure, humidity
    }
}

// MARK: - Sys
struct Sys: Codable {
    let type, id: Int
    let country: String
    let sunrise, sunset: Int
}

// MARK: - Wind
struct Wind: Codable {
    let speed, deg: Double
}
