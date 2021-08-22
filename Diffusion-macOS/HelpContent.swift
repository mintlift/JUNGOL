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
            .padding(.top, 10)
            .padding(.all, 5)
        description
        .lineLimit(nil)
        .padding(.bottom, 5)
        .padding([.leading, .trailing], 15)
        Button {
            showing.wrappedValue.toggle()
        } label: {
            Text("Dismiss").frame(maxWidth: 200)
        }
        .padding(.bottom)
    }
    .frame(minWidth: width, idealWidth: width, maxWidth: width)
}

func helpContent(title: String, description: String, showing: Binding<Bool>, width: Double = 400) -> some View {
    helpContent(title: title, description: Text(description), showing: showing)
}

func helpContent(title: String, description: AttributedString, showing: Binding<Bool>, width: Double = 400) -> some View {
    helpContent(title: title, description: Text(description), showing: showing)
}


func modelsHelp(_ showing: Binding<Bool>) -> some View {
    let description = try! AttributedString(markdown:
        """
        Diffusers launches with a set of 5 models that can be downloaded from the Hugging Face Hub:
        
        **[Stable Diffusion 1.4](https://huggingface.co/CompVis/stable-diffusion-v1-4)**
          
        This is the original Stable Diffusion model that changed the landscape of AI image generation. For more details, visit the [model card](htt