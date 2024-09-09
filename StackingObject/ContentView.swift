//
//  ContentView.swift
//  StackingObject
//
//  Created by Musaddique Billah Talha on 9/9/24.
//

import SwiftUI
import RealityKit
import ARKit

enum Shape: String, CaseIterable {
    case cube, sphere
}

struct ContentView : View {
    let objectShapes = Shape.allCases
    @State private var selectedShapeIndex = 0
    
    var body: some View {
        
        ZStack(alignment: .bottomTrailing) {
            ARViewContainer(selectedShapeIndex: $selectedShapeIndex)
                .edgesIgnoringSafeArea(.all)
            
            Picker("Shapes", selection: $selectedShapeIndex) {
                ForEach(0..<objectShapes.count, id: \.self) { index in
                    Text(self.objectShapes[index].rawValue).tag(index)
                }
            }
            .pickerStyle(.segmented)
            .padding(10)
            .background(Color.black.opacity(0.6))
        }
    }
}

#Preview {
    ContentView()
}
