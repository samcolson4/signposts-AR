//
//  ProfilePageController.swift
//  signposts-again
//
//  Created by Sam Colson on 15/11/2020.
//

import UIKit
import MapKit
import Firebase
import Kingfisher

class ProfilePageController: UIViewController {
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    var user = Auth.auth().currentUser
        
    @IBOutlet weak var profileMapView: MKMapView!
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNameLabel()
        updateAvatar()
        imageBorder()
        displayUserSigns()
    }
    
    func updateNameLabel() {
        self.title = user?.displayName
    }
    
    func updateAvatar() {
        let url = user?.photoURL
        avatar.kf.setImage(with: url)
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.layer.masksToBounds = false
        avatar.clipsToBounds = true
    }
    
    func imageBorder() {
        avatar.layer.masksToBounds = true
        avatar.contentMode = .scaleAspectFill
        avatar.layer.borderWidth = 5
        
        let borderpicker = [0, 1, 2, 3, 4, 5, 6]
        if borderpicker.randomElement() == 0 {
            avatar.layer.borderColor = UIColor(red: 0.4, green: 0.7098, blue: 0.8863, alpha: 1).cgColor
        } else if borderpicker.randomElement() == 1 {
            avatar.layer.borderColor = UIColor(red: 0.9373, green: 0.7255, blue: 0.0745, alpha: 1).cgColor
        } else {
            avatar.layer.borderColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
        }
    }
    
    
    func displayUserSigns() {
        var signArray = [Sign]()
        
        library.returnDocs(completion: { (status, signs) in print(status, signs)
            
            for object in signs {
                let message = object.data()["message"]
                let date = object.data()["created"]
                let location = object.data()["geolocation"]
                let username = object.data()["username"]
                
                let newSign = Sign(message: message as! String, date: date as! Timestamp, location: location as! GeoPoint, username: username as? String)
                
                    if newSign.username == self.user?.displayName {
                        signArray.append(newSign)
                    }
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
            self.performSegue(withIdentifier: "loggedOut", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
