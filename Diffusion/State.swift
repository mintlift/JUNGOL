//
//  State.swift
//  Diffusion
//
//  Created by Pedro Cuenca on 17/1/23.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import Combine
import SwiftUI
import StableDiffusion
import CoreML

let DEFAULT_MODEL = ModelInfo.v2Base
let DEFAULT_PROMPT = "Labrador in the style of Vermeer"

enum GenerationState {
    case startup
    case running(StableDiffusionProgress?)
    case complete(String, CGImage?, UInt32, TimeInterval?)
    case userCanceled
    case failed(Error)
}

typealias ComputeUnits = MLComputeUnits

class GenerationContext: ObservableObject {
    let scheduler = StableDiffusionScheduler.dpmSolverMultistepScheduler

    @Published var pipeline: Pipeline? = nil {
        didSet {
            if let pipeline = pipeline {
                progressSubscriber = pipeline
                    .progressPublisher
                    .receive(on: DispatchQueue.main)
                    .sink { progress in
                        guard let progress = progress else { return }
                        self.state = .running(progress)
                    }
            }
        }
    }
    @Published var state: GenerationState = .startup
    
    @Published var positivePrompt = DEFAULT_PROMPT
    @Published var negativePrompt = ""
    
    // FIXME: Double to support the slider component
    @Published var steps = 25.0
    @Published var numImages = 1.0
    @Published var seed = -1.0
    @Published var guidanceScale = 7.5
    @Published var disableSafety = false
    
    @Published var computeUnits: ComputeUnits = Settings.shared.userSelectedComputeUnits ?? ModelInfo.defaultComputeUnits

    private var progressSubscriber: Cancellable?

    func generate() async throws -> GenerationResult {
        guard let pipeline = pipeline else { throw "No pipeline" }
        let seed = self.seed >= 0 ? UInt32(self.seed) : nil
        return try pipeline.generate(
            prompt: positivePrompt,
            negativePrompt: negativePrompt,
            scheduler: scheduler,
            numInferenceSteps: Int(steps),
            seed: seed,
            guidanceScale: Float(guidanceScale),
            disableSafety: disableSafety
        )
    }
    
    func cancelGeneration() {
        pipeline?.setCancelled()
    }
}

class Settings {
    static let shared = Settings()
    
    let defaults = UserDefaults.standard
    
    enum Keys: String {
        case model
        case safetyCheckerDisclaimer
        case computeUnits
    }
    
    private init() {
        defaults.register(defaults: [
            Keys.model.rawValu