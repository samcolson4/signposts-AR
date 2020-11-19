//
//  LoginViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 13/11/2020.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var emailForm: UITextField!
    @IBOutlet weak var passwordForm: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var registerButton: UIButton!
    @IBOutlet weak var loginErrorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginButton.layer.cornerRadius = 4
        registerButton.layer.cornerRadius = 4
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginBtnPressed(_ sender: UIButton) {
        signIn()
    }
    
    func signIn() {
        if let email = emailForm.text, let password = passwordForm.text {
            Auth.auth().signIn(withEmail: email, password: password) {authResult, error in
                if let e = error {
                    self.loginErrorLabel.text = e.localizedDescription
                } else {
                    self.performSegue(withIdentifier: "loggedIn", sender: self)
                }
            }
        }
    }
}
