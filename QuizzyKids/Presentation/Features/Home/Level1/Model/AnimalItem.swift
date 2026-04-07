//  AnimalItem.swift
//  Quizzy Kids

import Foundation

enum AnimalAnswerState: Equatable {
    case idle
    case correct
    case wrong
}

struct AnimalItem: Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let image: String
}

struct LevelConfig {
    let level: Int
    let roundsToWin: Int = 5
    let timeLimit: Int = 30
    let attempts: Int = 3
}


