//
//  ContentView.swift
//  ParticlePaintingsV2
//
//  Created by Taylor Hinchliffe on 2/3/24.
//

import Foundation
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            MetalView()
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
    }
}


#Preview {
    ContentView()
}
