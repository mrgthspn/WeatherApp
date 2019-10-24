//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Maria Agatha España on 10/23/19.
//  Copyright © 2019 Maria Agatha España. All rights reserved.
//

import Foundation

struct WeatherModel: Decodable {
    let icon: String
    let temperature: Int
    let summary: String
    let timezone: String
    
}
