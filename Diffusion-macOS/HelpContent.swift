//
//  HelpContent.swift
//  Diffusion-macOS
//
//  Created by Pedro Cuenca on 7/2/23.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import SwiftUI

func helpContent(title: String, description: Text, showing: Binding<Bool>, width: Double = 400) -> some View {
    VStack {
        Text(title)
            .font(.title3)
 