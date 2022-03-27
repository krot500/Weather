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
    
    var city = [City]()
    
    
    @IBOutlet weak var searchField: UITextField!
    
    @IBOutlet weak var cityTable: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       // let cityTableCell = UINib(nibName: const.tableCellID, bundle: nil)

       
    }
    
    @IBAction func backToMain(_ sender: UIButton) {
    }
    
}

extension MenuController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let row = city.count
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cityTable.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = "test"
        cell.textLabel?.textAlignment = .center
        //cell?.textLabel = city[indexPath].name ?? " "
        return cell
    }
    
    
    
}
