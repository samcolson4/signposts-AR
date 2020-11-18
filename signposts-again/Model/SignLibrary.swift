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
        let geolocation = GeoPoint(latitude: currentLoc.coordinate.latitude,
                                   longitude: currentLoc.coordinate.longitude)
        let username = user?.displayName
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
    
//    func downloadSign() -> String {
//        var signArray = [Sign]()
//        let currentLoc: CLLocation
//        currentLoc = locationManager.location!
//        let geolocation = GeoPoint(latitude: currentLoc.coordinate.latitude,
//                                   longitude: currentLoc.coordinate.longitude)
//
//        self.returnDocs(completion: { (status, signs) in print(status, signs)
//
//            for object in signs {
//                let message = object.data()["message"]
//                let date = object.data()["created"]
//                let location = object.data()["geolocation"]
//                let username = object.data()["username"]
//
//                let newSign = Sign(message: message as! String, date: date as! Timestamp, location: location as! GeoPoint, username: username as? String)
//
//                if newSign.location == geolocation{
//                        signArray.append(newSign)
//                    }
//                }
//             for sign in signArray {
//                return sign.message
//            }
//
//        })
//    }
        
        
        }

