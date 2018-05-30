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

class ViewController: UIViewController {
    let baseHeight: Float = 0.05
    var hasRadarLoaded = false
    
    var techRadarNode: TechRadarNode!
    
    @IBOutlet var sceneView: ARSCNView!
    
    @IBOutlet weak var messageLabel: UILabel!
    
    var focusSquare = FocusSquare()
    
    let updateQueue = DispatchQueue(label: "com.thoughtworks.techradar")
    
    var screenCenter: CGPoint {
        let bounds = sceneView.bounds
        return CGPoint(x: bounds.midX, y: bounds.midY)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        sceneView.scene.rootNode.addChildNode(focusSquare)
        
        // Show statistics such as fps and timing information
//        sceneView.showsStatistics = true
//        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        
        let scene = SCNScene()
        sceneView.scene = scene
        sceneView.autoenablesDefaultLighting = true
//        if let environmentMap = UIImage(named: "art.scnassets/environment_blur.exr") {
//            sceneView.scene.lightingEnvironment.contents = environmentMap
//        }
        
        addGesture()
    }
    
    @IBAction private func restartExperience(_ sender: UIButton) {
        if hasRadarLoaded {
            hasRadarLoaded = false
            
            messageLabel.text = ""
            messageLabel.isHidden = true
            
            for node in sceneView.scene.rootNode.childNodes {
                node.removeFromParentNode()
            }
            
            resetTracking()
        }
    }
    
    /// Creates a new AR configuration to run on the `session`.
    func resetTracking() {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        
        messageLabel.text = "Find a surface to place the Tech Radar"
        messageLabel.isHidden = false
    }
    
    func updateFocusSquare() {
        if hasRadarLoaded {
            focusSquare.hide()
        } else {
            focusSquare.unhide()
            messageLabel.text = "Try moving left or right"
            messageLabel.isHidden = false
        }
        
        // Perform hit testing only when ARKit tracking is in a good state.
        if let camera = sceneView.session.currentFrame?.camera, case .normal = camera.trackingState,
            let result = self.sceneView.smartHitTest(screenCenter) {
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.focusSquare)
                self.focusSquare.state = .detecting(hitTestResult: result, camera: camera)
            }
            messageLabel.text = ""
            messageLabel.isHidden = true
        } else {
            updateQueue.async {
                self.focusSquare.state = .initializing
                self.sceneView.pointOfView?.addChildNode(self.focusSquare)
            }
        }
    }
    
    private func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(ViewController.tap(sender:)))
        gesture.numberOfTapsRequired = 1
        sceneView.addGestureRecognizer(gesture)
    }
    
    @objc func tap(sender: UITapGestureRecognizer) {
        if hasRadarLoaded {
            let location = sender.location(in: sceneView)
            let hitResults = sceneView.hitTest(location, options: nil)
            
            if !hitResults.isEmpty {
                if let hitNode = hitResults.first?.node.parent as? RadarDotNode {
                    hitNode.displayDescription()
                }
            }
        } else {
            guard let cameraTransform = self.sceneView.session.currentFrame?.camera.transform,
                let focusSquareAlignment = focusSquare.recentFocusSquareAlignments.last,
                focusSquare.state != .initializing else {
                    return
            }
            
            // The focus square transform may contain a scale component, so reset scale to 1
            let focusSquareScaleInverse = 1.0 / focusSquare.simdScale.x
            let scaleMatrix = float4x4(uniformScale: focusSquareScaleInverse)
            let focusSquareTransformWithoutScale = focusSquare.simdWorldTransform * scaleMatrix
            
            techRadarNode = self.renderRadar()
            techRadarNode.setTransform(focusSquareTransformWithoutScale,
                                       relativeTo: cameraTransform,
                                       smoothMovement: false,
                                       alignment: focusSquareAlignment,
                                       allowAnimation: false)
            
            updateQueue.async {
                self.sceneView.scene.rootNode.addChildNode(self.techRadarNode!)
                self.sceneView.addOrUpdateAnchor(for: self.techRadarNode!)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        resetTracking()
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
}
