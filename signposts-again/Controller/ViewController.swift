//
//  ViewController.swift
//  signposts-again
//
//  Created by Sam Colson on 10/11/2020.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    let library = SignLibrary()
    @IBOutlet weak var addNewSignBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
    
    }
    
    
    @IBAction func addNewSignPressed(_ sender: UIButton) {
        library.addNewSign(message: "This sign was added by pressing a button")
    }
    
    
    
    
}

