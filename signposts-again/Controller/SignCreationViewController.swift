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
    
//    @IBAction func formSubmitted(_ sender: Any) {
//    }
    @IBAction func formSubmitted(_ sender: UITextField, forEvent event: UIEvent) {
         signText = sender.text ?? ""
         // fix to avoid breaking on nil
         if (sender.text != "") {
 //            library.addNewSign(message: sender.text!, location: GeoPoint(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude))
             self.performSegue(withIdentifier: "textEntered", sender: self)
             // library.addNewSign(message: sender.text!)
         }
         sender.text = ""
     }
     
    @IBAction func submit(_ sender: UIButton) {
        //not currenty doing anything. Function and the button on the view can be deleted.
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AugmentedViewController {
            let vc = segue.destination as! AugmentedViewController
            vc.text = signText
        }
    }

}
