//
//  Renderer.swift
//  ParticlePaintingsV2
//
//  Created by Taylor Hinchliffe on 2/3/24.
//

//
//  Renderer.swift
//  ParticlePaintingsMacOSV1
//
//  Created by Taylor Hinchliffe on 2/3/24.
//

import Foundation
import MetalKit

struct Particle {
    var color: SIMD4<Float>
    var position: SIMD2<Float>
    var velocity: SIMD2<Float>
}

class Renderer: NSObject {
    static var device: MTLDevice!
    static var commandQueue: MTLCommandQueue!
    
    var clearState: MTLComputePipelineState!
    var drawState: MTLComputePipelineState!
    
    var particleBuffer: MTLBuffer!
    var particleCount: Int = 1000000
    var zoomLevel: Float = 1.0 // 1.0 is max zoom, up to 30.0 for 30x zoom-in
    var frameCount: Float = 0.0 // Track frame time
    
    init(metalView: MTKView) {
        super.init()
        
        guard let device = MTLCreateSystemDefaultDevice(),
              let commandQueue = device.makeCommandQueue()
        else {
            fatalError("GPU not available")
        }
        
        Renderer.device = device
        Renderer.commandQueue = commandQueue
        
        let library = device.makeDefaultLibrary()
        let clearFunc = library?.makeFunction(name: "clearScreen")
        let drawFunc = library?.makeFunction(name: "drawParticles")
        
        do {
            clearState = try device.makeComputePipelineState(function: clearFunc!)
            drawState = try device.makeComputePipelineState(function: drawFunc!)
        } catch let error as NSError {
            print(error)
        }
        
        metalView.device = device
        metalView.framebufferOnly = false
        metalView.delegate = self
        
        initializeBuffers()
    }
    
    func initializeBuffers() {
        let screenWidth: Float = 3546
        let screenHeight: Float = 2234
        var particles: [Particle] = []
        
        for _ in 0..<particleCount {
            let color = SIMD4<Float>(Float.random(in: 0...1), Float.random(in: 0...1), Float.random(in: 0...1), 1)
            let position = SIMD2<Float>(Float.random(in: 0...screenWidth), Float.random(in: 0...screenHeight))
            let velocity = SIMD2<Float>((Float.random(in: -0.05...0.05)), (Float.random(in: -0.05...0.05)))
            
            let particle = Particle(color: color, position: position, velocity: velocity)
            particles.append(particle)
        }
        
        let size = MemoryLayout<Particle>.stride * particles.count
        particleBuffer = Renderer.device.makeBuffer(bytes: particles, length: size)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) { }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else { return }
        
        let commandBuffer = Renderer.commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer?.makeComputeCommandEncoder()
        
        commandEncoder?.setComputePipelineState(clearState)
        commandEncoder?.setTexture(drawable.texture, index: 0)
        
        let w = clearState.threadExecutionWidth
        let h = clearState.maxTotalThreadsPerThreadgroup / w
        
        var threadsPerThreadGroup = MTLSize(width: w, height: h, depth: 1)
        var threadsPerGrid = MTLSize(width: drawable.texture.width, height: drawable.texture.height, depth: 1)
        commandEncoder?.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadGroup)
        
        commandEncoder?.setComputePipelineState(drawState)
        commandEncoder?.setBuffer(particleBuffer, offset: 0, index: 0)
        commandEncoder?.setBytes(&zoomLevel, length: MemoryLayout<Float>.stride, index: 1)
        commandEncoder?.setBytes(&frameCount, length: MemoryLayout<Float>.stride, index: 2) // Pass frame count
        threadsPerGrid = MTLSize(width: particleCount, height: 1, depth: 1)
        threadsPerThreadGroup = MTLSize(width: w, height: 1, depth: 1)
        commandEncoder?.dispatchThreads(threadsPerGrid, threadsPerThreadgroup: threadsPerThreadGroup)
        
        commandEncoder?.endEncoding()
        commandBuffer?.present(drawable)
        commandBuffer?.commit()
        
        frameCount += 0.1; // Increment frame count slowly
    }
}
