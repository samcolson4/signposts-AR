//
//  AugmentedViewController.swift
//  signposts-again
//
//  Created by Victoria Jusko on 16/11/2020.
//

import UIKit
import SceneKit
import ARKit
import Firebase
import CoreLocation

class AugmentedViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var ARView: ARSCNView!
    @IBOutlet weak var Label: UILabel!
    @IBOutlet weak var load: UIButton!
    @IBOutlet weak var save: UIButton!
    
    let library = SignLibrary()
    var documents = [QueryDocumentSnapshot]()
    var user = Auth.auth().currentUser
    var text = ""
    var textColour = UIColor.red
    var textFromDatabase = ""
    var locManager = CLLocationManager()
    
    var worldMapURL: URL = {
            do {
                return try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
                    .appendingPathComponent("worldMapURL")
            } catch {
                fatalError("Error getting world map URL from document directory.")
            }
        }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ARView.delegate = self
        configureLighting()
        addTapGestureToSceneView()
        addPinchGestureToSceneView()
        roundButtons()
        Label.layer.masksToBounds = true
        }
    
//    @IBAction func backFromModal(_ segue: UIStoryboardSegue) {
//        self.tabBarController?.selectedIndex = 0
//    }
    
    @IBAction func addSignButton(_ sender: Any) {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }
    
    func roundButtons() {
        save.layer.cornerRadius = 4
        load.layer.cornerRadius = 4
        Label.layer.cornerRadius = 4
    }
    
    func addTapGestureToSceneView() {
           let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTapGesture(_:)))
           ARView.addGestureRecognizer(tapGestureRecognizer)
       }
       
    @objc func didReceiveTapGesture(_ sender: UITapGestureRecognizer) {
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let location = sender.location(in: ARView)
        guard let hitTestResult = ARView.hitTest(location, types: [.featurePoint, .estimatedVerticalPlane]).first
            else { return }
        let anchor = ARAnchor(transform: hitTestResult.worldTransform)
        ARView.session.add(anchor: anchor)
       }
    
    
    func addPinchGestureToSceneView() {
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(didReceivePinch(_:)))
        ARView.addGestureRecognizer(pinch)
       }
       
    @objc func didReceivePinch(_ sender: UIPinchGestureRecognizer) {
        ARView.scene.rootNode.enumerateChildNodes { (node, _) in
            if node.name == "signBox" {
                node.removeFromParentNode()
            }
        }
       }
    
    func getText() {
        var signArray = [Sign]()
        let userLat = (locManager.location?.coordinate.latitude)!
        let userLong = (locManager.location?.coordinate.longitude)!
        
        let roundUserLat = self.blurCoords(coord: userLat)
        let roundUserLong = self.blurCoords(coord: userLong)
        
        library.returnDocs(completion: { (status, signs) in print(status, signs)
            
            for object in signs {
                let message = object.data()["message"]
                let date = object.data()["created"]
                let location = object.data()["geolocation"]
                let username = object.data()["username"]
                
                let newSign = Sign(message: message as! String, date: date as! Timestamp, location: location as! GeoPoint, username: username as? String)
                
                let signLatBlur = self.blurCoords(coord: newSign.location.latitude)
                let signLongBlur = self.blurCoords(coord: newSign.location.longitude)
                
                    if signLatBlur == roundUserLat && signLongBlur == roundUserLong {
                        signArray.append(newSign)
                    }
                }
            
            signArray.sort(by: { $0.date.dateValue() > $1.date.dateValue() })
            
            if signArray.count != 0 {
                self.textFromDatabase = signArray.first!.message
                    print(signArray)
                } else {
                    self.text = "Press plus to create a sign!"
                }
        })
    }
    
    func generateBoxNode() -> SCNNode {
        var entityText = ""
                
        if self.text != "" {
            entityText = self.text
        } else if self.textFromDatabase != "" && self.text == "" {
            entityText = self.textFromDatabase
        } else if self.textFromDatabase == "" && self.text == "" {
            entityText = "Press plus to create a sign!"
        } else {
            print("Something has gone wrong")
        }
        
        let font = UIFont(name: "Avenir-Medium" , size: 10)
        let message = SCNText(string: entityText, extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = textColour
        message.materials = [material]
        message.isWrapped = true
        message.chamferRadius = 0.23
        message.font = font
        message.containerFrame = CGRect(origin: .zero, size: CGSize(width: 80, height: 30))
        let node = SCNNode()
        node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        node.geometry = message
        node.name = "signBox"

        return node
       }

    func configureLighting() {
        ARView.autoenablesDefaultLighting = true
        ARView.automaticallyUpdatesLighting = true
       }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetTrackingConfiguration()
       }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        ARView.session.pause()
       }
      
    @IBAction func save(_ sender: Any) {
        ARView.session.getCurrentWorldMap { (worldMap, error) in
            guard let worldMap = worldMap else {
                return self.setLabel(text: "Error getting current world map.")
            }

            do {
                try self.archive(worldMap: worldMap)
                DispatchQueue.main.async {
                    self.setLabel(text: "World map is saved.")
                }
            } catch {
                fatalError("Error saving world map: \(error.localizedDescription)")
            }
        }
        load.isHidden = true // disables immediately loading back in what has been saved.
    }

    @IBAction func load(_ sender: Any) {
        self.getText()
        guard let worldMapData = retrieveWorldMapData(from: worldMapURL),
            let worldMap = unarchive(worldMapData: worldMapData) else { return }
        resetTrackingConfiguration(with: worldMap)
        save.isHidden = true // stops a user loading a sign and trying to save the same one back to the DB
    }
    
    
      func resetTrackingConfiguration(with worldMap: ARWorldMap? = nil) {
          let configuration = ARWorldTrackingConfiguration()
          configuration.planeDetection = [.vertical]
          
          let options: ARSession.RunOptions = [.resetTracking, .removeExistingAnchors]
          if let worldMap = worldMap {
              configuration.initialWorldMap = worldMap
              setLabel(text: "Found saved world map.")
          } else {
            Label.text = ""
            print("Error - no world map data")
          }
          
          ARView.debugOptions = [.showFeaturePoints]
          ARView.session.run(configuration, options: options)
      }
    
    func setLabel(text: String) {
        Label.text = text
        Label.backgroundColor = .systemGray5
       }
    
    func archive(worldMap: ARWorldMap) throws {
          let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
          try data.write(to: self.worldMapURL, options: [.atomic])
          self.library.addNewSign(message: self.text, worldMapData: data)
      }
    
    func retrieveWorldMapData(from url: URL) -> Data? {
          do {
              return try Data(contentsOf: self.worldMapURL)
          } catch {
              self.setLabel(text: "Error retrieving world map data.")
              return nil
          }
      }
    
    func unarchive(worldMapData data: Data) -> ARWorldMap? {
          let unarchievedObject = try? NSKeyedUnarchiver.unarchivedObject(ofClass: ARWorldMap.self, from: data)
             let worldMap = unarchievedObject
         return worldMap
    }
    
    func blurCoords(coord: Double) -> Double {
        let newCoord = round(coord * 1005) / 1005
        return newCoord
    }
}
     
    extension AugmentedViewController {
        
        func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
            guard !(anchor is ARPlaneAnchor) else { return }
            let boxNode = generateBoxNode()
            DispatchQueue.main.async {
                node.addChildNode(boxNode)
            }
        }
        
    }
    
    extension float4x4 {
        var translation: SIMD3<Float> {
            let translation = self.columns.3
            return SIMD3<Float>(translation.x, translation.y, translation.z)
        }
    }

    extension UIColor {
        open class var transparentWhite: UIColor {
            return UIColor.red.withAlphaComponent(0.70)
        }
    }
    
 

