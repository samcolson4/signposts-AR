//
//  SignLibrary.swift
//  signposts-again
//
//  Created by Louis Kirkham on 10/11/2020.
//

import Foundation
import Firebase
import ARKit
import FirebaseStorage
import CoreLocation

class SignLibrary {
    let db = Firestore.firestore()
    let storage = Storage.storage()
    var user = Auth.auth().currentUser
    let locationManager = CLLocationManager()
    
    func addNewSign(message: String, data: Data) {
        let date = Date()
        var ref: DocumentReference? = nil
        let currentLoc: CLLocation
        currentLoc = locationManager.location!
        let geolocation = GeoPoint(latitude: currentLoc.coordinate.latitude,
                                   longitude: currentLoc.coordinate.longitude)
        
        ref = db.collection("signs").addDocument(data: ["message": message,
                                                        "geolocation": geolocation,
                                                        "created": date,
                                                        "username": user?.displayName as Any]) {
            err in if let err = err {
                print("Error adding document: \(err)")
            } else {
//                print("Document added with ID: \(ref!.documentID)")
                self.uploadWorldMap(data: data, filename: ref!.documentID)
            }
        }
    }
    
    func getAllSigns() {
        db.collection("signs").getDocuments() { (querySnapshot, err) in if let err = err {
            print("Error gettings documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let data = document.data()
                    print(data)
//                    print("\(document.documentID) => \(data["message"] ?? "No description")")
//                    print("\(document.documentID) => \(data["geolocation"] ?? "No description")")
//                    print("\(document.documentID) => \(data["created"] ?? "No description")")
                    
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
    
    func uploadWorldMap(data: Data, filename: String) {
        let storageRef = storage.reference()
        let worldMapRef = storageRef.child("worldmap") // location storage ref
        let mapRef = worldMapRef.child(filename)
        let uploadTask = mapRef.putData(data, metadata: nil) { (metadata, error) in
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
    
    func downloadWorldMap(filename: String) {
        let storageRef = storage.reference()
        let worldMapRef = storageRef.child("worldmap")
        let savedMapRef = worldMapRef.child(filename)
        savedMapRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                let worldMapData = data
            }
        }
    }
}
