//
//  ARViewCoordinator.swift
//  StackingObject
//
//  Created by Musaddique Billah Talha on 9/9/24.
//

import ARKit
import SwiftUI

class ARViewCoordinator: NSObject, ARSessionDelegate {
    var arViewWrapper: ARViewContainer
    @Binding var selectedShapeIndex: Int
    
    init(arViewWrapper: ARViewContainer, selectedShapeIndex: Binding<Int>) {
        self.arViewWrapper = arViewWrapper
        self._selectedShapeIndex = selectedShapeIndex
    }
}
