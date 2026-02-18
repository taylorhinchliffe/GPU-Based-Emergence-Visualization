//
//  Shaders.metal
//  ParticlePaintingsV2
//
//  Created by Taylor Hinchliffe on 2/3/24.
//

#include <metal_stdlib>
using namespace metal;

struct Particle {
    float4 color;
    float2 position;
    float2 velocity;
};

kernel void clearScreen (
                         texture2d<half, access::write> output [[texture(0)]],
                         uint2 id [[thread_position_in_grid]])
{
    output.write(half4(0), id);
}

kernel void drawParticles (
                           texture2d<half, access::write> output [[texture(0)]],
                           device Particle *particles [[buffer(0)]],
                           constant float &zoomLevel [[buffer(1)]],
                           constant float &frameCount [[buffer(2)]],
                           uint id [[thread_position_in_grid]])
{
    float width = output.get_width();
    float height = output.get_height();
    
    Particle particle = particles[id];
    float2 position = particle.position;
    float2 velocity = particle.velocity;
    
    // Slow 2D wave pattern (very subtle) with horizontal and vertical components
    float time = frameCount * 0.001; // Slow time progression
    float amplitudeX = 0.001; // Horizontal amplitude
    float amplitudeY = 0.001; // Vertical amplitude
    float frequencyX = 0.001; // Horizontal frequency
    float frequencyY = 0.001; // Vertical frequency
    float waveNumberX = 0.01; // Horizontal wave number
    float waveNumberY = 0.01; // Vertical wave number
    
    float waveX = amplitudeX * sin(frequencyX * time + waveNumberX * position.x);
    float waveY = amplitudeY * sin(frequencyY * time + waveNumberY * position.y);
    velocity += float2(waveX, waveY); // Add both horizontal and vertical wave components
    
    position += velocity; // Random walk motion
    
    // Boundary reflection
    if (position.x < 0 || position.x > width) {
        velocity.x *= -1;
    }
    if (position.y < 0 || position.y > height) {
        velocity.y *= -1;
    }
    
    position += velocity;
    particle.position = position;
    particle.velocity = velocity;
    particles[id] = particle;
    
    // Scale for zoom-in, centered
    float scaleFactor = zoomLevel; // Higher zoomLevel magnifies
    float2 center = float2(width / 2.0, height / 2.0);
    float2 renderPosition = (position - center) * scaleFactor + center;
    
    // Scale particle size with zoom
    float sizeFactor = zoomLevel;
    int renderSize = int(1.0 * sizeFactor);
    
    half4 color = half4(particle.color.r, particle.color.g, particle.color.b, 1);
    uint2 pos = uint2(renderPosition.x, renderPosition.y);
    
    // Clamp to texture bounds
    pos = uint2(
        min(max(uint(0.0), pos.x), uint(width - 1)),
        min(max(uint(0.0), pos.y), uint(height - 1))
    );
    
    // Write to a dynamic grid based on sizeFactor
    for (int dx = -renderSize; dx <= renderSize; dx++) {
        for (int dy = -renderSize; dy <= renderSize; dy++) {
            uint2 offsetPos = pos + uint2(dx, dy);
            if (offsetPos.x < uint(width) && offsetPos.y < uint(height)) {
                output.write(color, offsetPos);
            }
        }
    }
}
