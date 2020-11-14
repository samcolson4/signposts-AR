//
//  RegisterViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 13/11/2020.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    @IBOutlet var emailForm: UITextField!
    @IBOutlet var passwordForm: UITextField!
    @IBOutlet var registerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.hidesBackButton = false
    }
    
    @IBAction func registerBtnPressed(_ sender: UIButton) { registerNewUser() }
    
    func registerNewUser() {
        if let email = emailForm.text, let password = passwordForm.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "registered", sender: self)
                }
            }
        }
    }
}
