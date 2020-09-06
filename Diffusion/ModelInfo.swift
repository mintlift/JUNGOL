//
//  ModelInfo.swift
//  Diffusion
//
//  Created by Pedro Cuenca on 29/12/22.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import CoreML

enum AttentionVariant: String {
    case original
    case splitEinsum
}

extension AttentionVariant