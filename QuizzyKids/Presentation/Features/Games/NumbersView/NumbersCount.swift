//  NumbersCountTask.swift
//  Quizzy Kids

import Foundation

struct RoundState {
   var options: [Int] = []
   var selected: Int? = nil
   var attemptsLeft: Int = 3
   var showWrongText: Bool = false
}

struct NumbersCount: Identifiable, Equatable {
    let id = UUID()
    let image: NumFruits
    let count: Int
}

enum NumbersCountData {
    static let tasks: [NumbersCount] = [
        .init(image: .level01, count: 1),
        .init(image: .level02, count: 2),
        .init(image: .level03, count: 3),
        .init(image: .level04, count: 4),
        .init(image: .level05, count: 5),
        .init(image: .level06, count: 6),
        .init(image: .level07, count: 7),
        .init(image: .level08, count: 8),
        .init(image: .level09, count: 9),
        .init(image: .level10, count: 10),
    ]
}
