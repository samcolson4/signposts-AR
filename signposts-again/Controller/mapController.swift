//
//  mapController.swift
//  signposts-again
//
//  Created by Sam Colson on 11/11/2020.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class MapController: UIViewController {
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()

    @IBOutlet weak var signmap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAllSigns()
//        makeSignsArray()
        
    }
    
//        let signs = library.returnSigns()
        
   
        
        
        
   
        
//        print(signs)
        
//        let annotation = MKPointAnnotation()
//
//        latitude = signs[0].location.latitude
//        longtitude = signs[0].location.longitude
//
//        annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
//        annotation.title = signs[0].message
//
//        signmap.addAnnotation(annotation)
        
        
//        for sign in signs {
//            let annotation = MKPointAnnotation()
//
//            latitude = sign.location.latitude
//            longtitude = sign.location.longitude
//
//
//            annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
//            annotation.title = sign.message
//            signmap.addAnnotation(annotation)
//        }
//

    func getAllSigns() {
        var signArray = [Sign]()
        
        library.returnDocs(completion: { (status, signs) in print(status, signs)
//            print(signs)
            
            for object in signs {
                let message = object.data()["message"]
                let date = object.data()["created"]
                let location = object.data()["geolocation"]
                
                let newSign = Sign(message: message as! String, date: date as! Timestamp, location: location as! GeoPoint)
                
                signArray.append(newSign)
                
                
                }
            
            for sign in signArray {
                let annotation = MKPointAnnotation()
        
                    let latitude = sign.location.latitude
                    let longtitude = sign.location.longitude
        
                    annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                    annotation.title = sign.message
                self.signmap.addAnnotation(annotation)
                
            }
            
        })
    }
    
    func makeSignsArray() {
//        var documents = [QueryDocumentSnapshot]()
        print(self.getAllSigns())
    }


}
