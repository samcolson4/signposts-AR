//
//  RegisterViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 13/11/2020.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
// add IBOutlets for text entry fields
    @IBOutlet var emailForm: UITextField!
    @IBOutlet var passwordForm: UITextField!
    @IBOutlet var signUpButton: UIButton!
    
    @IBAction func signUpButtonPressed(_ sender: UIButton) { registerNewUser() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func registerNewUser() {
        if let email = emailForm.text, let password = passwordForm.text {
            Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                if let e = error {
                    print(e.localizedDescription)
                } else {
                    self.performSegue(withIdentifier: "signingUp", sender: self)
                }
            }
        }
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
