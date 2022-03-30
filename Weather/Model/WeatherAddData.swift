//
//  WeatherManagerAdditional.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 27/03/2022.
//

import Foundation


// fo forecast


struct WeatherAddData: Decodable {    
    var timezone_offset: Int
    var hourly: [Hourly]
    var daily: [Daily]
    var current: Current
}


struct Hourly: Decodable {
    var dt: Int
    var temp: Double
    var weather: [Weather]
}


struct Daily: Decodable {
    var dt: Int
    var temp: Temp
    var weather: [Weather]
}


struct Temp: Decodable {
    var day: Double
    var night: Double
}

struct Current: Decodable {
    var sunrise: Int
    var sunset: Int
}
