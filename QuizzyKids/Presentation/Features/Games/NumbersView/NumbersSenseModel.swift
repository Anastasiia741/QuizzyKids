//  NumbersMatchRow.swift
//  Quizzy Kids

import Foundation

struct NumbersSensesModel: Identifiable, Equatable {
    let id = UUID()
    let image: NumFruits
    let correctValue: Int
}

struct NumbersSensesQuestion: Identifiable, Equatable {
    let id = UUID()
    let rows: [NumbersSensesModel]
}

enum NumbersMatchMockDBData {
    static let items: [NumbersSensesQuestion] = [
        .init(rows: [
            .init(image: .level09, correctValue: 9),
            .init(image: .level04, correctValue: 4),
            .init(image: .level03, correctValue: 3),
            .init(image: .level07, correctValue: 7),
            .init(image: .level01, correctValue: 1),
        ]),
        .init(rows: [
            .init(image: .level06, correctValue: 6),
            .init(image: .level02, correctValue: 2),
            .init(image: .level10, correctValue: 10),
            .init(image: .level05, correctValue: 5),
            .init(image: .level08, correctValue: 8),
        ]),
        .init(rows: [
            .init(image: .level01, correctValue: 1),
            .init(image: .level03, correctValue: 3),
            .init(image: .level04, correctValue: 4),
            .init(image: .level09, correctValue: 9),
            .init(image: .level07, correctValue: 7),
        ]),
        .init(rows: [
            .init(image: .level08, correctValue: 8),
            .init(image: .level06, correctValue: 6),
            .init(image: .level02, correctValue: 2),
            .init(image: .level05, correctValue: 5),
            .init(image: .level10, correctValue: 10),
        ]),
        .init(rows: [
            .init(image: .level07, correctValue: 7),
            .init(image: .level01, correctValue: 1),
            .init(image: .level09, correctValue: 9),
            .init(image: .level04, correctValue: 4),
            .init(image: .level03, correctValue: 3),
        ]),
        .init(rows: [
            .init(image: .level05, correctValue: 5),
            .init(image: .level08, correctValue: 8),
            .init(image: .level06, correctValue: 6),
            .init(image: .level02, correctValue: 2),
            .init(image: .level10, correctValue: 10),
        ]),
        .init(rows: [
            .init(image: .level03, correctValue: 3),
            .init(image: .level07, correctValue: 7),
            .init(image: .level01, correctValue: 1),
            .init(image: .level09, correctValue: 9),
            .init(image: .level04, correctValue: 4),
        ]),
        .init(rows: [
            .init(image: .level10, correctValue: 10),
            .init(image: .level05, correctValue: 5),
            .init(image: .level02, correctValue: 2),
            .init(image: .level08, correctValue: 8),
            .init(image: .level06, correctValue: 6),
        ]),
        .init(rows: [
            .init(image: .level04, correctValue: 4),
            .init(image: .level03, correctValue: 3),
            .init(image: .level07, correctValue: 7),
            .init(image: .level01, correctValue: 1),
            .init(image: .level09, correctValue: 9),
        ]),
        .init(rows: [
            .init(image: .level02, correctValue: 2),
            .init(image: .level06, correctValue: 6),
            .init(image: .level08, correctValue: 8),
            .init(image: .level05, correctValue: 5),
            .init(image: .level10, correctValue: 10),
        ]),
    ]
}
