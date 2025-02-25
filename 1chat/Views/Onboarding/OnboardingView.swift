//
//  OnboardingView.swift
//  1chat
//
//  Created by OJZen on 2025/2/10.
//

import SwiftUI

struct OnboardingView: View {
    @Binding var showOnboarding: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                VStack(spacing: 12) {
                    Image("icon")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .shadow(radius: 2)
                        .frame(width: 100, height: 100)

                    VStack(spacing: 4) {
                        Text("1chat")
                            .font(.largeTitle)
                            .bold()
                        Text("chat with private and local large language models")
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }
                }
                
                Spacer()
                                
                VStack(alignment: .leading, spacing: 24) {

                    HStack {
                        Image(systemName: "bolt")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.accentColor)
                            .padding(.trailing, 8)

                        VStack(alignment: .leading) {
                            Text("Fast")
                                .font(.headline)
                            Text("Optimized for apple silicon")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack {
                        Image(systemName: "checkmark.shield")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 30, height: 30)
                            .foregroundStyle(Color.accentColor)
                            .padding(.trailing, 8)

                        VStack(alignment: .leading) {
                            Text("Private")
                                .font(.headline)
                            Text("Runs locally on your device")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }

                    HStack {
                        Circle()
                            .stroke(Color.blue, lineWidth: 2)
                            .frame(width: 28, height: 28)
                            .overlay {
                                Image("deepseek")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 24, height: 24)
                                    .foregroundStyle(Color.accentColor)
                            }
                            .padding(.trailing, 8)

                        VStack(alignment: .leading) {
                            Text("Powerful")
                                .font(.headline)
                            Text("Driven by the DeepSeek model")
                                .font(.callout)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 24)
                
                Spacer()

                Button {
                    showOnboarding = false
                } label: {
                    Text("get started")
                        #if os(iOS) || os(visionOS)
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .frame(height: 40)
                        #endif
                        #if os(iOS)
                        .foregroundStyle(.background)
                        #endif
                }
                .buttonStyle(.borderedProminent)
                .buttonBorderShape(.capsule)
                .shadow(radius: 4)
                .padding(.horizontal)
            }
            .padding()
            .navigationTitle("welcome")
            .toolbar(.hidden)
        }
        #if os(macOS)
        .frame(width: 420, height: 520)
        #endif
    }
}

#Preview {
    OnboardingView(showOnboarding: .constant(true))
}
