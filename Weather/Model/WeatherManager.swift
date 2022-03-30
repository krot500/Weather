//
//  WeatherManager.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 25/03/2022.
//

import Foundation

    
protocol WeatherManagerDelegate {
    func didUpdateWeatherAdditional(_ weatherManager: WeatherManager, weather: WeatherAddModel)
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    var weatherURL = "https://api.openweathermap.org/data/2.5/weather?units=metric&appid=376b3473587c04767666da6e1a04b295"
    var addWeatherURL = "https://api.openweathermap.org/data/2.5/onecall?&exclude=minutely,alerts&units=metric&appid=376b3473587c04767666da6e1a04b295"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather (cityName: String) {
        
        var preparedName = cityName.replacingOccurrences(of: " ", with: "%20")
        preparedName = preparedName.replacingOccurrences(of: "-", with: "%20")
        preparedName += "%20"   //need to openweather search City indtead of region (oblast)
        
        
        let urlString = "\(weatherURL)&q=\(preparedName)"
        performRequest(with: urlString)
    }
    
    
    //MARK: - Requesting
    
    
    // request weather form OpenWeather
    private func performRequest(with urlString: String) {
        
        var lon: Double = 0
        var lat: Double = 0
        let session = URLSession(configuration: .default)
        // current weather
        if let url = URL(string: urlString) {
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                        lat = weather.lat
                        lon = weather.lon
                        
                        // hourly and daily weather
                        if let newURL = URL(string: "\(addWeatherURL)&lat=\(lat)&lon=\(lon)") {
                            
                            let taskAdditional = session.dataTask(with: newURL) { data, response, error in
                                if error != nil {
                                    self.delegate?.didFailWithError(error: error!)
                                    return
                                }
                                if let safeData = data {
                                    if let weather = self.parseJSONAdd(safeData) {
                                        self.delegate?.didUpdateWeatherAdditional(self, weather: weather)
                                    }
                                }
                            }
                            taskAdditional.resume()
                        }
                    }
                }
            }
            task.resume()
        }
        
        
        
       
                        
    }
    
    
    //MARK: - Parsing
    // for current weather
    private func parseJSON (_ weatherData: Data) -> WeatherModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temperature = decodedData.main.temp
            let cityName = decodedData.name
            let lat = decodedData.coord.lat
            let lon = decodedData.coord.lon
            let feelsLike = decodedData.main.feels_like
            let windSpeed = decodedData.wind.speed
            let windDeg = decodedData.wind.deg
            let sunrise = decodedData.sys.sunrise
            let sunset = decodedData.sys.sunset
            let dt = decodedData.dt
            
            let weather = WeatherModel(cityName: cityName, conditionId: id,
                                       temperature: temperature, lat: lat, lon: lon,
                                       feelsLike: feelsLike, windSpeed: windSpeed,
                                       windDeg: windDeg, sunrise: sunrise, sunset: sunset, dt: dt)
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
        
    }
    // for forecast
    private func parseJSONAdd(_ weatherData: Data) -> WeatherAddModel? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(WeatherAddData.self, from: weatherData)
            let time_offset = decodedData.timezone_offset
            let hourlyWeather = decodedData.hourly
            let dailyWeather = decodedData.daily
            let sunrise = decodedData.current.sunrise
            let sunset = decodedData.current.sunset
            let weather = WeatherAddModel(timezone_offset: time_offset, hourly: hourlyWeather, daily: dailyWeather,
                                          sunrise: sunrise, sunset: sunset)
            
            return weather
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }   
        
    
}
