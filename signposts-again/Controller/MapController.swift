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

class MapController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    let locationManager = CLLocationManager()

    @IBOutlet weak var signmap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        signmap.delegate = self
        signmap.mapType = MKMapType.standard
        signmap.showsUserLocation = true
        
        displaySigns()
    }
    
    func displaySigns() {
        var signArray = [Sign]()
        
        library.returnDocs(completion: { (status, signs) in print(status, signs)
            
            for object in signs {
                let message = object.data()["message"]
                let date = object.data()["created"]
                let location = object.data()["geolocation"]
                let username = object.data()["username"]
                
                let newSign = Sign(message: message as! String, date: date as! Timestamp, location: location as! GeoPoint, username: username as? String)
                signArray.append(newSign)
                }
            
            for sign in signArray {
                let annotation = signAnnotation()
        
                let latitude = sign.location.latitude
                let longtitude = sign.location.longitude
    
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                annotation.title = sign.message
                annotation.subtitle = sign.username
//                annotation.pinCustomImageName = "1024Transparent"
                            
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                pinAnnotationView.canShowCallout = false

                self.signmap.addAnnotation(pinAnnotationView.annotation!)
                
//                self.signmap.addAnnotation(annotation)
            }
        })
    }
}


//extension MapController {
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//
//          let Identifier = "Pin"
//          let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: Identifier) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Identifier)
//
//          annotationView.canShowCallout = true
//          if annotation is MKUserLocation {
//             return nil
//          } else if annotation is signAnnotation {
//            annotationView.image = UIImage(contentsOfFile: "signpostsyellow")
//             return annotationView
//          } else {
//             return nil
//          }
//       }
//}
