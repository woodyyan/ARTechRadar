//
//  ViewController.swift
//  ARTechRadar
//
//  Created by Songbai Yan on 23/10/2017.
//  Copyright © 2017 Songbai Yan. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    private let baseHeight:Float = 0.05
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        if let planeAnchor = anchor as? ARPlaneAnchor {
            let basicRadius = planeAnchor.extent.x/4
            let trialColor = UIColor(red: 216/255, green: 217/255, blue: 211/255, alpha: 1)
            let assessColor = UIColor(red: 230/255, green: 229/255, blue: 224/255, alpha: 1)
            let holdColor = UIColor(red: 243/255, green: 242/255, blue: 238/255, alpha: 1)
            let trialNode = TubeNode(basicRadius, basicRadius*2, planeAnchor, baseHeight, trialColor)
            let assessNode = TubeNode(basicRadius*2, basicRadius*8/3, planeAnchor, baseHeight, assessColor)
            let holdNode = TubeNode(basicRadius*8/3, basicRadius*3, planeAnchor, baseHeight, holdColor)
            node.addChildNode(CylinderNode.init(basicRadius, planeAnchor, baseHeight))
            node.addChildNode(trialNode)
            node.addChildNode(assessNode)
            node.addChildNode(holdNode)
        }
    }
    
    
    
/*
    // Override to create and configure nodes for anchors added to the view's session.
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        let node = SCNNode()
     
        return node
    }
*/
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
