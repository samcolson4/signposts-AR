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
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateNameLabel()
        updateAvatar()
        displayUserSigns()
    }
    
    func updateNameLabel() {
        nameLabel.text = user?.displayName // TODO replace with code.
    }
    
    func updateAvatar() {
        let url = user?.photoURL
        avatar.kf.setImage(with: url)
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
//        let url = URL(string: "https://i.ytimg.com/vi/muCshzf8k2Q/maxresdefault.jpg")
//        let processor = DownsamplingImageProcessor(size: avatar.bounds.size)
//                     |> RoundCornerImageProcessor(cornerRadius: 20)
//        avatar.kf.indicatorType = .activity
//        avatar.kf.setImage(
//            with: url,
//            placeholder: UIImage(named: "placeholderImage"),
//            options: [
//                .processor(processor),
//                .scaleFactor(UIScreen.main.scale),
//                .transition(.fade(1)),
//                .cacheOriginalImage
//            ])
//        {
//            result in
//            switch result {
//            case .success(let value):
//                print("Task done for: \(value.source.url?.absoluteString ?? "")")
//            case .failure(let error):
//                print("Job failed: \(error.localizedDescription)")
//            }
//        }
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
            self.performSegue(withIdentifier: "loggedOut", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
