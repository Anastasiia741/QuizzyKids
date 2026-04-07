//  PauseAlert.swift
//  Quizzy Kids

import SwiftUI

struct PauseAlert: View {
    enum Action {
        case resume, restart, home, level, exit
    }
    
    let onTap: (Action) -> Void
    
    var body: some View {
        ZStack {
            Image(Background.bg13.rawValue)
                .resizable()
                .scaledToFit()
                .clipped()
            
            VStack(spacing: 12) {
                pauseButton("Resume") { onTap(.resume) }
                pauseButton("Restart") { onTap(.restart) }
                pauseButton("Home") { onTap(.home) }
                pauseButton("Level") { onTap(.level) }
                pauseButton("Exit") { onTap(.exit) }
            }
            .padding(.top, 32)
            .padding(.bottom, 12)
            .padding(.horizontal, UIDevice.current.userInterfaceIdiom == .pad ? 88 : 58)
        }
    }
    
    private func pauseButton(_ title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .frame(maxWidth: .infinity)
        }
        .buttonStyle(
            AppButtonStyle(
                type: .primary,
                customPressedBackgroundColor: Color.primary100.opacity(0.85)
            )
        )
    }
}
