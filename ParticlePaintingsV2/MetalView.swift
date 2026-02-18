//
//  MetalView.swift
//  ParticlePaintingsV2
//
//  Created by Taylor Hinchliffe on 2/3/24.
//

import Foundation
import SwiftUI
import MetalKit

struct MetalView: View {
    @State private var metalView = MTKView()
    @State private var renderer: Renderer?
    @State private var zoomLevel: Float = 1.0 // 1.0 is max zoom, up to 30.0 for 30x zoom-in

    var body: some View {
        VStack {
            HStack {
                Text("Equation: (with boundary reflections: v → -v at edges)   ")
                    .font(.system(size: 24))
                
                if zoomLevel >= 15 {
                    Text("r[n+1] = r[n] + v[n]") // Highlight random walk when zoom >= 5
                        .foregroundColor(.green)
                        .background(Color.black)
                        .font(.system(size: 24))
                } else {
                    Text("r[n+1] = r[n] + v[n]") // Normal when zoom < 5
                        .foregroundColor(.white)
                        .background(Color.black)
                        .font(.system(size: 24))
                }
                
                if zoomLevel < 15 {
                    Text("+ A_x sin(ω_x t + k_x x) ẋ + A_y sin(ω_y t + k_y y) ẏ ") // Highlight 2D wave when zoom < 5
                        .foregroundColor(.green)
                        .background(Color.black)
                        .font(.system(size: 24))
                } else {
                    Text("+ A_x sin(ω_x t + k_x x) ẋ + A_y sin(ω_y t + k_y y) ẏ ") // Normal when zoom >= 5
                        .foregroundColor(.white)
                        .background(Color.black)
                        .font(.system(size: 24))
                }
                Text("")
                

            }
            .foregroundColor(.white)
            .background(Color.black)
            .frame(maxWidth: .infinity, alignment: .center)
            MetalViewRepresentable(metalView: $metalView)
                .onAppear {
                    renderer = Renderer(metalView: metalView)
                    renderer?.zoomLevel = zoomLevel
                }
            Slider(value: $zoomLevel, in: 1.0...30.0, step: 1.0) // 30x max zoom
                .onChange(of: zoomLevel) { newValue in
                    renderer?.zoomLevel = newValue
                }
                .padding()
            Text("Zoom Level: \(Int(zoomLevel))x")
        }
    }
}

struct MetalViewRepresentable: NSViewRepresentable {
    @Binding var metalView: MTKView

    func makeNSView(context: Context) -> some NSView {
        metalView
    }

    func updateNSView(_ uiView: NSViewType, context: Context) { }
}
