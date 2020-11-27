//
//  ViewController.swift
//  signposts-again
//
//  Created by Sam Colson on 10/11/2020.
//

import UIKit
import Firebase
import CoreLocation

class ViewController: UIViewController {
    
    let locationManager = CLLocationManager()
    let library = SignLibrary()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        library.getAllSigns()
        locationManager.requestAlwaysAuthorization()
    }
}

