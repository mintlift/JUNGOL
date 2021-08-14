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

func helpContent(t