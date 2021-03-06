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
    let userDefaults = UserDefaults.standard
    var addWeather: WeatherAddModel?
    var weatherManager = WeatherManager()
    
    
    let const = Constant()
    var city = [City]()
    var cityName: String = ""
    
    let refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        
        return refreshControl
    }()
    
    
    //MARK: - OUTLETS

    
    @IBOutlet weak var scrollView: UIScrollView!
    
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
    
    @IBOutlet weak var feelsLikeWinterLabel: UILabel!
    
    
    //MARK: - METHODS OF CLASS
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityList()
        cofigureTextField()
        weatherManager.delegate = self
        scrollView.refreshControl = refreshControl
        
        
             
        
        
        if city.isEmpty {
            blurView.isHidden = false
        } else {
            blurView.isHidden = true
        }
        
        
        if userDefaults.bool(forKey: "run") {
            runningApp()
            userDefaults.set(false, forKey: "run")
        } else if cityName != "" {
            weatherManager.fetchWeather(cityName: cityName)
        } else {
            runningApp()
        }
        
        
        
        
        cityName = ""
                  
            //register cell
        let collectCell = UINib(nibName: const.collectionCellID, bundle: nil)
        hourlyWeather.register(collectCell, forCellWithReuseIdentifier: const.collectionCellID)
        
        let tableCell = UINib(nibName: const.tableCellID, bundle: nil)
        dailyWeatherTable.register(tableCell, forCellReuseIdentifier: const.tableCellID)
        
        dailyWeatherTable.separatorStyle = .none
        dailyWeatherTable.allowsSelection = false
        
        dailyWeatherTable.reloadData()
        hourlyWeather.reloadData()
        
    }
    
    
    
    
    @IBAction func toListOfCity(_ sender: UIButton) {
        performSegue(withIdentifier: const.toMenuSegue, sender: nil)
    }
    
    @IBAction func makeStar(_ sender: UIButton) {
        var indicator = true
        
        for index in city.indices {
            if cityLabel.text?.trimmingCharacters(in: .whitespaces) == city[index].name?.trimmingCharacters(in: .whitespaces) {
                context.delete(city[index])
                city.remove(at: index)
                if city.isEmpty {
                    viewDidLoad()
                } else {
                    city[0].isDisplay = true
                }
                
                saveCityList()
                indicator = false
                configureStarButton()
                return
               
            }
        }
        if indicator {
            let name = cityLabel.text
            let city = City(context: self.context)
            city.name = name
            
            city.isDisplay = true
            for index in self.city.indices {
                self.city[index].isDisplay = false
            }
            self.city.append(city)
            saveCityList()
            
        }
        configureStarButton()

    
    }
    
    @IBAction func searchFirst(sender: UIButton) {
        if let name = welcomeField.text {
            
            blurView.isHidden = true
            view.endEditing(true)
            weatherManager.fetchWeather(cityName: name)
            
        }
    }
    
    
    @objc
    private func refresh(sender: UIRefreshControl) {
        if let name = cityLabel.text{
            weatherManager.fetchWeather(cityName: name)
            hourlyWeather.reloadData()
            dailyWeatherTable.reloadData()
        }
        sender.endRefreshing()
        
    }
    
    
        // function to configure first weather info, when app is launching
    private func runningApp() {
        for index in city.indices {
            if city[index].isDisplay {
                if let name = city[index].name{
                    weatherManager.fetchWeather(cityName: name)
                }
            }
        }
    }
    
    
    
        // configure star button depends on if city in the database
    private func configureStarButton() {
        
        for index in city.indices {

            if cityLabel.text?.trimmingCharacters(in: .whitespaces) == city[index].name?.trimmingCharacters(in: .whitespaces) {
                
                self.starButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
                return
            } else {
                self.starButton.setImage(UIImage(systemName: "star"), for: .normal)
            }
        }
        if city.isEmpty {
            self.starButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
}


    //MARK: - WELCOME TEXT FIELD STUFF


extension ViewController: UISearchTextFieldDelegate {
    
    func cofigureTextField() {
        welcomeField.clearButtonMode = .always
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let name = welcomeField.text {
            
            blurView.isHidden = true
            view.endEditing(true)
            weatherManager.fetchWeather(cityName: name)
            
        }
        
        return true
    }
    
    
    
    
}


    //MARK: - CORE DATA STAFF


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


    //MARK: - HOURLY FORECAST COLLECTION VIEW STUFF


extension ViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
        
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 23
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: const.collectionCellID, for: indexPath) as! CustomCollectionViewCell
        if let weather = addWeather {
            cell.hourLabel.text = weather.hourString(dt: weather.hourly[indexPath.row].dt)
            cell.weatherLabel.text = "\(weather.temperatureToString(temp: weather.hourly[indexPath.row].temp))"
            cell.weatherImage.image = UIImage(systemName: weather.conditionName(conditionId: weather.hourly[indexPath.row].weather[0].id,
                                                                                isNight: weather.isNight(dt: weather.hourly[indexPath.row].dt)))
            cell.alpha = 0
            UIView.animate(withDuration: 1, animations: {cell.alpha = 1})
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


    //MARK: - DAILY FORECAST TABLE VIEW STUFF


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
            cell.dateLabel.text = date.day
            cell.dayLabel.text = date.weekDay
            cell.weatherImage.image = UIImage(systemName: weather.conditionName(conditionId: weather.daily[indexPath.row].weather[0].id, isNight: false))
            cell.tempLabel.text = "\(weather.temperatureToString(temp: weather.daily[indexPath.row].temp.day))/\(weather.temperatureToString(temp: weather.daily[indexPath.row].temp.night))"
            cell.alpha = 0
            UIView.animate(withDuration: 2, animations: {cell.alpha = 1})
            
        }
       
        return cell
    }
    
    
}


    //MARK: - Weather Manager DELEGATE


extension ViewController: WeatherManagerDelegate {
    
    func didUpdateWeatherAdditional(_ weatherManager: WeatherManager, weather: WeatherAddModel) {
        DispatchQueue.main.async {
            self.addWeather = WeatherAddModel(timezone_offset: weather.timezone_offset, hourly: weather.hourly,
                                              daily: weather.daily, sunrise: weather.sunrise, sunset: weather.sunset)
            self.hourlyWeather.reloadData()
            self.dailyWeatherTable.reloadData()
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        if self.city.isEmpty {
            let city = City(context: self.context)
            city.name = weather.cityName
            city.isDisplay = true
            self.city.append(city)
            self.saveCityList()
        }
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.tempLabel.text = weather.temperatureToString(temp: weather.temperature)
            self.weaherImage.image = UIImage(systemName: weather.conditionName)
            self.feelsLikeWinterLabel.text = weather.additionalString()
            
            self.configureStarButton()
        }
        
    }
    
    func didFailWithError(error: Error) {
        //print(error)
        let alert = UIAlertController(title: "Error", message: "We cannot find your location", preferredStyle: .alert)
        let action = UIAlertAction(title: "Try again", style: .default) { action in
            if self.city.isEmpty {
                self.welcomeField.isHidden = false
                self.viewDidLoad()
            } else {
                self.performSegue(withIdentifier: self.const.toMenuSegue, sender: self)
            }
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .default) { cancelAction in
            self.userDefaults.set(true, forKey: "run")
            self.viewDidLoad()
        }
        alert.addAction(action)
        alert.addAction(cancelAction)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    
}
