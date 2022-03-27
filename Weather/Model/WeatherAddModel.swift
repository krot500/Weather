//
//  WeatherAddModel.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 27/03/2022.
//

import Foundation

struct WeatherAddModel {
    var timezone_offset: Int
    var hourly: [Hourly]
    var daily: [Daily]
    
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
}
