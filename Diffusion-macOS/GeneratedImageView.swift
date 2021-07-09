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
            guard let progress = progress, progress.stepCount > 0 else {
                // The first time it takes a little bit before generation starts
                return AnyView(ProgressView())
            }
            let step = Int(progress.step) + 1
            let fraction = Double(step) / Double(progress.stepCount)
            let label = "Step \(step) of \(progress.stepCount)"
            return AnyView(HStack {
                ProgressView(label, value: fraction, total: 1).padding()
                Button {
                    generation.cancelGeneration()
                } label: {
      