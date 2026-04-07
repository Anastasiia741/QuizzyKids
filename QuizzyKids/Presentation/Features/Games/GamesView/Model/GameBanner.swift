//  GameBanner.swift
//  Quizzy Kids

import Foundation

struct GameBanner: Identifiable, Hashable {
    let id: String
    let image: GamesImages
    let type: GameType
}


enum GameMockDB {
    static let items: [GameBanner] = [
        .init(id: "picture", image: .game01, type: .picturePuzzle),
        .init(id: "alphabet", image: .game02, type: .alphabet),
        .init(id: "diff", image: .game03, type: .findDifferences),
        .init(id: "odd", image: .game04, type: .oddOne),
        .init(id: "animalWord", image: .game05, type: .animalWord),
        .init(id: "numberKnowledge", image: .game06, type: .numberKnowledge),
        .init(id: "bigestOne", image: .game07, type: .biggestOne),
        .init(id: "magicCount", image: .game08, type: .magicCount),
    ]
}
