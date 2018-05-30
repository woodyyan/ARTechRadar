//
//  TechRadarNode.swift
//  ARTechRadar
//
//  Created by Songbai Yan on 2018/5/28.
//  Copyright © 2018 Songbai Yan. All rights reserved.
//

import Foundation
import ARKit

class TechRadarNode: SCNNode {
    
    /// Use average of recent virtual object distances to avoid rapid changes in object scale.
    private var recentVirtualObjectDistances = [Float]()
    
    /// The object's corresponding ARAnchor
    var anchor: ARAnchor?
    
    /// Current alignment of the virtual object
    var currentAlignment: ARPlaneAnchor.Alignment = .horizontal
    
    /// Whether the object is currently changing alignment
    private var isChangingAlignment: Bool = false
    
    /// Remember the last rotation for horizontal alignment
    var rotationWhenAlignedHorizontally: Float = 0
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// For correct rotation on horizontal and vertical surfaces, roate around
    /// local y rather than world y. Therefore rotate first child note instead of self.
    var objectRotation: Float {
        get {
            return childNodes.first!.eulerAngles.y
        }
        set (newValue) {
            var normalized = newValue.truncatingRemainder(dividingBy: 2 * .pi)
            normalized = (normalized + 2 * .pi).truncatingRemainder(dividingBy: 2 * .pi)
            if normalized > .pi {
                normalized -= 2 * .pi
            }
            childNodes.first!.eulerAngles.y = normalized
            if currentAlignment == .horizontal {
                rotationWhenAlignedHorizontally = normalized
            }
        }
    }
    
    /**
     Set the object's position based on the provided position relative to the `cameraTransform`.
     If `smoothMovement` is true, the new position will be averaged with previous position to
     avoid large jumps.
     
     - Tag: VirtualObjectSetPosition
     */
    func setTransform(_ newTransform: float4x4,
                      relativeTo cameraTransform: float4x4,
                      smoothMovement: Bool,
                      alignment: ARPlaneAnchor.Alignment,
                      allowAnimation: Bool) {
        let cameraWorldPosition = cameraTransform.translation
        var positionOffsetFromCamera = newTransform.translation - cameraWorldPosition
        
        // Limit the distance of the object from the camera to a maximum of 10 meters.
        if simd_length(positionOffsetFromCamera) > 10 {
            positionOffsetFromCamera = simd_normalize(positionOffsetFromCamera)
            positionOffsetFromCamera *= 10
        }
        
        /*
         Compute the average distance of the object from the camera over the last ten
         updates. Notice that the distance is applied to the vector from
         the camera to the content, so it affects only the percieved distance to the
         object. Averaging does _not_ make the content "lag".
         */
        if smoothMovement {
            let hitTestResultDistance = simd_length(positionOffsetFromCamera)
            
            // Add the latest position and keep up to 10 recent distances to smooth with.
            recentVirtualObjectDistances.append(hitTestResultDistance)
            recentVirtualObjectDistances = Array(recentVirtualObjectDistances.suffix(10))
            
            let averageDistance = recentVirtualObjectDistances.average!
            let averagedDistancePosition = simd_normalize(positionOffsetFromCamera) * averageDistance
            simdPosition = cameraWorldPosition + averagedDistancePosition
        } else {
            simdPosition = cameraWorldPosition + positionOffsetFromCamera
        }
        
        updateAlignment(to: alignment, transform: newTransform, allowAnimation: allowAnimation)
    }
    
    /// Resets the object's position smoothing.
    func reset() {
        recentVirtualObjectDistances.removeAll()
    }
    
    // MARK: - Setting the object's alignment
    
    func updateAlignment(to newAlignment: ARPlaneAnchor.Alignment, transform: float4x4, allowAnimation: Bool) {
        if isChangingAlignment {
            return
        }
        
        // Only animate if the alignment has changed.
        let animationDuration = (newAlignment != currentAlignment && allowAnimation) ? 0.5 : 0
        
        var newObjectRotation: Float?
        if newAlignment == .horizontal && currentAlignment == .vertical {
            // When changing to horizontal placement, restore the previous horizontal rotation.
            newObjectRotation = rotationWhenAlignedHorizontally
        } else if newAlignment == .vertical && currentAlignment == .horizontal {
            // When changing to vertical placement, reset the object's rotation (y-up).
            newObjectRotation = 0.0001
        }
        
        currentAlignment = newAlignment
        
        SCNTransaction.begin()
        SCNTransaction.animationDuration = animationDuration
        SCNTransaction.completionBlock = {
            self.isChangingAlignment = false
        }
        
        isChangingAlignment = true
        
        // Use the filtered position rather than the exact one from the transform.
        simdTransform = transform
        simdTransform.translation = simdWorldPosition
        
        if newObjectRotation != nil {
            objectRotation = newObjectRotation!
        }
        
        SCNTransaction.commit()
    }
    
    /// Allowed alignments for the virtual object
    var allowedAlignments: [ARPlaneAnchor.Alignment] {
        return [.horizontal]
    }
    
    /// - Tag: AdjustOntoPlaneAnchor
    func adjustOntoPlaneAnchor(_ anchor: ARPlaneAnchor, using node: SCNNode) {
        // Test if the alignment of the plane is compatible with the object's allowed placement
        if !allowedAlignments.contains(anchor.alignment) {
            return
        }
        
        // Get the object's position in the plane's coordinate system.
        let planePosition = node.convertPosition(position, from: parent)
        
        // Check that the object is not already on the plane.
        guard planePosition.y != 0 else { return }
        
        // Add 10% tolerance to the corners of the plane.
        let tolerance: Float = 0.1
        
        let minX: Float = anchor.center.x - anchor.extent.x / 2 - anchor.extent.x * tolerance
        let maxX: Float = anchor.center.x + anchor.extent.x / 2 + anchor.extent.x * tolerance
        let minZ: Float = anchor.center.z - anchor.extent.z / 2 - anchor.extent.z * tolerance
        let maxZ: Float = anchor.center.z + anchor.extent.z / 2 + anchor.extent.z * tolerance
        
        guard (minX...maxX).contains(planePosition.x) && (minZ...maxZ).contains(planePosition.z) else {
            return
        }
        
        // Move onto the plane if it is near it (within 5 centimeters).
        let verticalAllowance: Float = 0.05
        let epsilon: Float = 0.001 // Do not update if the difference is less than 1 mm.
        let distanceToPlane = abs(planePosition.y)
        if distanceToPlane > epsilon && distanceToPlane < verticalAllowance {
            SCNTransaction.begin()
            SCNTransaction.animationDuration = CFTimeInterval(distanceToPlane * 500) // Move 2 mm per second.
            SCNTransaction.animationTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            position.y = anchor.transform.columns.3.y
            updateAlignment(to: anchor.alignment, transform: simdWorldTransform, allowAnimation: false)
            SCNTransaction.commit()
        }
    }
}

extension Collection where Element == Float, Index == Int {
    /// Return the mean of a list of Floats. Used with `recentVirtualObjectDistances`.
    var average: Float? {
        guard !isEmpty else {
            return nil
        }
        
        let sum = reduce(Float(0)) { current, next -> Float in
            return current + next
        }
        
        return sum / Float(count)
    }
}
