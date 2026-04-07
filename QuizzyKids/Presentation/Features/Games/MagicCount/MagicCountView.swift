//  MagicCountView.swift
//  Quizzy Kids

import SwiftUI

struct MagicCountView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let data: GameSessionData?

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            Image("ui_banners_14")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 20)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                coordinator.push(.magicCount)
            } label: {
                Text("Start now")
                    .font(AppFont.caption2())
                    .foregroundColor(.black)
            }
            .buttonStyle(AppButtonStyle(type: .primary))
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

