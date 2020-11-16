//
//  AugmentedViewController.swift
//  signposts-again
//
//  Created by Victoria Jusko on 16/11/2020.
//

import UIKit
import SceneKit
import ARKit


class AugmentedViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var ARView: ARSCNView!
    @IBOutlet weak var Label: UILabel!
    
    var text = ""
    
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
            print(text) //just for testing purposes
        }

    func addTapGestureToSceneView() {
           let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didReceiveTapGesture(_:)))
           ARView.addGestureRecognizer(tapGestureRecognizer)
       }
       
    @objc func didReceiveTapGesture(_ sender: UITapGestureRecognizer) {
           let location = sender.location(in: ARView)
           guard let hitTestResult = ARView.hitTest(location, types: [.featurePoint, .estimatedHorizontalPlane]).first
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
    
    func generateBoxNode() -> SCNNode {
        
        let message = SCNText(string: text, extrusionDepth: 1)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.orange
        message.materials = [material]
        
        let node = SCNNode()
        node.position = SCNVector3(x: 0, y:0.02, z: -0.1)
        node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        node.geometry = message
        
        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let boxNode = SCNNode()
        boxNode.position = SCNVector3(0,0,0)
        boxNode.geometry = box
        boxNode.name = "signBox"
        boxNode.addChildNode(node)
        return boxNode
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
    }

    @IBAction func load(_ sender: Any) {
        guard let worldMapData = retrieveWorldMapData(from: worldMapURL),
            let worldMap = unarchive(worldMapData: worldMapData) else { return }
        resetTrackingConfiguration(with: worldMap)
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
    
    func archive(worldMap: ARWorldMap) throws {
          let data = try NSKeyedArchiver.archivedData(withRootObject: worldMap, requiringSecureCoding: true)
          try data.write(to: self.worldMapURL, options: [.atomic])
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
    
 

