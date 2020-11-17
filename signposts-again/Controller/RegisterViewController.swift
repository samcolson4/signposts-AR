//
//  RegisterViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 13/11/2020.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet weak var usernameForm: UITextField!
    @IBOutlet weak var emailForm: UITextField!
    @IBOutlet weak var passwordForm: UITextField!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var passwordErrorLabel: UILabel!
    @IBOutlet weak var registerErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        passwordForm.addTarget(self,
                               action: #selector(checkPasswordAndDisplayError(passwordForm:)),
                               for: .editingChanged)
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) { registerNewUser() }
    
    func registerNewUser() {
        if let email = emailForm.text, let password = passwordForm.text, let username = usernameForm.text  {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    self.registerErrorLabel.text = e.localizedDescription
                } else {
                    self.editUsername(username: username)
                    self.addDefaultProfilePic()
                    self.performSegue(withIdentifier: "registered", sender: self)
                }
            }
        }
    }
    
    @objc func checkPasswordAndDisplayError (passwordForm: UITextField) {
        if (passwordForm.text?.count ?? 0 <= 5) {
            passwordErrorLabel.text = "Password must be 6 or more characters"
        } else {
            passwordErrorLabel.text = ""
        }
    }
    
    //this method might be duplicated in profile controller so maybe extraction needed?
    func editUsername(username: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = username
        changeRequest?.commitChanges(completion: { (error) in
            if let e = error {
                print(e.localizedDescription)
            }
        })
    }
    
    func addDefaultProfilePic() {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = URL(string: "https://icon-library.com/images/default-profile-icon/default-profile-icon-16.jpg")
        changeRequest?.commitChanges(completion: { (error) in
            if let e = error {
                print(e.localizedDescription)
            }
        })
    }
}
