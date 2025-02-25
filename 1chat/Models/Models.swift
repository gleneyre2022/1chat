//
//  Models.swift
//  1chat
//
//  Created by OJZen on 2025/2/10.
//

import MLXLMCommon
import Foundation

public extension ModelConfiguration {
    enum ModelType {
        case regular, reasoning
    }
    
    var modelType: ModelType {
        switch self {
        case .deepseek_r1_distill_qwen_1_5b_4bit: .reasoning
        default: .regular
        }
    }
}

extension ModelConfiguration: @retroactive Equatable {
    public static func == (lhs: MLXLMCommon.ModelConfiguration, rhs: MLXLMCommon.ModelConfiguration) -> Bool {
        return lhs.name == rhs.name
    }
    
    public static let llama_3_2_1B_4bit = ModelConfiguration(
        id: "mlx-community/Llama-3.2-1B-Instruct-4bit"
    )
    
    public static let llama_3_2_3b_4bit = ModelConfiguration(
        id: "mlx-community/Llama-3.2-3B-Instruct-4bit"
    )
    
    public static let deepseek_r1_distill_qwen_1_5b_4bit = ModelConfiguration(
        id: "mlx-community/DeepSeek-R1-Distill-Qwen-1.5B-4bit"
    )
    
    public static var availableModels: [ModelConfiguration] = [
        llama_3_2_1B_4bit,
        llama_3_2_3b_4bit,
        deepseek_r1_distill_qwen_1_5b_4bit
    ]
    
    public static var defaultModel: ModelConfiguration {
        llama_3_2_1B_4bit
    }
    
    public static func getModelByName(_ name: String) -> ModelConfiguration? {
        if let model = availableModels.first(where: { $0.name == name }) {
            return model
        } else {
            return nil
        }
    }
    
    func getPromptHistory(thread: Thread, systemPrompt: String) -> [[String: String]] {
        var history: [[String: String]] = []

        // DeepSeek R1不需要使用system prompt
        // system prompt
//        history.append([
//            "role": "system",
//            "content": systemPrompt
//        ])
        
        // messages
        for message in thread.sortedMessages {
            var content = message.content
            if message.role == .assistant {
                // remove <think> tag in the assistant role if it exists.
                content = removeThinkTag(content)
            }
            let role = message.role.rawValue
            history.append([
                "role": role,
                "content": content
            ])
        }
        return history
    }

    /// DeepSeek R1 不需要使用 system prompt
    func getPromptHistory(thread: Thread) -> [[String: String]] {
        var history: [[String: String]] = []
        // messages
        for message in thread.sortedMessages {
            var content = message.content
            if message.role == .assistant {
                // remove <think> tag in the assistant role if it exists.
                content = removeThinkTag(content)
            }
            let role = message.role.rawValue
            history.append([
                "role": role,
                "content": content
            ])
        }
        return history
    }

    /// Remove the <think> tag and its contents.
    private func removeThinkTag(_ content: String) -> String{
        if content.contains("<think>") {
            let pattern = "<think>.*?</think>"
            if let regex = try? NSRegularExpression(pattern: pattern, options: .dotMatchesLineSeparators) {
                let range = NSRange(location: 0, length: content.utf16.count)
                let reusult = regex.stringByReplacingMatches(in: content, options: [], range: range, withTemplate: "")
                return reusult.trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return content
    }

    /// Returns the model's approximate size, in GB.
    public var modelSize: Decimal? {
        switch self {
        case .llama_3_2_1B_4bit: return 0.7
        case .llama_3_2_3b_4bit: return 1.8
        case .deepseek_r1_distill_qwen_1_5b_4bit: return 1.0
        default: return nil
        }
    }
}
