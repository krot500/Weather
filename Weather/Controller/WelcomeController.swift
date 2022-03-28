//
//  WelcomeController.swift
//  Weather
//
//  Created by Nikita Sibirtsev on 27/03/2022.
//

import UIKit

class WelcomeController: UIViewController {
    
    
    @IBOutlet weak var welcomeField: UITextField!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        


    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }

    

}
