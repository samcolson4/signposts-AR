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

class ARViewController: UIViewController {

    var text = ""
    
        
    @IBOutlet var sceneView: ARView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Box for sign
        let box = MeshResource.generateBox(width: 0.3, height: 0.3, depth: 0.1)
        let boxMaterial = SimpleMaterial(color: .red, isMetallic: false)
        let entityBox = ModelEntity(mesh: box, materials: [boxMaterial])
        
        let boxAnchor = AnchorEntity(plane: .horizontal)
        boxAnchor.name = "BoxAnchor"
        
        boxAnchor.addChild(entityBox)
//        sceneView.scene.addAnchor(boxAnchor)
        
        
        // Text
        let message = MeshResource.generateText(text, extrusionDepth: 0.2, font: .systemFont(ofSize: 0.2))
        let material = SimpleMaterial(color: .blue, isMetallic: false)
        let entityText = ModelEntity(mesh: message, materials: [material])


//        let anchor = AnchorEntity(plane: .horizontal)
//        anchor.addChild(entityText)
//        sceneView.scene.addAnchor(anchor)
//
        entityBox.addChild(entityText)
//    boxAnchor.addChild(entityBox)
        entityText.setPosition(SIMD3<Float>(-0.1, -0.1, 0), relativeTo: entityBox)
        sceneView.scene.addAnchor(boxAnchor)
        
        entityBox.generateCollisionShapes(recursive: true)
        sceneView.installGestures([.translation, .rotation, .scale], for: entityBox)
        
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
        sceneView.enableObjectRemoval()
    }
//}

}



extension ARView {

        func enableObjectRemoval() {
            let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(recognizer:)))

            self.addGestureRecognizer(longPressGestureRecognizer)
        }

    @objc func handleLongPress(recognizer: UILongPressGestureRecognizer){
        let location = recognizer.location(in: self)

        if let entity = self.entity(at: location) {
            if let boxAnchor = entity.anchor, boxAnchor.name == "BoxAnchor" {
                boxAnchor.removeFromParent()
                print("Removed anchor with name:" + boxAnchor.name)
            }
        }
    }
    }



