//
//  WeatherModel.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 25/03/2022.
//

import Foundation


//for current


struct WeatherModel {
    let cityName: String
    let conditionId: Int
    let temperature: Double
    let lat: Double
    let lon: Double
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
    
    func temperatureToString(temp: Double) -> String {
        let intTemp = Int(temp)
        if intTemp > 0 {
            let newStr = "+\(String(intTemp))"
            return newStr
        } else {
            return "\(String(intTemp))"
        }
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud"
        default:
            return "cloud"
        }
    }
    
    
    
}
