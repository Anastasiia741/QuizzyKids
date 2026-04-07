//  FindOddOneView.swift
//  Quizzy Kids

import SwiftUI

struct OddOneView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let data: GameSessionData?

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            Image("games_findOddOne_01")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity)
                .frame(height: 300)
                .padding(.horizontal, 63)
        }
        .safeAreaInset(edge: .bottom) {
            Button {
                coordinator.push(.findOddOne)
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
