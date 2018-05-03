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

    private let baseHeight: Float = 0.05
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
        renderRadar(node: node)
    }
    
    private func renderRadar(node: SCNNode) {
        let basicRadius: Float = 0.2
        let radarAnchor = SCNVector3(0, 0, 0)
        addRadarPlane(node: node, basicRadius: basicRadius, radarAnchor: radarAnchor)
        addRadarDots(node: node)
        addRadarQuadrant(node: node, basicRadius: basicRadius, radarAnchor: radarAnchor)
    }
    
    func addRadarQuadrant(node: SCNNode, basicRadius: Float, radarAnchor: SCNVector3) {
        let horizon = PlaneNode(basicRadius * 3, radarAnchor)
        let vertical = PlaneNode(basicRadius * 3, radarAnchor)
        horizon.rotation = SCNVector4Make(1, 0, 0, -Float(.pi/2.0))
        
        let xAngle = SCNMatrix4MakeRotation(-Float(.pi/2.0), 1, 0, 0)
        let yAngle = SCNMatrix4MakeRotation(Float(.pi/2.0), 0, 1, 0)
        let zAngle = SCNMatrix4MakeRotation(0, 0, 0, 1)
        let rotationMatrix = SCNMatrix4Mult(SCNMatrix4Mult(xAngle, yAngle), zAngle)
        vertical.transform = SCNMatrix4Mult(rotationMatrix, vertical.transform)
        node.addChildNode(horizon)
        node.addChildNode(vertical)
    }
    
    func addRadarPlane(node: SCNNode, basicRadius: Float, radarAnchor: SCNVector3) {
        let trialColor = UIColor(red: 216/255, green: 217/255, blue: 211/255, alpha: 1)
        let assessColor = UIColor(red: 230/255, green: 229/255, blue: 224/255, alpha: 1)
        let holdColor = UIColor(red: 243/255, green: 242/255, blue: 238/255, alpha: 1)
        let adoptNode = CylinderNode.init(basicRadius, radarAnchor, baseHeight)
        let trialNode = TubeNode(basicRadius, basicRadius*2, radarAnchor, baseHeight, trialColor)
        let assessNode = TubeNode(basicRadius*2, basicRadius*8/3, radarAnchor, baseHeight, assessColor)
        let holdNode = TubeNode(basicRadius*8/3, basicRadius*3, radarAnchor, baseHeight, holdColor)
        node.addChildNode(adoptNode)
        node.addChildNode(trialNode)
        node.addChildNode(assessNode)
        node.addChildNode(holdNode)
    }
    
    func addRadarDots(node: SCNNode) {
        let radarService = RadarDataService()
        let fileUrl = Bundle.main.url(forResource: "RadarData", withExtension: "plist")
        let radarDots = radarService.getRadarDotsFromFile(url: fileUrl!)
        
        for radarDot in radarDots {
            let radarDotNode = RadarDotNode(radarDot: radarDot)
            node.addChildNode(radarDotNode)
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        print(error.localizedDescription)
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}
