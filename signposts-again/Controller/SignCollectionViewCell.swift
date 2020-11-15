//
//  SignCollectionViewCell.swift
//  signposts-again
//
//  Created by Sam Colson on 15/11/2020.
//

import UIKit
import Firebase

class SignCollectionViewCell: UICollectionViewCell {
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    
    @IBOutlet weak var messageLabel: UILabel!
    
    
    func configure(with messageText: String) {
        messageLabel.text = messageText
    }
    
    
}
