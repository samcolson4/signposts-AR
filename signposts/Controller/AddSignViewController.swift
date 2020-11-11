//
//  AddSignViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 10/11/2020.
//

import UIKit
import Firebase

class AddSignViewController: UIViewController {
    let library = SignLibrary()
    @IBOutlet weak var SignTextEntry: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    }
    @IBAction func FormSubmitted(_ sender: UITextField, forEvent event: UIEvent) {
//        library.addNewSign(message: sender.text!)
    }
}
