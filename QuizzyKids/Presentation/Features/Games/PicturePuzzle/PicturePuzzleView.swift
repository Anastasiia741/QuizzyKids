//  PicturePuzzleView.swift
//  Quizzy Kids

import SwiftUI

struct PicturePuzzleView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let data: GameSessionData?

    @StateObject private var vm = PicturePuzzleViewModel()

    private let images = ["games_puzzle_01", "games_puzzle_02", "games_puzzle_03", "games_puzzle_04"]
    private let pieceOptions = [4, 6, 9]

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 16) {
                    ForEach(PuzzleMockDB.puzzleCards) { item in
                        QuizCardView(
                            backgroundImage: item.backgroundImage.rawValue,
                            buttonType: item.buttonType,
                            buttonText: "Start now",
                            alignment: item.alignment,
                            route: nil,
                            onTap: {
                                coordinator.push(
                                    .picturePuzzlePlaying(
                                        title: item.title ?? "",
                                        imageName: item.image.rawValue,
                                        pieces: item.pieces
                                    )
                                )
                            },
                            cardImage: item.image.rawValue
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 12)
                .padding(.bottom, 24)
            }
        }
    }
}
