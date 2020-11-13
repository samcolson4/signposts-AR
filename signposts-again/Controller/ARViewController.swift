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
    
    override func viewDidLoad() {
        ARView.delegate = self
        let message = SCNText(string: "Hello", extrusionDepth: 1)

        let material = SCNMaterial()
        material.diffuse.contents = UIColor.green
        message.materials = [material]

        let node = SCNNode()
        node.position = SCNVector3(x: 0, y:0.02, z: -0.1)
        node.scale = SCNVector3(x: 0.01, y: 0.01, z: 0.01)
        node.geometry = message
        
        ARView.scene.rootNode.addChildNode(node)
        ARView.autoenablesDefaultLighting = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        ARView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        ARView.session.pause()
    }

    
}
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
