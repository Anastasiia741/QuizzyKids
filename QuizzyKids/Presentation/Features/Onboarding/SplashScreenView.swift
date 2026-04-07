//  ContentView.swift
//  Quizzy Kids

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        ZStack {
            Color.accent100
                .ignoresSafeArea()

            VStack(alignment: .leading, spacing: 4) {
                Spacer().frame(height: 150)
//                Image("Logo")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(maxWidth: 256)
                Spacer()
            }
            .padding(.horizontal, 32)
            ZStack(alignment: .bottomTrailing) {
                Image("ui_shape_10")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
                    .opacity(0.9)

                Image("ui_shape_01")
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: 260)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity,
                   alignment: .bottomTrailing)
            .padding(.bottom, 25)
        }
    }
}

struct SplashScreenView_Previews: PreviewProvider {
    static var previews: some View {
        SplashScreenView()
    }
}

