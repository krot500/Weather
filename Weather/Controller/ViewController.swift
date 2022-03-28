//
//  ViewController.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 25/03/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var addWeather: WeatherAddModel?
    var weatherManager = WeatherManager()
    
    let const = Constant()
    var city = [City]()

    @IBOutlet weak var hourlyWeather: UICollectionView!
    
    @IBOutlet weak var cityLabel: UILabel!
    
    @IBOutlet weak var tempLabel: UILabel!
    
    @IBOutlet weak var degreesLabel: UILabel!
    
    @IBOutlet weak var weaherImage: UIImageView!
    
    @IBOutlet weak var dailyWeatherTable: UITableView!
    
    @IBOutlet weak var menuButton: UIButton!
    
    @IBOutlet weak var starButton: UIButton!
    
    @IBOutlet weak var welcomeField: UITextField!
    
    @IBOutlet weak var blurView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityList()

        cofigureTextField()
        
        weatherManager.delegate = self
        
        
        if city.isEmpty {
            blurView.isHidden = false
        } else {
            blurView.isHidden = true
        }
        
        
        
        for index in city.indices {
            if city[index].isDisplay {
                if let name = city[index].name{
                    weatherManager.fetchWeather(cityName: name)
                    print(name)
                }
            }
        }
                  
            //register cell
        let collectCell = UINib(nibName: const.collectionCellID, bundle: nil)
        hourlyWeather.register(collectCell, forCellWithReuseIdentifier: const.collectionCellID)
        
        let tableCell = UINib(nibName: const.tableCellID, bundle: nil)
        dailyWeatherTable.register(tableCell, forCellReuseIdentifier: const.tableCellID)
        
        dailyWeatherTable.separatorStyle = .none
        
        dailyWeatherTable.reloadData()
        hourlyWeather.reloadData()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    
    @IBAction func toListOfCity(_ sender: UIButton) {
        performSegue(withIdentifier: const.toMenuSegue, sender: nil)
    }
    
    @IBAction func makeStar(_ sender: UIButton) {
    
    }
    
    @IBAction func searchFirst(sender: UIButton) {
        
    }
    
}


    //MARK: - Textfield Stuff

extension ViewController: UISearchTextFieldDelegate {
    
    func cofigureTextField() {
        welcomeField.clearButtonMode = .always
    }
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let name = welcomeField.text {
            weatherManager.fetchWeather(cityName: name)
            let city = City(context: self.context)
            city.name = name
            city.isDisplay = true
            self.city.append(city)
            saveCityList()
            blurView.isHidden = true
        }
        
        return true
    }
    
    
    
    
}


    //MARK: - Core Data Stuff



extension ViewController {
    
   
    
    private func loadCityList() {
        let request: NSFetchRequest<City> = City.fetchRequest()
        do {
            try city = context.fetch(request)
        } catch {
            print("Loading error \(error)")
        }
    }
    


    private func saveCityList() {
        do {
            try context.save()
        } catch {
            print("Save error: \(error)")
        }
    }
    
}




    //MARK: - COLLECTION VIEW STUFF


extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 24
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: const.collectionCellID, for: indexPath) as! CustomCollectionViewCell
        if let weather = addWeather {
            cell.hourLabel.text = weather.hourString(dt: weather.hourly[indexPath.row].dt)
            cell.weatherLabel.text = "\(weather.temperatureString(temp: weather.hourly[indexPath.row].temp))°C"
            cell.weatherImage.image = UIImage(systemName: weather.conditionName(conditionId: weather.hourly[indexPath.row].weather[0].id))
        }
               
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset: CGFloat = 10
        return UIEdgeInsets(top: inset, left: inset, bottom: inset, right: inset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 130)
    }
    
    
}


    //MARK: - TABLE VIEW STUFF


extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: const.tableCellID) as! CustomTableViewCell
        if let weather = addWeather {
            let date = weather.dayString(dt: weather.daily[indexPath.row].dt)
            cell.dateLabel.text = date.0
            cell.dayLabel.text = date.1
            cell.weatherImage.image = UIImage(systemName: weather.conditionName(conditionId: weather.daily[indexPath.row].weather[0].id))
            cell.tempLabel.text = "\(weather.daily[indexPath.row].temp)°C"
        }
       
        return cell
    }
    
    
}


    //MARK: - Weather Manager Stuff


extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeatherAdditional(_ weatherManager: WeatherManager, weather: WeatherAddModel) {
        DispatchQueue.main.async {
            self.addWeather = WeatherAddModel(timezone_offset: weather.timezone_offset, hourly: weather.hourly, daily: weather.daily)
            self.hourlyWeather.reloadData()
            self.dailyWeatherTable.reloadData()
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        print("current")
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.tempLabel.text = weather.temperatureString
            self.weaherImage.image = UIImage(systemName: weather.conditionName)
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
    
}
