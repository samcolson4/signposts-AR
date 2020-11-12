//
//  SignLibrary.swift
//  signposts-again
//
//  Created by Louis Kirkham on 10/11/2020.
//

import Foundation
import Firebase

class SignLibrary {
    let db = Firestore.firestore()
//    var signArray = [Sign]()

    
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
////                    print("\(document.documentID) => \(document.data())")
//                    print("\(document.documentID) => \(data["message"] ?? "No description")")
//                    print("\(document.documentID) => \(data["geolocation"] ?? "No description")")
//                    print("\(document.documentID) => \(data["created"] ?? "No description")")


                }
            }
        }
    }
    
    
    func returnSigns(completion: @escaping ([Sign], String) -> Void) {
        var documentArray = [QueryDocumentSnapshot]()
        var signArray = [Sign]()
                
        db.collection("signs").getDocuments() { (querySnapshot, err) in if let err = err {
            let err = "Error gettings documents: \(err)"
            completion(signArray, err)
            } else {
    
                documentArray = querySnapshot!.documents
        
                }
      
            }
//        print("3")
//        print(documentArray)
//
        for document in documentArray {
            
            let data = document.data()

            let description = data["message"] as! String
            let date = data["created"] as! Timestamp
            let location = data["geolocation"] as! GeoPoint

            let newSign = Sign(message: description, date: date, location: location)

            signArray.append(newSign)
            
            completion(signArray, "No way hosay")
        }
        
    }
}

