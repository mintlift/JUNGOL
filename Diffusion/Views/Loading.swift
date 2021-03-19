
//
//  Loading.swift
//  Diffusion
//
//  Created by Pedro Cuenca on December 2022.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import SwiftUI
import Combine

let model = ModelInfo.v2Base

struct LoadingView: View {
    @StateObject var generation = GenerationContext()

    @State private var preparationPhase = "Downloading…"
    @State private var downloadProgress: Double = 0
    
    enum CurrentView {
        case loading
        case textToImage
        case error(String)
    }
    @State private var currentView: CurrentView = .loading
    
    @State private var stateSubscriber: Cancellable?

    var body: some View {
        VStack {
            switch currentView {
            case .textToImage: TextToImage().transition(.opacity)
            case .error(let message): ErrorPopover(errorMessage: message).transition(.move(edge: .top))
            case .loading:
                // TODO: Don't present progress view if the pipeline is cached
                ProgressView(preparationPhase, value: downloadProgress, total: 1).padding()
            }
        }
        .animation(.easeIn, value: currentView)
        .environmentObject(generation)
        .onAppear {
            Task.init {
                let loader = PipelineLoader(model: model)
                stateSubscriber = loader.statePublisher.sink { state in
                    DispatchQueue.main.async {
                        switch state {
                        case .downloading(let progress):
                            preparationPhase = "Downloading"
                            downloadProgress = progress