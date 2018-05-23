//
//  ViewController+ARDelegate.swift
//  ARTechRadar
//
//  Created by Songbai Yan on 2018/5/21.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import ARKit

extension ViewController: ARSCNViewDelegate, ARSessionDelegate {
    
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        messageLabel.isHidden = false
        messageLabel.text = camera.trackingState.presentationString

        switch camera.trackingState {
        case .notAvailable, .limited:
            var message = camera.trackingState.presentationString
            if let recommendation = camera.trackingState.recommendation {
                message.append(": \(recommendation)")
            }
            messageLabel.text = message
        case .normal:
            messageLabel.isHidden = true
            messageLabel.text = ""
            // Unhide content after successful relocalization.
            //virtualObjectLoader.loadedObjects.forEach { $0.isHidden = false }
        }
    }
    
    func session(_ session: ARSession, didFailWithError error: Error) {
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Hide content before going into the background.
    }
    
    // MARK: - ARSCNViewDelegate
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard anchor is ARPlaneAnchor else { return }
        
        DispatchQueue.main.async {
            self.messageLabel.isHidden = false
            self.messageLabel.text = "SURFACE DETECTED"
        }
        
        if !hasRadarLoaded {
            renderRadar(node: node)
            hasRadarLoaded = true
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval) {
        DispatchQueue.main.async {
            self.updateFocusSquare()
        }
        
        // If light estimation is enabled, update the intensity of the model's lights and the environment map
        let baseIntensity: CGFloat = 40
        let lightingEnvironment = sceneView.scene.lightingEnvironment
        if let lightEstimate = sceneView.session.currentFrame?.lightEstimate {
            lightingEnvironment.intensity = lightEstimate.ambientIntensity / baseIntensity
        } else {
            lightingEnvironment.intensity = baseIntensity
        }
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        updateQueue.async {
//            if let planeAnchor = anchor as? ARPlaneAnchor {
//                for object in self.virtualObjectLoader.loadedObjects {
//                    object.adjustOntoPlaneAnchor(planeAnchor, using: node)
//                }
//            } else {
//                if let objectAtAnchor = self.virtualObjectLoader.loadedObjects.first(where: { $0.anchor == anchor }) {
//                    objectAtAnchor.simdPosition = anchor.transform.translation
//                    objectAtAnchor.anchor = anchor
//                }
//            }
        }
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
        
        let fontName = "OpenSans-SemiBold"
        let color = UIColor.black
        let yPos: Float = 0.027
        let zPos: Float = radarAnchor.z + 0.02
        
        for (index, level) in Level.allValues.enumerated() {
            let rightLevelTextNode = TextNode.init(level, color, fontName)
            rightLevelTextNode.position = SCNVector3.init(radarAnchor.x + basicRadius * getRightX(index), yPos, zPos)
            rightLevelTextNode.rotation = SCNVector4Make(1, 0, 0, -Float(.pi/2.0))
            node.addChildNode(rightLevelTextNode)
            
            let leftLevelTextNode = TextNode.init(level, color, fontName)
            leftLevelTextNode.position = SCNVector3.init(radarAnchor.x + basicRadius * (-1/3 - getRightX(index)), yPos, zPos)
            leftLevelTextNode.rotation = SCNVector4Make(1, 0, 0, -Float(.pi/2.0))
            node.addChildNode(leftLevelTextNode)
        }
        
        node.addChildNode(horizon)
        node.addChildNode(vertical)
    }
    
    // TODO: Refactor these two methods
    private func getRightX(_ index: Int) -> Float {
        switch index {
        case 0:
            return 1/3
        case 1:
            return 4/3
        case 2:
            return 19/9
        case 3:
            return 8/3
        default:
            return 0
        }
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
}
