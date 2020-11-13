//
//  SignLibrary.swift
//  signposts-again
//
//  Created by Louis Kirkham on 10/11/2020.
//

import Foundation
import Firebase
import FirebaseFirestore

class SignLibrary {
    let db = Firestore.firestore()
    
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
}
