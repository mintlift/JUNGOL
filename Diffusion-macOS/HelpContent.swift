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
          
        This is the original Stable Diffusion model that changed the landscape of AI image generation. For more details, visit the [model card](https://huggingface.co/CompVis/stable-diffusion-v1-4) or click on the title above.
        
        **[Stable Diffusion 1.5](https://huggingface.co/runwayml/stable-diffusion-v1-5)**
        
        Same architecture as 1.4, but trained on additional images with a focus on aesthetics.
        
        **[Stable Diffusion 2](https://huggingface.co/StabilityAI/stable-diffusion-2-base)**
        
        Improved model, heavily retrained on millions of additional images. This version corresponds to the [`stable-diffusion-2-base`](https://huggingface.co/StabilityAI/stable-diffusion-2-base) version of the model (trained on 512 x 512 images).
        
        **[Stable Diffusion 2.1](https://huggingface.co/stabilityai/stable-diffusion-2-1-base)**
        
        The last reference in the Stable Diffusion family. Works great with _negative prompts_.
        
        **[OFA small v0](https://huggingface.co/OFA-Sys/small-stable-diffusion-v0)**
        
        This is a special so-called _distilled_ model, half the size of the others. It runs faster and requires less RAM, try it out if you find generation slow!
        
        """, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineOnlyPreservingWhitespace))
    return helpContent(title: "Available Models", description: description, showing: showing, width: 600)
}

func promptsHelp(_ showing: Binding<Bool>) -> some View {
    let description = try! AttributedString(markdown:
        """
        **Prompt** is the description of what you want, and **negative prompt** is what you _don't want_.
        
        Use the negative prompt to tweak a previous generation (by removing unwanted items), or to provide hints for the model.
        
        Many people like to use negative prompts such as "ugly, bad quality" to make the model try harder. \
        Or consider excluding terms like "3d" or "realistic" if you're after particular drawing styles.
        
        """, options: AttributedString.MarkdownParsingOptions(interpretedSyntax: .inlineO