//
//  WeatherData.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 25/03/2022.
//


import Foundation


// for current weather


struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]
    var coord: Coord
    var wind: Wind
    
}

struct Main: Decodable {
    var temp: Double
    var feels_like: Double
}
// used both for current and for forecast(daily, hourly)
struct Weather: Decodable {
    var id: Int
}

struct Coord: Decodable {
    var lon: Double
    var lat: Double
}

struct Wind: Decodable {
    var speed: Double
    var deg: Int
}
