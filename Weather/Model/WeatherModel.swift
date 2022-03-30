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
    let feelsLike: Double
    let windSpeed: Double
    let windDeg: Int
    let sunrise: Int
    let sunset: Int
    let dt: Int
    
    var isNight: Bool {
        if dt > sunrise && dt < sunset {
            return false
        }
        return true
    }
    
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
    func additionalString() -> String {
        let feelsLikeTemp = String(format: "%.0f", feelsLike)
        let windSpeedStr = String(format:"%.1f", windSpeed)
        let str = "Feels like: \(feelsLikeTemp)°C    Wind: \(windSpeedStr) m/s, \(windDirection)"
        return str
    }
    
    var windDirection: String {
        switch windDeg {
        case 0...22:
            return "N"
        case 23...67:
            return "NE"
        case 68...112:
            return "E"
        case 113...157:
            return "SE"
        case 158...202:
            return "S"
        case 203...247:
            return "SW"
        case 248...292:
            return "W"
        case 292...334:
            return "NW"
        case 335...360:
            return "N"
        default:
            return "N/A"
            
        }
    }
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...504:
            if isNight {
                return "cloud.moon.rain"
            }
            return "cloud.sun.rain"
        case 511...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            if isNight {
                return "moon"
            }
            return "sun.max"
        case 801:
            if isNight {
                return "cloud.moon"
            }
            return "cloud.sun"
        case 802:
            return "cloud"
        case 803...804:
            return "smoke"
        default:
            return "cloud"
        }
    }
    
    
    
}
