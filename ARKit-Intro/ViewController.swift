//
//  ViewController.swift
//  ARKit-Intro
//
//  Created by William Jones on 9/13/17.
//  Copyright © 2017 ROKUBI,LLC. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self
        
        addShip()
        addDice()
        addGeometry()
        helloARKit()
    }
    
    func addShip() {
        // Create a new scene
        let ship = SCNScene(named: "art.scnassets/ship.scn")!
        
        // Set the scene to the view
        sceneView.scene = ship
    }
    
    func addDice() {
        let dice = SCNScene(named: "art.scnassets/diceCollada.scn")!
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "New_RedBase_Color.png")
        if let diceNode = dice.rootNode.childNode(withName: "Dice", recursively: true) {
            diceNode.position = SCNVector3(0, 0, -0.1)
            sceneView.scene.rootNode.addChildNode(diceNode)
        }
    }
    
    func addGeometry() {
        // add some default lighting to the scene.
        sceneView.autoenablesDefaultLighting = true
        
        // Geometry: SCNPlane, SCNBox, SCNSphere, SCNPyramid, SCNCone, SCNCylinder, SCNCapsule, SCNTube, and SCNTorus
        
        addCube()
        addSphere()
        addPlane()
    }
    
    func addCube() {
        // add box
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.orange
        cube.materials = [material]
        let node = SCNNode()
        node.position = SCNVector3(x: -0.1, y: 0.1, z: -0.5)
        node.geometry = cube
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func addSphere() {
        // add sphere
        let sphere = SCNSphere(radius: 0.2)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/moon.jpg")
        sphere.materials = [material]
        let node = SCNNode()
        node.position = SCNVector3(0.6, 0.1, -2.0)
        node.geometry = sphere
        sceneView.scene.rootNode.addChildNode(node)
        let action = SCNAction.rotateBy(x: 0.1, y: 0.6, z: 0, duration: 1)
        let repAction = SCNAction.repeatForever(action)
        node.runAction(repAction)
    }
    
    func addPlane() {
        // add sphere
        let plane = SCNPlane(width: 1.0, height: 1.0)
        let material = SCNMaterial()
        material.diffuse.contents = UIImage(named: "art.scnassets/MonaLisa.jpg")
        plane.materials = [material]
        let node = SCNNode()
        node.position = SCNVector3(-0.6, 0.1, -2.0)
        node.geometry = plane
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func helloARKit() {
        let textGeometry = SCNText(string: "Hello, ARKit!", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let textNode = SCNNode(geometry: textGeometry)
        textNode.position = SCNVector3(-0.5, -0.2, -0.9)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
}
