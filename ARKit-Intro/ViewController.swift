//
//  ViewController.swift
//  ARKit-Intro
//
//  Created by William Jones on 9/13/17.
//  Copyright © 2017 ROKUBI,LLC. All rights reserved.
//
// Planet textues at https://www.solarsystemscope.com/textures

import UIKit
import SceneKit
import ARKit
import AVFoundation

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    var touchModels: Bool = true
    var revoveModels: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set the view's delegate
        sceneView.delegate = self

        textToSpeak("Touch models to hear name. Shake phone to add Orange Spheres. Touch to remove is toggled by tapping with two fingers.")
        
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
            diceNode.position = SCNVector3(-0.1, 0.1, -0.1)
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
        node.name = "Orange Cube"
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
        node.name = "Moon"
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
        node.name = "Mona Lisa"
        node.position = SCNVector3(-0.6, 0.1, -2.0)
        node.geometry = plane
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    func helloARKit() {
        let textGeometry = SCNText(string: "Hello, ARKit!", extrusionDepth: 1.0)
        textGeometry.firstMaterial?.diffuse.contents = UIColor.red
        let textNode = SCNNode(geometry: textGeometry)
        textNode.name = "AR Text"
        textNode.position = SCNVector3(-0.5, -0.2, -0.9)
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravityAndHeading
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    @IBAction func screenWasTapped(_ sender: UITapGestureRecognizer) {

    }
    
    @IBAction func multitouchRemoveModelsState(_ sender: UITapGestureRecognizer) {
        revoveModels = !revoveModels
        if revoveModels {
            textToSpeak("Tap to remove model enabled. Tap with two fingers to disable")
        } else {
            textToSpeak("Tap to remove model disabled.Tap with two fingers to enable")
        }
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if !touchModels {
            addOrangeSphere()
            return
        }
        let location = touches.first!.location(in: sceneView)
        print("Location: \(location)")
        var hitTestOptions = [SCNHitTestOption: Any]()
        hitTestOptions[SCNHitTestOption.boundingBoxOnly] = true
        let hitResults: [SCNHitTestResult]  =
            sceneView.hitTest(location, options: hitTestOptions)
        if let hit = hitResults.first {
            if let node = getParent(hit.node) {
                
                if let nodeName = node.name {
                    print("Node Name Tapped: \(nodeName)")
                    textToSpeak(nodeName)
                }
                
                if revoveModels {
                    node.removeFromParentNode()
                }
                
                return
            }
        }
    }
    
    func getParent(_ nodeFound: SCNNode?) -> SCNNode? {
        if let node = nodeFound {
            if node.name == nodeFound?.name {
                return node
            } else if let parent = node.parent {
                return getParent(parent)
            }
        }
        return nil
    }
    
    func textToSpeak(_ textToSpeak: String) {
        // for Swift, Add: import AVFoundation
        // Line 1. Create an instance of AVSpeechSynthesizer.
        let speechSynthesizer = AVSpeechSynthesizer()
        // Line 2. Create an instance of AVSpeechUtterance and pass in a String to be spoken.
        let speechUtterance: AVSpeechUtterance = AVSpeechUtterance(string: textToSpeak)
        //Line 3. Specify the speech utterance rate. 1 = speaking extremely the higher the values the slower speech patterns. The default rate, AVSpeechUtteranceDefaultSpeechRate is 0.5
        // speechUtterance.rate = AVSpeechUtteranceMaximumSpeechRate / 4.0
        // Line 4. Specify the voice. It is explicitly set to English here, but it will use the device default if not specified.
        speechUtterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        // Line 5. Pass in the urrerance to the synthesizer to actually speak.
        speechSynthesizer.speak(speechUtterance)
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
        print("motion ended...")
        touchModels = !touchModels
        if touchModels {
            textToSpeak("Touch models to hear their name")
        } else {
            textToSpeak("Touch screen to add Orange Spheres")
        }
    }
    
    func addOrangeSphere() {
        if let camera = self.sceneView.pointOfView {
            // print("camera.position = \(camera.position)")
            // create the sphere
            let radius = 0.06
            let sphere = SCNSphere(radius: CGFloat(radius))
            let color = SCNMaterial()
            color.diffuse.contents = UIColor.orange
            sphere.materials = [color]
            let sphereNode = SCNNode(geometry: sphere)
            sphereNode.name = "Orange Sphere"
            let position = SCNVector3(x: 0, y: 0, z: -1)
            sphereNode.position = camera.convertPosition(position, to: nil)
            sphereNode.rotation = camera.rotation
            // add sphere to scene
            self.sceneView.scene.rootNode.addChildNode(sphereNode)
        }
    }
}
