//
//  EditProfileViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 16/11/2020.
//

import UIKit
import Firebase

class EditProfileViewController: UIViewController {

    @IBOutlet weak var usernameForm: UITextField!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    func editUsername() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = usernameForm.text
        changeRequest?.commitChanges(completion: { (error) in
            if let e = error {
                print(e.localizedDescription)
            }
        })
    }
    @IBAction func saveChangesPressed(_ sender: UIButton) {
        editUsername()
        
    }
}
