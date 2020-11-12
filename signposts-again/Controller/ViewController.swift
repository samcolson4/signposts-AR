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
    var signText = ""
    @IBOutlet weak var signTextField: UITextField!
    @IBOutlet weak var addNewSignBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        library.getAllSigns()
        
        locationManager.requestAlwaysAuthorization()
    }

    @IBAction func formSubmitted(_ sender: UITextField, forEvent event: UIEvent) {
        let currentLoc: CLLocation
        currentLoc = locationManager.location!
        signText = sender.text ?? ""
        // fix to avoid breaking on nil
        if (sender.text != "") {
//            library.addNewSign(message: sender.text!, location: GeoPoint(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude))
            self.performSegue(withIdentifier: "textEntered", sender: self)
            // library.addNewSign(message: sender.text!)
        }
        sender.text = ""
    }
    
    @IBAction func addNewSignPressed(_ sender: UIButton) {
        //not currenty doing anything. Function and the button on the view can be deleted.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is ARViewController {
//            segue.destination as! ARViewController
            TextContainer.signText = signText
        }
    }
}

struct TextContainer {
    static var signText = ""
}
