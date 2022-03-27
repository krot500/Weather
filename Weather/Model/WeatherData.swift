//
//  WeatherData.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 25/03/2022.
//


import Foundation



struct WeatherData: Decodable {
    var name: String
    var main: Main
    var weather: [Weather]
    var coord: Coord
    
}

struct Main: Decodable {
    var temp: Double
}

struct Weather: Decodable {
    var id: Int
}

struct Coord: Decodable {
    var lon: Double
    var lat: Double
}
