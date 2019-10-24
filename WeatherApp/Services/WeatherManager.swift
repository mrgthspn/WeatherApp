//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Maria Agatha España on 10/23/19.
//  Copyright © 2019 Maria Agatha España. All rights reserved.
//

import Foundation
import CoreLocation

protocol WeatherDelegate {
    func weatherDidChange(weatherModel: WeatherModel)
}

class WeatherManager : NSObject, CLLocationManagerDelegate {
    let weatherURL = "https://api.darksky.net/forecast/2bb07c3bece89caf533ac9a5d23d8417/"
    var delegate: WeatherDelegate?
    
    private let manager: CLLocationManager
    
    var weatherModel: WeatherModel
    
    override init() {
        self.manager = CLLocationManager()
        self.weatherModel = WeatherModel(icon: "sun.min", temperature: 0, summary: "", timezone: "")
    
        super.init()
        
        self.manager.delegate = self
    }
    
    func getWeather() {
        getLocation()
    }
    
    private func getLocation() {
        self.manager.requestWhenInUseAuthorization()
        self.manager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
         let latitude = locations.last?.coordinate.latitude ?? 0
         let longitude = locations.last?.coordinate.longitude ?? 0
        
         let urlString = "\(weatherURL)\(latitude),\(longitude)"
         doRequest(with: urlString)
       
     }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
    
    private func doRequest(with urlString: String) {
            if let url = URL(string: urlString) {
                let session = URLSession(configuration: .default)
                let task = session.dataTask(with: url) { (data, response, error) in
                    if error != nil {
                        return
                    }
                    if let safeData = data {
                        if let weather = self.parseJSON(safeData) {
                            DispatchQueue.main.async {
                                if let del = self.delegate {
                                    del.weatherDidChange(weatherModel: weather)
                                }
                            }
                        }
                    }
                }
                task.resume()
            }
        }
        
        private func parseJSON(_ weatherData: Data) -> WeatherModel? {
            let decoder = JSONDecoder()
            do {
                let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
                let summary = decodedData.currently.summary
                let temperature = decodedData.currently.temperature
                let icon = decodedData.currently.icon
                var timezone = decodedData.timezone
                
                timezone = timezone.replacingOccurrences(of: "_", with: " ")
                timezone = timezone.replacingOccurrences(of: "/", with: ", ")
                print(decodedData)
                let weather = WeatherModel(icon: getWeatherName(weatherId: icon), temperature: Int(temperature), summary: summary, timezone: timezone)
                print(weather)
                return weather
                
            } catch {
                return nil
            }
        }
        
        func getWeatherName(weatherId: String) -> String {
        switch weatherId {
        case "clear-day":
            return "sun.min"
        case "clear-night":
            return "moon.stars"
        case "rain":
            return "cloud.rain"
        case "snow":
            return "snow"
        case "sleet":
            return "cloud.sleet"
        case "wind":
            return "wind"
        case "fog":
            return "cloud.fog"
        case "cloud":
            return "cloud.fill"
        case "partly-cloudy-day":
            return "cloud"
        case "partly-cloudy-night":
            return "cloud.moon"
        default:
            return "sun.min"
        }
        
    }
}
