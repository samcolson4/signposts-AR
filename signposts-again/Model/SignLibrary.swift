//
//  SignLibrary.swift
//  signposts-again
//
//  Created by Louis Kirkham on 10/11/2020.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import CoreLocation

class SignLibrary {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    let locationManager = CLLocationManager()
    let user = Auth.auth().currentUser
    
    func addNewSign(message: String, worldMapData: Data) {
        let date = Date()
        var ref: DocumentReference? = nil
        let currentLoc: CLLocation
        currentLoc = locationManager.location!
        let username = user?.displayName
        let geolocation = GeoPoint(latitude: currentLoc.coordinate.latitude,
                                   longitude: currentLoc.coordinate.longitude)
        ref = db.collection("signs").addDocument(data: ["message": message,
                                                        "geolocation": geolocation, "created": date, "username": username ?? ""]) {
            err in if let err = err {
                print("Error adding document: \(err)")
            } else {
                self.uploadWorldMap(worldMapData: worldMapData, filename: ref!.documentID)
            }
        }
    }
    
    func getAllSigns() {
        db.collection("signs").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error gettings documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                }
            }
        }
    }

    func returnDocs(completion: @escaping (Bool, [QueryDocumentSnapshot]) -> ()) {
        var documents = [QueryDocumentSnapshot]()

        db.collection("signs").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error getting documents: \(err)")
            completion(false, documents)
        } else {
            for document in querySnapshot!.documents {
                documents.append(document)
            }
            completion(true, documents)
            }
        }
    }
    
    func uploadWorldMap(worldMapData: Data, filename: String) {
        let storageRef = storage.reference()
        let worldMapRef = storageRef.child("worldmap") // location storage ref
        let mapRef = worldMapRef.child(filename)
        let uploadTask = mapRef.putData(worldMapData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              mapRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
            }
        }
    }
}
