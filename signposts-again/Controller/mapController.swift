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
//    var signs = [Any]()

    @IBOutlet weak var signmap: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let signs = library.returnSigns()
        
        var latitude: CLLocationDegrees
        var longtitude: CLLocationDegrees
   
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
    }
    
}
