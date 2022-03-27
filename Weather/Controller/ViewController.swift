//
//  ViewController.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 25/03/2022.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
              
        
        //register cell
        let collectCell = UINib(nibName: const.collectionCellID, bundle: nil)
        hourlyWeather.register(collectCell, forCellWithReuseIdentifier: const.collectionCellID)
        
        let tableCell = UINib(nibName: const.tableCellID, bundle: nil)
        dailyWeatherTable.register(tableCell, forCellReuseIdentifier: const.tableCellID)
        
        dailyWeatherTable.separatorStyle = .none
        
        dailyWeatherTable.reloadData()
        hourlyWeather.reloadData()
    }
    
    
    @IBAction func toListOfCity(_ sender: UIButton) {
        performSegue(withIdentifier: const.toMenuSegue, sender: nil)
    }
    
    @IBAction func makeStar(_ sender: UIButton) {
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
       
        return cell
    }
    
    
}


extension ViewController: WeatherManagerDelegate {
    func didUpdateWeatherAdditional(_ weatherManager: WeatherManager, weather: WeatherAddModel) {
        <#code#>
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        <#code#>
    }
    
    func didFailWithError(error: Error) {
        <#code#>
    }
    
    
}
