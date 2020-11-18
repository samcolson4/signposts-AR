//
//  SavedMapViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 18/11/2020.
//

import UIKit
import ARKit
import FirebaseStorage

class SavedMapViewController: UIViewController, ARSCNViewDelegate, ARSessionDelegate {

    @IBOutlet weak var ARView: ARSCNView!
    @IBOutlet weak var Label: UILabel!
    let storage = Storage.storage()
    
    override func viewDidLoad() {
            super.viewDidLoad()
            ARView.delegate = self
            downloadWorldMap(filename: "o1z5nlsWv7RcCcIQ5WBa")
        }
    
    func load(worldMapData: Data) {
        let worldMap = unarchive(worldMapData: worldMapData)
        resetTrackingConfiguration(with: worldMap)
        print("file loaded")
    }
    
    func downloadWorldMap(filename: String) {
        let storageRef = storage.reference()
        let worldMapRef = storageRef.child("worldmap")
        let savedMapRef = worldMapRef.child(filename)
        savedMapRef.getData(maxSize: 2 * 1024 * 1024) { data, error in
            if let e = error {
                print(e.localizedDescription)
            } else {
                self.load(worldMapData: data!)
                print("File found")
            }
        }
    }
    
    func unarchive(worldMapData data: Data) -> ARWorldMap? {
          let unarchivedObject = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
             let worldMap = unarchivedObject
         return worldMap
    }

    func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {
      let configuration = ARWorldTrackingConfiguration()
      configuration.planeDetection = [.horizontal]
      
      let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
      if let worldMap = worldMap {
          configuration.initialWorldMap = worldMap
          setLabel(text: "Found saved world map.")
      } else {
          setLabel(text: "Move camera around to map your surrounding space.")
      }
      
    //          ARView.debugOptions = [.showFeaturePoints]
      ARView.session.run(configuration, options: options)
    }
    
    func setLabel(text: String) {
           Label.text = text
    }
    
    
}
