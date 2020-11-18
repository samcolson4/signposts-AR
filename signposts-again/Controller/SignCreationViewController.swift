//
//  SignCreationViewController.swift
//  signposts-again
//
//  Created by Connor Worthington on 16/11/2020.
//

import UIKit

class SignCreationViewController: UIViewController {
    
    var signText = ""
    
    @IBOutlet weak var signTextField: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    

    @IBAction func submitBtnPressed(_ sender: UIButton) {
         signText = signTextField.text ?? ""
         // fix to avoid breaking on nil
         if (signTextField.text != "") {
 //            library.addNewSign(message: sender.text!, location: GeoPoint(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude))
            self.performSegue(withIdentifier: "textEntered", sender: self)
             // library.addNewSign(message: sender.text!)
         }
         signTextField.text = ""
     }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "textEntered" {
            let vc = segue.destination as! AugmentedViewController
            vc.text = signText
        }
    }
}
