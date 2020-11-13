//
//  LoginCheckController.swift
//  signposts-again
//
//  Created by Sam Colson on 13/11/2020.
//

import UIKit

class LoginCheckController: UIViewController {
var isLoggedIn = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if isLoggedIn {
            self.performSegue(withIdentifier: "Already logged in", sender: self)
              }
        // Do any additional setup after loading the view.
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
