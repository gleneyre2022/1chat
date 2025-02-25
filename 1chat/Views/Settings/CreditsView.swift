//
//  CreditsView.swift
//  1chat
//
//  Created by OJZen on 2025/2/10.
//

import SwiftUI

struct CreditsView: View {
    var body: some View {
        Form {
            Section {
                Link("MLX Swift", destination: URL(string: "https://github.com/ml-explore/mlx-swift")!)
                    .badge(Text(Image(systemName: "arrow.up.right")))
                Link("Fullmoon", destination: URL(string: "https://github.com/mainframecomputer/fullmoon-ios")!)
                    .badge(Text(Image(systemName: "arrow.up.right")))
                Link("DeepSeek R1", destination: URL(string: "https://github.com/deepseek-ai/DeepSeek-R1")!)
                    .badge(Text(Image(systemName: "arrow.up.right")))
            }
        }
        .formStyle(.grouped)
        .navigationTitle("credits")
        #if os(iOS)
        .navigationBarTitleDisplayMode(.inline)
        #endif
    }
}

#Preview {
    CreditsView()
}
