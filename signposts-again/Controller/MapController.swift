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

class MapController: UIViewController, MKMapViewDelegate {
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()

    @IBOutlet weak var signmap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                let annotation = MKPointAnnotation()
        
                let latitude = sign.location.latitude
                let longtitude = sign.location.longitude
    
                annotation.coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longtitude)
                annotation.title = sign.message
                
                self.signmap.addAnnotation(annotation)
            }
        })
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
        annotationView.glyphImage = UIImage(named: "signpost") // TODO - change icon.
        return annotationView
    }
}
