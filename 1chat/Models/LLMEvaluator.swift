//
//  LLMEvaluator.swift
//  1chat
//
//  Created by OJZen on 2025/2/10.
//

import MLX
import MLXLLM
import MLXLMCommon
import MLXRandom
import SwiftUI

enum LLMEvaluatorError: Error {
    case modelNotFound(String)
}

@Observable
@MainActor
class LLMEvaluator {
    var running = false
    var cancelled = false
    var output = ""
    var modelInfo = ""
    var stat = ""
    var progress = 0.0
    var thinkingTime: TimeInterval?
    var collapsed: Bool = false
    var isThinking: Bool = false
    var isRepeating = false

    var elapsedTime: TimeInterval? {
        if let startTime {
            return Date().timeIntervalSince(startTime)
        }

        return nil
    }

    private var startTime: Date?

    let modelConfiguration = ModelConfiguration(
        directory: Bundle.main.resourceURL?.appending(path: "model") ?? Bundle.main.bundleURL.appending(path: "model"),
        overrideTokenizer: "PreTrainedTokenizer",
        defaultPrompt: ""
    )

    /// parameters controlling the output
    let generateParameters = GenerateParameters(temperature: 0.6)
    let maxTokens = 4096

    /// update the display every N tokens -- 4 looks like it updates continuously
    /// and is low overhead.  observed ~15% reduction in tokens/s when updating
    /// on every token
    let displayEveryNTokens = 4

    enum LoadState {
        case idle
        case loaded(ModelContainer)
    }

    var loadState = LoadState.idle

    /// load and return the model -- can be called multiple times, subsequent calls will
    /// just return the loaded model
    func load() async throws -> ModelContainer {
        switch loadState {
        case .idle:
            // limit the buffer cache
            MLX.GPU.set(cacheLimit: 20 * 1024 * 1024)

            let modelContainer = try await LLMModelFactory.shared.loadContainer(
                configuration: modelConfiguration
            ) {
                [modelConfiguration] progress in
                Task { @MainActor in
                    self.modelInfo =
                        "Downloading \(modelConfiguration.name): \(Int(progress.fractionCompleted * 100))%"
                    self.progress = progress.fractionCompleted
                }
            }
            modelInfo =
                "Loaded \(modelConfiguration.id).  Weights: \(MLX.GPU.activeMemory / 1024 / 1024)M"
            print(modelInfo)
            loadState = .loaded(modelContainer)
            return modelContainer

        case let .loaded(modelContainer):
            return modelContainer
        }
    }

    func stop() {
        isThinking = false
        cancelled = true
    }

    func generate(thread: Thread, systemPrompt: String) async -> String {
        guard !running else { return "" }

        isRepeating = false
        running = true
        cancelled = false
        startTime = Date()

        do {
            let modelContainer = try await load()

            // augment the prompt as needed
            let promptHistory = modelContainer.configuration.getPromptHistory(thread: thread, systemPrompt: systemPrompt)

            if modelContainer.configuration.modelType == .reasoning {
                isThinking = true
            }

            // each time you generate you will get something new
            MLXRandom.seed(UInt64(Date.timeIntervalSinceReferenceDate * 1000))

            let result = try await modelContainer.perform { context in
                let input = try await context.processor.prepare(input: .init(messages: promptHistory))
                return try MLXLMCommon.generate(
                    input: input, parameters: generateParameters, context: context
                ) { tokens in

                    var cancelled = false
                    Task { @MainActor in
                        cancelled = self.cancelled
                    }

                    // update the output -- this will make the view show the text as it generates
                    if tokens.count % displayEveryNTokens == 0 {
                        // 有大量重复内容，截断
                        if RepeatChecker().hasExcessiveRepetition(in: tokens) {
                            Task { @MainActor in
                                self.cancelled = true
                                self.isRepeating = true
                                print("Stop! text repeat endless!")
                            }
                        }
                        let text = context.tokenizer.decode(tokens: tokens)
                        Task { @MainActor in
                            self.output = text
                        }
                    }

                    if tokens.count >= maxTokens || cancelled {
                        return .stop
                    } else {
                        return .more
                    }
                }
            }

            // update the text if needed, e.g. we haven't displayed because of displayEveryNTokens
            if result.output != output {
                output = result.output
            }
            stat = " Tokens/second: \(String(format: "%.3f", result.tokensPerSecond))"
            print(stat)
        } catch {
            output = "Failed: \(error)"
        }

        running = false
        return output
    }
}

enum LLMError: Error {
    case withoutThinkTagError(String)
    case runtimeError(String)
}

