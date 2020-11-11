//
//  SignLibrary.swift
//  signposts-again
//
//  Created by Louis Kirkham on 10/11/2020.
//

import Foundation
import Firebase

struct SignLibrary {
    let db = Firestore.firestore()
    
    func addNewSign(message: String) {
        let date = Date()
        let location = GeoPoint(latitude: 51.185654, longitude: -0.174551)
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
//                    print("\(document.documentID) => \(document.data())")
                    print("\(document.documentID) => \(data["message"] ?? "No description")")
                }
            }
        }
    }
}
