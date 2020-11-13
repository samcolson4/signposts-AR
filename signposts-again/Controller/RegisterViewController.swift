//
//  RegisterViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 13/11/2020.
//

import UIKit

class RegisterViewController: UIViewController {
// add IBOutlets for text entry fields
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    func registerNewUser() {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let e = err {
                print(e.localizedDescription)
            } else {
                
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
