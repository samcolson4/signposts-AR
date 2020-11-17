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

class SignLibrary {
    let db = Firestore.firestore()
    let storage = Storage.storage()
   
    
    func addNewSign(message: String, location: GeoPoint) {
        let date = Date()
        var ref: DocumentReference? = nil
        
        ref = db.collection("signs").addDocument(data: ["message": message,
        "geolocation": location, "created": date]) {
            err in if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added with ID: \(ref!.documentID)")
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
    
    func uploadWorldMap(url: URL) {
                 
        let storageRef = storage.reference()
        let worldMapRef = storageRef.child("worldmap") // location storage ref
       
        let mapRef = storageRef.child("\(url)") // object storage ref
        let data = Data()
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
}
