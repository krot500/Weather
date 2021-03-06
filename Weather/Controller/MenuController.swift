//
//  MenuController.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 26/03/2022.
//

import UIKit
import CoreData





class MenuController: UIViewController {
    
    let const = Constant()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var city = [City]()
    
    var cityName = ""
    
    let weatherManager = WeatherManager()
    
    
    
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var cityTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCityList()
        
      

       
    }
    
    @IBAction func backToWeather(dender: UIButton) {
        self.performSegue(withIdentifier: const.toMain, sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == const.toMain {
            let destinationVC = segue.destination as! ViewController
            destinationVC.cityName = cityName
        }
    }
    
}



extension MenuController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if let city =  searchField.text {
            cityName = city
            performSegue(withIdentifier: const.toMain, sender: self)
            cityName = ""
        }
        
        searchField.endEditing(true)
        return true
    }
    
    
    
}




extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row = city.count
        return row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = city[indexPath.row].name
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.font = UIFont(name: "AvenirNext-Regular", size: 25)
        cell.alpha = 0
        UIView.animate(withDuration: 1, animations: {cell.alpha = 1})
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let name = cityTable.cellForRow(at: indexPath)?.textLabel?.text {
            cityName = name
            cityTable.deselectRow(at: indexPath, animated: true)
            for index in city.indices {
                if city[index].name != cityName {
                    city[index].isDisplay = false
                } else {
                    city[index].isDisplay = true
                }
            }
            performSegue(withIdentifier: const.toMain, sender: self)
        }
        
        
    }
    
    
    
}


//MARK: - Core Data Stuff



extension MenuController {



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
