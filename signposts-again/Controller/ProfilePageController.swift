//
//  ProfilePageController.swift
//  signposts-again
//
//  Created by Sam Colson on 15/11/2020.
//

import UIKit
import MapKit
import Firebase

class ProfilePageController: UIViewController {
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    var user = Auth.auth().currentUser
        
    @IBOutlet weak var profileMapView: MKMapView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNameLabel()
        displayUserSigns()
    }
    
    func updateNameLabel() {
        nameLabel.text = user?.email // TODO replace with code.
    }
    
    func displayUserSigns() {
        var signArray = [Sign]()
        
        library.returnDocs(completion: { (status, signs) in print(status, signs)
            
            for object in signs {
                let message = object.data()["message"]
                let date = object.data()["created"]
                let location = object.data()["geolocation"]
                
                let newSign = Sign(message: message as! String, date: date as! Timestamp, location: location as! GeoPoint)
                
                //if newSign.user == currentUser
                
                signArray.append(newSign)
                
                // else do nothing
                
                }
            
            for sign in signArray {
                let annotation = MKPointAnnotation()
        
                    let latitude = sign.location.latitude
                    let longtitude = sign.location.longitude
        
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    annotation.title = sign.message
                self.profileMapView.addAnnotation(annotation)
                
            }
            
        })
    }
    
    @IBAction func signOutPressed(_ sender: UIButton) {
        do {
            try Auth.auth().signOut()
            navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
