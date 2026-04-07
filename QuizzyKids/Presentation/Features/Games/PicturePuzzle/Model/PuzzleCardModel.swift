//  PuzzleCardItem.swift

import Foundation

struct PuzzleCardModel: Identifiable {
    let id = UUID()
    let pieces: Int
    let title: String?
    let image: Puzzle
    let backgroundImage: Banner
    let buttonType: AppButtonStyleType
    let alignment: QuizCardAlignment
    let imageSide: QuizCardAlignment
}

enum PuzzleMockDB {
    static var puzzleCards: [PuzzleCardModel] {
        [
            .init(
                pieces: 4,
                title: "4x4 Puzzle",
                image: .level01,
                backgroundImage: .banner09,
                buttonType: .primary,
                alignment: .left,
                imageSide: .left
            ),
            .init(
                pieces: 6,
                title: "6x6 Puzzle",
                image: .level02,
                backgroundImage: .banner10,
                buttonType: .secondary,
                alignment: .right,
                imageSide: .left
            ),
            .init(
                pieces: 9,
                title: "9x9 Puzzle",
                image: .level03,
                backgroundImage: .banner11,
                buttonType: .primary,
                alignment: .right,
                imageSide: .left
            ),
            .init(
                pieces: 12,
                title: "12x12 Puzzle",
                image: .level04,
                backgroundImage: .banner12,
                buttonType: .secondary,
                alignment: .left,
                imageSide: .right
            ),
        ]
    }
}
