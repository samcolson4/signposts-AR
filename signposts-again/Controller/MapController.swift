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
        
        signmap.delegate = self
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
//                annotation.pinCustomImageName = "1024v4"
                            
                let pinAnnotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "pin")
                pinAnnotationView.canShowCallout = true
                self.signmap.addAnnotation(pinAnnotationView.annotation!)
                
                
//                self.signmap.addAnnotation(annotation)
            }
        })
    }
    
//    private func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
//        print(error.localizedDescription)
//    }
//
//    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
//        let reuseIdentifier = "pin"
//        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseIdentifier)
//
//        if annotationView == nil {
//            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: reuseIdentifier)
//            annotationView?.canShowCallout = true
//        } else {
//            annotationView?.annotation = annotation
//        }
//
//        let signAnnotation = annotation as! signAnnotation
////        annotationView?.image = UIImage(named: signAnnotation.pinCustomImageName)
//
//        return annotationView
//    }
//
}
