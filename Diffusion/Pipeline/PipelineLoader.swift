
//
//  PipelineLoader.swift
//  Diffusion
//
//  Created by Pedro Cuenca on December 2022.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//


import CoreML
import Combine

import Path
import ZIPFoundation
import StableDiffusion

class PipelineLoader {
    static let models = Path.applicationSupport / "hf-diffusion-models"
    
    let model: ModelInfo