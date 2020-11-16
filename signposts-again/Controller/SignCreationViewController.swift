//
//  SignCreationViewController.swift
//  signposts-again
//
//  Created by Connor Worthington on 16/11/2020.
//

import UIKit

class SignCreationViewController: UIViewController {
    
    @IBOutlet weak var signTextField: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    var signText = ""

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
//    @IBAction func formSubmitted(_ sender: Any) {
//    }
    @IBAction func formSubmitted(_ sender: UITextField, forEvent event: UIEvent) {
        signText = sender.text ?? ""
        if (sender.text != "") {
            self.performSegue(withIdentifier: "textEntered", sender: self)
        }
        sender.text = ""
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AugmentedViewController {
            let vc = segue.destination as! AugmentedViewController
            vc.text = signText
        }
    }

}
