//
//  SignCollectionController.swift
//  signposts-again
//
//  Created by Sam Colson on 15/11/2020.
//

import UIKit
import Firebase

class SignCollectionController: UICollectionViewController {
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("The number of signs is: \(getSigns().count)")
        return getSigns().count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        var cell = UICollectionViewCell()
        
        if let signCell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? SignCollectionViewCell {
            let data = getSigns()
            signCell.configure(with: data[indexPath.row].message)
            
            cell = signCell
        }
        return cell
    }
    
    func getSigns() -> Array<Sign> {
        var signArray = [Sign]()
        
        library.returnDocs(completion: { (status, signs) in print(status, signs)
            
            for object in signs {
                let message = object.data()["message"]
                let date = object.data()["created"]
                let location = object.data()["geolocation"]
                
                let newSign = Sign(message: message as! String, date: date as! Timestamp, location: location as! GeoPoint)
                
                //if newSign.user_id == currentUser
                
                signArray.append(newSign)
                
                // else do nothing
                
                }
            
        })
        return signArray
    }
    
}
