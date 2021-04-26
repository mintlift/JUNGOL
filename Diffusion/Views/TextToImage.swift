//
//  TextToImage.swift
//  Diffusion
//
//  Created by Pedro Cuenca on December 2022.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import SwiftUI
import Combine
import StableDiffusion


/// Presents "Share" + "Save" buttons on Mac; just "Share" on iOS/iPadOS.
/// This is because I didn't find a way for "Share" to show a Save option when running on macOS.
struct ShareButtons: View {
    var image: CGImage
    var name: String
    
    var filename: String {
        name.replacingOccurrences(of: " ", with: "_")
    }
    
    var body: some View {
        let imageView = Image(image, scale: 1, label: Text(name))

        if runningOnMac {
            HStack {
                ShareLink(item: imageView, preview: SharePreview(name, image: imageView))
                Button() {
                    guard let imageData = UIImage(cgImage: image).pngData() else {
                        return
                    }
                    do {
                        let fileURL = FileManager.default.temporaryDirectory.appendingPathComponent("\(filename).png")
                        try imageData.write(to: fileURL)
                        let controller = UIDocumentPickerViewController(forExporting: [fileURL])
                        
                        let scene = UIApplication.shared.connectedScenes.first as! UIWindowScene
                        scene.windows.first!.rootViewController!.present(controller, animated: true)
                    } catch {
                        print("Error creating file")
                    }
                } label: {
                    Label("Save…", systemImage: "square.and.arrow.down")
                }
            }
        } else {
            ShareLink(item: imageView, preview: SharePreview(name, image: imageView))
        }
    }
}

struct ImageWithPlaceholder: View {
    var state: Binding<GenerationState>
        
    var body: some View {
        switch state.wrappedValue {
        case .startup: return AnyView(Image("placeholder").resizable())
        case .running(let progress):
            guard let progress = progress, progress.stepCount > 0 else {
                // The first time it takes a little bit before generation starts
                return AnyView(ProgressView())
            }
            let step = Int(progress.step) + 1
            let fraction = Double(step) / Double(progress.stepCount)
            let label = "Step \(step) of \(progress.stepCount)"
            return AnyView(ProgressView(label, value: fraction, total: 1).padding())
        case .complete(let lastPrompt, let image, _, let interval):
            guard let theImage = image else {
          