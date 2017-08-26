//
//  ViewController.swift
//  yandexKitTest
//
//  Created by Artem Alekseev on 24/08/2017.
//  Copyright © 2017 Artem Alekseev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let manager = APIManager()

    
    //MARK: ViewController Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        manager.loadPlaces(stringParameter: "караганда") {
            (places) in
            print("Places = \(places.first!)")
        }
    }
    
    //MARK: Methods

}

