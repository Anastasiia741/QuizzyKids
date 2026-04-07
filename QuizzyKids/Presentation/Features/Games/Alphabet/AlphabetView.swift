//  AlphabetView.swift
//  Quizzy Kids

import SwiftUI

struct AlphabetView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let data: GameSessionData?

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                Image(AnimationAlphabet.a03.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 135)
                    .position(x: w * 0.22, y: h * 0.18)
                    .floating(
                        amplitude: 10,
                        rotation: 1.0,
                        duration: 3.1,
                        delay: 0.10
                    )

                Image(AnimationAlphabet.a02.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26)
                    .position(x: w * 0.78, y: h * 0.20)
                    .floating(
                        amplitude: 9,
                        rotation: 1.2,
                        duration: 3.4,
                        delay: 0.35
                    )

                Image(AnimationAlphabet.a04.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 25)
                    .position(x: w * 0.50, y: h * 0.32)
                    .floating(
                        amplitude: 12,
                        rotation: 1.1,
                        duration: 3.8,
                        delay: 0.22
                    )

                Image(AnimationAlphabet.a05.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 37)
                    .position(x: w * 0.18, y: h * 0.44)
                    .floating(
                        amplitude: 8,
                        rotation: 1.0,
                        duration: 3.0,
                        delay: 0.48
                    )

                Image(AnimationAlphabet.a01.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 118)
                    .position(x: w * 0.78, y: h * 0.46)
                    .floating(
                        amplitude: 11,
                        rotation: 1.3,
                        duration: 3.6,
                        delay: 0.18
                    )

                Image(AnimationAlphabet.a06.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 101)
                    .position(x: w * 0.34, y: h * 0.62)
                    .floating(
                        amplitude: 9,
                        rotation: 1.2,
                        duration: 3.2,
                        delay: 0.55
                    )

                Image(AnimationAlphabet.a07.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .position(x: w * 0.64, y: h * 0.62)
                    .floating(
                        amplitude: 10,
                        rotation: 1.1,
                        duration: 3.7,
                        delay: 0.28
                    )

                Image(AnimationAlphabet.a08.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 37)
                    .position(x: w * 0.28, y: h * 0.80)
                    .floating(
                        amplitude: 12,
                        rotation: 1.4,
                        duration: 3.9,
                        delay: 0.40
                    )

                Image(AnimationAlphabet.a09.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 125)
                    .position(x: w * 0.74, y: h * 0.80)
                    .floating(
                        amplitude: 9,
                        rotation: 1.0,
                        duration: 3.3,
                        delay: 0.12
                    )
                
             
            }
        }
        .safeAreaInset(edge: .top) {
                 Text("Not Like the Others")
                     .font(AppFont.marker(32))
                     .foregroundStyle(.grayscale400)
                     .frame(maxWidth: .infinity, alignment: .center)
                     .padding(.top, 8)
                     .padding(.bottom, 6)
             }
        
        .safeAreaInset(edge: .bottom) {
            Button {
                coordinator.push(.alphabetLetters)
            } label: {
                Text("Start now")
                    .font(AppFont.caption2())
                    .foregroundColor(.grayscale400)
            }
            .buttonStyle(AppButtonStyle(type: .primary))
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}

