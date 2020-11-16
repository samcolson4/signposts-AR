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
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var photoUrlForm: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    

    func editUsername() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = usernameForm.text
        changeRequest?.commitChanges(completion: { (error) in
            if let e = error {
                self.confirmationLabel.text = e.localizedDescription
            } else {
                self.confirmationLabel.text = "Changes successfully saved"
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    
    func editPhoto() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = URL(string: "\(String(describing: photoUrlForm.text))")
        changeRequest?.commitChanges(completion: { (error) in
            if let e = error {
                self.confirmationLabel.text = e.localizedDescription
            } else {
                self.confirmationLabel.text = "Changes successfully saved"
                self.dismiss(animated: true, completion: nil)
            }
        })
    }
    @IBAction func saveChangesPressed(_ sender: UIButton) {
        editUsername()
        
    }
}
