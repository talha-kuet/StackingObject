//
//  ARViewContainer.swift
//  StackingObject
//
//  Created by Musaddique Billah Talha on 9/9/24.
//

import SwiftUI
import ARKit
import RealityKit

struct ARViewContainer: UIViewRepresentable {
    @Binding var selectedShapeIndex: Int
    
    func makeCoordinator() -> ARViewCoordinator {
        return ARViewCoordinator(arViewWrapper: self, selectedShapeIndex: $selectedShapeIndex)
    }
    
    func makeUIView(context: Context) -> ARView {
        let arView = ARView(frame: .zero, cameraMode: .ar, automaticallyConfigureSession: true)
        arView.enableTapGesture()
        arView.session.delegate = context.coordinator
        return arView
    }
    
    func updateUIView(_ uiView: ARView, context: Context) {}
}

extension ARView {
    
    func enableTapGesture() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func createModel(shape: Shape) -> ModelEntity {
        let mesh = shape == .cube ? MeshResource.generateBox(size: 0.1, cornerRadius: 0.005) : MeshResource.generateSphere(radius: 0.1)
        let material = SimpleMaterial(color: UIColor.randomColor(), roughness: 0.3, isMetallic: true)
        let modelEntity = ModelEntity(mesh: mesh, materials: [material])
//        modelEntity.generateCollisionShapes(recursive: true)
        return modelEntity
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        
        guard let coordinator = self.session.delegate as? ARViewCoordinator else {
            print("Error obtaining coordinator")
            return
        }
        
        let tapLocation: CGPoint = sender.location(in: self)
        guard let rayResult = self.ray(through: tapLocation) else { return }
        let results = self.scene.raycast(from: rayResult.origin, to: rayResult.direction)
        
        if let firstResult = results.first {
            var position = firstResult.position
            position.y += 0.3/2
            placeCube(at: position, shape: Shape.allCases[coordinator.selectedShapeIndex])
        } else {
            let tapLocation: CGPoint = sender.location(in: self)
            let estimatedPlane: ARRaycastQuery.Target = .estimatedPlane
            let alignment: ARRaycastQuery.TargetAlignment = .horizontal
                    
            let results: [ARRaycastResult] = self.raycast(from: tapLocation, allowing: estimatedPlane, alignment: alignment)
            guard let rayCast: ARRaycastResult = results.first else { return }
            let position = simd_make_float3(rayCast.worldTransform.columns.3)
            
            placeCube(at: position, shape: Shape.allCases[coordinator.selectedShapeIndex])
        }
    }
    
    func placeCube(at position: SIMD3<Float>, shape: Shape) {
        let modelEntity = createModel(shape: shape)
        let anchor = AnchorEntity(.plane(.horizontal, classification: .any, minimumBounds: SIMD2<Float>(0.2, 0.2)))
        let anchorEntity = AnchorEntity(world: position)
        anchorEntity.addChild(modelEntity)
        
        self.scene.addAnchor(anchorEntity)
    }
}
