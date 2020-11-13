//
//  ARViewController.swift
//  signposts-again
//
//  Created by Louis Kirkham on 11/11/2020.
//

import UIKit
import SceneKit
import ARKit
import RealityKit

class ARViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet weak var ARView: ARSCNView!
    @IBOutlet weak var Label: UILabel!
    
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
    
    func generateBoxNode() -> SCNNode {
           let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
           let boxNode = SCNNode()
           boxNode.position = SCNVector3(0,0,0)
           boxNode.geometry = box
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
       
    
    @IBAction func resetBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
         resetTrackingConfiguration()
     }
    
    @IBAction func saveBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
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
      
    @IBAction func loadBarButtonItemDidTouch(_ sender: UIBarButtonItem) {
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
          
          ARView.debugOptions = [.showFeaturePoints]
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
     
    extension ARViewController {
        
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
    
 
//    override func viewDidLoad() {
//
//        ARView.delegate = self
//        let message = SCNText(string: "Hello", extrusionDepth: 1)
//
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.green
//        message.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y:0.02, z: -0.1)
//        node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
//        node.geometry = message
//
//        ARView.scene.rootNode.addChildNode(node)
//        ARView.autoenablesDefaultLighting = true
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        // Create a session configuration
//        let configuration = ARWorldTrackingConfiguration()
//
//        // Run the view's session
//        ARView.session.run(configuration)
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        // Pause the view's session
//        ARView.session.pause()
//    }
//
//

//class ARViewController: UIViewController {
//
//   var text = ""
//
//
//    @IBOutlet var sceneView: ARView!
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Box for sign
////        let box = MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.1)
////        let boxMaterial = SimpleMaterial(color: .red, isMetallic: false)
////        let entityBox = ModelEntity(mesh: box, materials: [boxMaterial])
////
////        let boxAnchor = AnchorEntity(plane: .horizontal)
////        boxAnchor.name = "BoxAnchor"
////
////        boxAnchor.addChild(entityBox)
////        sceneView.scene.addAnchor(boxAnchor)
//
//
//        // Text
////        let message = MeshResource.generateText(text, extrusionDepth: 0.2, font: .systemFont(ofSize: 0.2))
////        let material = SimpleMaterial(color: .blue, isMetallic: false)
////        let entityText = ModelEntity(mesh: message, materials: [material])
////
////
////        entityBox.addChild(entityText)
////
////        entityText.setPosition(SIMD3<Float>(-0.1, -0.1, 0), relativeTo: entityBox)
////        sceneView.scene.addAnchor(boxAnchor)
////
////        entityBox.generateCollisionShapes(recursive: true)
////        sceneView.installGestures([.translation, .rotation, .scale], for: entityBox)
//
//        // this function needs to be called in order to be able to remove an object
//        sceneView.enableObjectRemoval()
//        sceneView.enableTapGesture()
//    }
//
//}
//
//
//
//extension ARView {
//
//        func enableObjectRemoval() {
//            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))
//
//            self.addGestureRecognizer(longPressGestureRecognizer)
//        }
//
//    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
//        let location = recognizer.location(in: self)
//
//        if let entity = self.entity(at: location) {
//            if let boxAnchor = entity.anchor, boxAnchor.name == "BoxAnchor" {
//                boxAnchor.removeFromParent()
//                print("Removed anchor with name:" + boxAnchor.name)
//            }
//        }
//    }
//
//    func enableTapGesture() {
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(recognizer:)))
//        self.addGestureRecognizer(tapGestureRecognizer)
//    }
//
//    @objc func handleTap(recognizer: UITapGestureRecognizer) {
//        let tapLocation = recognizer.location(in: self)
//
//        guard let rayResult = self.ray(through: tapLocation) else { return}
//
//        let results = self.scene.raycast(origin: rayResult.origin, direction: rayResult.direction)
//
//        if let firstResult = results.first {
//
//            var position = firstResult.position
//            position += 0.3/2
//            placeCube(at: position)
//
//        } else {
//
//            let results = self.raycast(from: tapLocation, allowing: .estimatedPlane, alignment: .any)
//
//            if let firstResult = results.first {
//                let position = simd_make_float3(firstResult.worldTransform.columns.3)
//                placeCube(at: position)
//            }
//        }
//     }
//
//    func placeCube(at position: SIMD3<Float>) {
////        let mesh = MeshResource.generateBox(size: 0.3)
////        let material = SimpleMaterial(color: .white, roughness: 0.3, isMetallic: true )
////        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
////        modelEntity.generateCollisionShapes(recursive: true)
////
////
////        let anchorEntity = AnchorEntity(world: position)
////        anchorEntity.addChild(modelEntity)
////
////        self.scene.addAnchor(anchorEntity)
//
//        //Adding text?
//
//        let message = MeshResource.generateText(TextContainer.signText, extrusionDepth: 0.2, font: .systemFont(ofSize: 0.2))
//        let material = SimpleMaterial(color: .blue, isMetallic: false)
//        let entityText = ModelEntity(mesh: message, materials: [material])
//
//
//        let box = MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.1)
//        let boxMaterial = SimpleMaterial(color: .red, isMetallic: false)
//        let entityBox = ModelEntity(mesh: box, materials: [boxMaterial])
//
//        entityBox.addChild(entityText)
//        entityText.setPosition(SIMD3<Float>(-0.1, -0.1, 0), relativeTo: entityBox)
//
//        entityBox.generateCollisionShapes(recursive: true)
//        self.installGestures([.translation, .rotation, .scale], for: entityBox)
//
//        let boxAnchor = AnchorEntity(world: position)
//        boxAnchor.name = "BoxAnchor"
//        boxAnchor.addChild(entityBox)
//        self.scene.addAnchor(boxAnchor)
//
//    }
//
//    }







//        let box = MeshResource.generateBox(size: 0.3)
//        let boxAnchor = try! Experience.loadBox()
//        let unknown = boxAnchor.emptySign?.children[0]
//        print(unknown)
//        sceneView.scene.anchors.append(boxAnchor)
//        generateText("")
//

// Set the view's delegate
//        sceneView.delegate = self
//
//        let message = SCNText(string: text, extrusionDepth: 1)
//
//        let material = SCNMaterial()
//        material.diffuse.contents = UIColor.orange
//        message.materials = [material]
//
//        let node = SCNNode()
//        node.position = SCNVector3(x: 0, y:0.02, z: -0.1)
//        node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
//        node.geometry = message
//
//        sceneView.scene.rootNode.addChildNode(node)
//        sceneView.autoenablesDefaultLighting = true
