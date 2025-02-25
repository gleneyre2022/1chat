//
//  SettingsView.swift
//  1chat
//
//  Created by OJZen on 2025/2/10.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var appManager: AppManager
    @Environment(\.dismiss) var dismiss
    @Environment(LLMEvaluator.self) var llm
    @Binding var currentThread: Thread?

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    NavigationLink(destination: AppearanceSettingsView()) {
                        Label("appearance", systemImage: "paintpalette")
                    }

                    NavigationLink(destination: ChatsSettingsView(currentThread: $currentThread)) {
                        Label("chats", systemImage: "message")
                    }
                }

                Section {
                    NavigationLink(destination: CreditsView()) {
                        Text("credits")
                    }
                }

                Section {} footer: {
                    HStack {
                        Spacer()
                        Image("icon")
                            .resizable()
                            .scaledToFit()
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .frame(width: 40, height: 40)

                        VStack(alignment: .leading) {
                            HStack {
                                Text("1chat")
                                Text(Bundle.main.releaseVersionNumber)
                            }
                            Text("REDNote @稽客君")
                        }
                        .font(.footnote)
                        Spacer()
                    }
                    .padding(.vertical)
                }
            }
            .formStyle(.grouped)
            .navigationTitle("settings")
            #if os(iOS)
                .navigationBarTitleDisplayMode(.inline)
            #endif
                .toolbar {
                    #if os(iOS) || os(visionOS)
                    ToolbarItem(placement: .topBarLeading) {
                        Button(action: { dismiss() }) {
                            Image(systemName: "xmark")
                        }
                    }
                    #elseif os(macOS)
                    ToolbarItem(placement: .destructiveAction) {
                        Button(action: { dismiss() }) {
                            Text("close")
                        }
                    }
                    #endif
                }
        }
        #if !os(visionOS)
        .tint(appManager.appTintColor.getColor())
        #endif
        .environment(\.dynamicTypeSize, appManager.appFontSize.getFontSize())
    }
}

extension Bundle {
    var releaseVersionNumber: String {
        return (infoDictionary?["CFBundleShortVersionString"] as? String) ?? "2025"
    }
}

#Preview {
    SettingsView(currentThread: .constant(nil))
        .environmentObject(AppManager())
        .environment(LLMEvaluator())
}
