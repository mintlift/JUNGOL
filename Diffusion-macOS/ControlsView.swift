
//
//  PromptView.swift
//  Diffusion-macOS
//
//  Created by Cyril Zakka on 1/12/23.
//  See LICENSE at https://github.com/huggingface/swift-coreml-diffusers/LICENSE
//

import Combine
import SwiftUI
import CompactSlider

enum PipelineState {
    case downloading(Double)
    case uncompressing
    case loading
    case ready
    case failed(Error)
}

/// Mimics the native appearance, but labels are clickable.
/// To be removed (adding gestures to all labels) if we observe any UI shenanigans.
struct LabelToggleDisclosureGroupStyle: DisclosureGroupStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                Button {
                    withAnimation {
                        configuration.isExpanded.toggle()
                    }
                } label: {
                    Image(systemName: configuration.isExpanded ? "chevron.down" : "chevron.right").frame(width:8, height: 8)
                }.buttonStyle(.plain).font(.footnote).fontWeight(.semibold).foregroundColor(.gray)
                configuration.label.onTapGesture {
                    withAnimation {
                        configuration.isExpanded.toggle()
                    }
                }
                Spacer()
            }
            if configuration.isExpanded {
                configuration.content
            }
        }
    }
}

struct ControlsView: View {
    @EnvironmentObject var generation: GenerationContext

    static let models = ModelInfo.MODELS
    
    @State private var model = Settings.shared.currentModel.modelVersion
    @State private var disclosedModel = true
    @State private var disclosedPrompt = true
    @State private var disclosedGuidance = false
    @State private var disclosedSteps = false
    @State private var disclosedSeed = false
    @State private var disclosedAdvanced = false

    // TODO: refactor download with similar code in Loading.swift (iOS)
    @State private var stateSubscriber: Cancellable?
    @State private var pipelineState: PipelineState = .downloading(0)
    @State private var pipelineLoader: PipelineLoader? = nil

    // TODO: make this computed, and observable, and easy to read
    @State private var mustShowSafetyCheckerDisclaimer = false
    @State private var mustShowModelDownloadDisclaimer = false      // When changing advanced settings

    @State private var showModelsHelp = false
    @State private var showPromptsHelp = false
    @State private var showGuidanceHelp = false
    @State private var showStepsHelp = false
    @State private var showSeedHelp = false
    @State private var showAdvancedHelp = false

    // Reasonable range for the slider
    let maxSeed: UInt32 = 1000

    func updateSafetyCheckerState() {
        mustShowSafetyCheckerDisclaimer = generation.disableSafety && !Settings.shared.safetyCheckerDisclaimerShown
    }
    
    func updateComputeUnitsState() {
        Settings.shared.userSelectedComputeUnits = generation.computeUnits
        modelDidChange(model: Settings.shared.currentModel)
    }
    
    func resetComputeUnitsState() {
        generation.computeUnits = Settings.shared.userSelectedComputeUnits ?? ModelInfo.defaultComputeUnits
    }
    
    func modelDidChange(model: ModelInfo) {
        guard pipelineLoader?.model != model || pipelineLoader?.computeUnits != generation.computeUnits else {
            print("Reusing same model \(model) with units \(generation.computeUnits)")
            return
        }

        print("Loading model \(model)")
        Settings.shared.currentModel = model

        pipelineLoader?.cancel()
        pipelineState = .downloading(0)
        Task.init {
            let loader = PipelineLoader(model: model, computeUnits: generation.computeUnits, maxSeed: maxSeed)
            self.pipelineLoader = loader
            stateSubscriber = loader.statePublisher.sink { state in
                DispatchQueue.main.async {
                    switch state {
                    case .downloading(let progress):
                        print("\(loader.model.modelVersion): \(progress)")
                        pipelineState = .downloading(progress)
                    case .uncompressing:
                        pipelineState = .uncompressing
                    case .readyOnDisk:
                        pipelineState = .loading
                    case .failed(let error):
                        pipelineState = .failed(error)
                    default:
                        break
                    }
                }
            }
            do {
                generation.pipeline = try await loader.prepare()
                pipelineState = .ready
            } catch {
                print("Could not load model, error: \(error)")
                pipelineState = .failed(error)
            }
        }
    }
    
    func isModelDownloaded(_ model: ModelInfo, computeUnits: ComputeUnits? = nil) -> Bool {
        PipelineLoader(model: model, computeUnits: computeUnits ?? generation.computeUnits).ready
    }
    
    func modelLabel(_ model: ModelInfo) -> Text {
        let downloaded = isModelDownloaded(model)
        let prefix = downloaded ? "● " : "◌ "  //"○ "
        return Text(prefix).foregroundColor(downloaded ? .accentColor : .secondary) + Text(model.modelVersion)
    }
    
    var modelFilename: String? {
        guard let pipelineLoader = pipelineLoader else { return nil }
        let selectedPath = pipelineLoader.compiledPath
        guard selectedPath.exists else { return nil }
        return selectedPath.string
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            
            Label("Generation Options", systemImage: "gearshape.2")
                .font(.headline)
                .fontWeight(.bold)
            Divider()
            
            ScrollView {
                Group {
                    DisclosureGroup(isExpanded: $disclosedModel) {
                        let revealOption = "-- reveal --"
                        Picker("", selection: $model) {
                            ForEach(Self.models, id: \.modelVersion) {
                                modelLabel($0)
                            }
                            Text("Reveal in Finder…").tag(revealOption)
                        }
                        .onChange(of: model) { selection in
                            guard selection != revealOption else {
                                NSWorkspace.shared.selectFile(modelFilename, inFileViewerRootedAtPath: PipelineLoader.models.string)
                                model = Settings.shared.currentModel.modelVersion
                                return
                            }
                            guard let model = ModelInfo.from(modelVersion: selection) else { return }
                            modelDidChange(model: model)
                        }
                    } label: {
                        HStack {