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
    
    
    
    func temperatureToString(temp: Double) -> String {
        let intTemp = Int(temp)
        if intTemp > 0 {
            let newStr = "+\(String(intTemp))°C"
            return newStr
        } else {
            return "\(String(intTemp))°C"
        }
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
        let timeDrift = timezone_offset - TimeZone.current.secondsFromGMT()
        let interval = timeDrift + dt
        let date = Date(timeIntervalSince1970: Double(interval))
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let systemDate = Date().timeIntervalSince1970
        let currentDate = systemDate + Double(timeDrift)
        if Double(interval) < currentDate {
            let hourString = "Now"
            return hourString
        } else {
            let hourString = dateFormatter.string(from: date as Date)
            return hourString
        }
        
    }
    
    func dayString(dt: Int) -> (day: String, weekDay: String) {
        let interval = /* timezone_offset +*/ dt
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
