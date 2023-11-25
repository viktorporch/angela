//
//  WeatherResponse.swift
//  Clima
//
//  Created by Victor  on 24.11.2023
//

import Foundation

struct WeatherResponse: Codable {
    let weather: [Weather]
    let main: Main
    let name: String
}

struct Weather: Codable {
    let id: Int
}

struct Main: Codable {
    let temp: Double
}
