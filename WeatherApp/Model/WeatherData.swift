//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Maria Agatha España on 10/23/19.
//  Copyright © 2019 Maria Agatha España. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let timezone: String
    let currently: Currently
}

struct Currently: Codable {
    let icon: String
    let temperature: Double
    let summary: String
}
