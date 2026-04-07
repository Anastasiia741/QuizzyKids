//  AnimalWorldView.swift
//  Quizzy Kids

import SwiftUI

struct AnimalWorldView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let data: GameSessionData?
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()

            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height

                Image(AnimalWorld.owl.rawValue)
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

                Image(AnimalWorld.panda.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 62)
                    .position(x: w * 0.78, y: h * 0.20)
                    .floating(
                        amplitude: 9,
                        rotation: 1.2,
                        duration: 3.4,
                        delay: 0.35
                    )

                Image(AnimalWorld.penguin.rawValue)
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

                Image(FindOddOne3.i08.rawValue)
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

                Image(AnimalWorld.cow.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 57)
                    .position(x: w * 0.18, y: h * 0.80)
                    .floating(
                        amplitude: 12,
                        rotation: 1.4,
                        duration: 3.9,
                        delay: 0.40
                    )

                Image(AnimalWorld.cat.rawValue)
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
        .safeAreaInset(edge: .bottom) {
            Button {
                coordinator.push(.animalWorld)
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


