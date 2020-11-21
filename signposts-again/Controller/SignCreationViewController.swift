//
//  SignCreationViewController.swift
//  signposts-again
//
//  Created by Connor Worthington on 16/11/2020.
//

import UIKit
import Firebase
import CoreLocation
import MapKit

class SignCreationViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    var signText = ""
    var signTextColour = UIColor.white
    var user = Auth.auth().currentUser
    var locManager = CLLocationManager()
    var colourSelection: [String] = [String]()
    @IBOutlet weak var colourWheel: UIPickerView!
    @IBOutlet weak var signTextField: UITextField!
    @IBOutlet weak var submit: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        submit.layer.cornerRadius = 4
//        signTextField.becomeFirstResponder()
        self.colourWheel.delegate = self
        self.colourWheel.dataSource = self
        colourSelection = ["White", "Red", "Orange", "Yellow", "Green", "Black"]
    }
    
    @IBAction func submitBtnPressed(_ sender: UIButton) {
         signText = signTextField.text ?? ""
         if (signTextField.text != "") {
            self.performSegue(withIdentifier: "textEntered", sender: self)
         }
         signTextField.text = ""
     }
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return colourSelection.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch colourSelection[row] {
            case "White": signTextColour = UIColor.white
            case "Red": signTextColour = UIColor.red
            case "Orange": signTextColour = UIColor.orange
            case "Yellow": signTextColour = UIColor.yellow
            case "Green": signTextColour = UIColor.green
            case "Black": signTextColour = UIColor.black
            default: signTextColour = UIColor.white
        }
        return colourSelection[row]
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "textEntered" {
            let vc = segue.destination as! UITabBarController
            let arVC = vc.viewControllers![0] as! AugmentedViewController
            arVC.text = signText
            arVC.textColour = signTextColour
        }
    }
}
