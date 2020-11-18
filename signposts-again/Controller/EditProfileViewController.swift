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
    @IBOutlet weak var updateUsernameBtn: UIButton!
    @IBOutlet weak var confirmationLabel: UILabel!
    @IBOutlet weak var photoUrlForm: UITextField!
    @IBOutlet weak var updateAvatarBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUsernameBtn.layer.cornerRadius = 4
        updateAvatarBtn.layer.cornerRadius = 4
        // Do any additional setup after loading the view.
    }

    func editUsername() {
        if usernameForm.text != "" {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            changeRequest?.displayName = usernameForm.text
            changeRequest?.commitChanges(completion: { (error) in
                if let e = error {
                    self.confirmationLabel.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: "profileUpdated", sender: self)
                }
            })
        }
    }
    
    func editPhoto() {
        if photoUrlForm.text != "" {
            let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
            let defaultURL = "https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg"
            changeRequest?.photoURL = URL(string: "\(photoUrlForm.text ?? defaultURL)")
            changeRequest?.commitChanges(completion: { (error) in
                if let e = error {
                    self.confirmationLabel.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: "profileUpdated", sender: self)
                }
            })
        }
    }
    
    @IBAction func updateUsernamePressed(_ sender: Any) {
        editUsername()
    }
    @IBAction func updateAvatarPressed(_ sender: Any) {
        editPhoto()
    }
    
}
