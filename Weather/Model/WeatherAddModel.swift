//
//  WeatherAddModel.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 27/03/2022.
//

import Foundation


//for forecast


struct WeatherAddModel {
    var timezone_offset: Int
    var hourly: [Hourly]
    var daily: [Daily]
    
    func temperatureString(temp: Double) -> String {
        return String(format: "%.1f", temp)
    }
    
    func conditionName(conditionId: Int) -> String {
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
    
    func hourString(dt: Int) -> String {
        let interval = timezone_offset + dt
        let date = NSDate(timeIntervalSince1970: Double(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let hourString = dateFormatter.string(from: date as Date)
        return hourString
    }
    
    func dayString(dt: Int) -> (String, String) {
        let interval = timezone_offset + dt
        let date = NSDate(timeIntervalSince1970: Double(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .long
        dateFormatter.dateFormat = "MMM, d"
        let dayString = dateFormatter.string(from: date as Date)
        dateFormatter.dateFormat = "EEEE"
        let weekDayString = dateFormatter.string(from: date as Date)
        return (dayString, weekDayString)
    }
}
