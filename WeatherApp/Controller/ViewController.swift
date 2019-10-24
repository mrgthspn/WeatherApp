//
//  ViewController.swift
//  WeatherApp
//
//  Created by Maria Agatha España on 10/23/19.
//  Copyright © 2019 Maria Agatha España. All rights reserved.
//

import UIKit

class ViewController: UIViewController, WeatherDelegate {
    
    @IBOutlet weak var weatherImage: UIImageView!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var summaryLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    let weatherManager = WeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        weatherManager.delegate = self
        weatherManager.getWeather()
    }
    
    func weatherDidChange(weatherModel: WeatherModel) {
        weatherImage.image = UIImage(systemName: weatherModel.icon)
        tempLabel.text = "\(weatherModel.temperature)°F"
        summaryLabel.text = weatherModel.summary
        locationLabel.text = weatherModel.timezone
    
    }


}

