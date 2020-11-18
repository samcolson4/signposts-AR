//
//  SignCreationViewController.swift
//  signposts-again
//
//  Created by Connor Worthington on 16/11/2020.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class SignCreationViewController: UIViewController {
    
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    var signText = ""
    var user = Auth.auth().currentUser
    var locManager = CLLocationManager()

    
    @IBOutlet weak var signTextField: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit.layer.cornerRadius = 4
    }
    

    @IBAction func submitBtnPressed(_ sender: UIButton) {
         signText = signTextField.text ?? ""
         // fix to avoid breaking on nil
         if (signTextField.text != "") {
            addSign(message: signText, username: (self.user?.displayName)!)
 //            library.addNewSign(message: sender.text!, location: GeoPoint(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude))
            self.performSegue(withIdentifier: "textEntered", sender: self)
             // library.addNewSign(message: sender.text!)
         }
         signTextField.text = ""
     }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "textEntered" {
            let vc = segue.destination as! AugmentedViewController
//            vc.text = signText
        }
    }
    
    func addSign(message: String, username: String) {
        let currentLocation: CLLocation
        currentLocation = locManager.location!
        library.addNewSign(message: signText, location: GeoPoint(latitude: currentLocation.coordinate.latitude, longitude: currentLocation.coordinate.longitude), username: username)
    }


}
