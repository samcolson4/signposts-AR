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
    @IBOutlet weak var signTextField: UITextField!
    @IBOutlet weak var addNewSignBtn: UIButton!
    
    @IBOutlet weak var ViewMapBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        library.getAllSigns()
        
        locationManager.requestAlwaysAuthorization()
    }

    @IBAction func formSubmitted(_ sender: UITextField, forEvent event: UIEvent) {
        let currentLoc: CLLocation
        currentLoc = locationManager.location!
        // fix to avoid breaking on nil
        if (sender.text != "") {
            library.addNewSign(message: sender.text!, location: GeoPoint(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude))
        }
        sender.text = ""
    }
    
    @IBAction func addNewSignPressed(_ sender: UIButton) {
        //not currenty doing anything. Function and the button on the view can be deleted.
    }
    
    
    @IBAction func ViewMapPressed (_ sender: UIButton) {
    }
    
    
    
    
}

