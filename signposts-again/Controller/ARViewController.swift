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
        
        let text = MeshResource.generateText("Hello", extrusionDepth: 0.1, font: .systemFont(ofSize: 0.3), containerFrame: CGRect(x: 2.0, y: 2.0, width: 2.0, height: 2.0), alignment: .center)
        let material = SimpleMaterial(color: .green, isMetallic: true)
        let entity = ModelEntity(mesh: text, materials: [material])
        
        let anchor = AnchorEntity(plane: .horizontal)
        anchor.addChild(entity)
        sceneView.scene.addAnchor(anchor)
        
//        let box = MeshResource.generateBox(size: 0.3)
//        let boxAnchor = try! Experience.loadBox()
//        let unknown = boxAnchor.emptySign?.children[0]
//        print(unknown)
//        sceneView.scene.anchors.append(boxAnchor)
//        generateText("")
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
    }
}

