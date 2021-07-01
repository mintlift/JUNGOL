//
//  GeneratedImageView.swift
//  Diffusion
//
//  Created by Pedro Cuenca on 18/1/23.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import SwiftUI

struct GeneratedImageView: View {
    @EnvironmentObject var generation: GenerationContext
    
    var body: some View {
        switch generation.state {
        case .startup: return AnyView(Image("placeholder").resizable())
        case .running(let progress):
       