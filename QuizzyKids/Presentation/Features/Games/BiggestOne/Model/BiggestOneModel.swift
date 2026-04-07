//  BiggestOne.swift
//  Quizzy Kids

import SwiftUI

struct BiggestOneModel: Identifiable, Equatable {
    let id = UUID()
    let image: String
    var scales: [CGFloat] = Array(repeating: 1.0, count: 4)
    let biggestIndex: Int
}

enum BiggestOneMockDB {
    static var items: [String] {
        FindOddOne1.allCases.map(\.rawValue)
        + FindOddOne3.allCases.map(\.rawValue)
        + FindOddOne4.allCases.map(\.rawValue)
        + FindOddOne5.allCases.map(\.rawValue)
        + NumFruits.allCases.map(\.rawValue)
    }

    static let rounds: [BiggestOneModel] = (0..<10).map { _ in
        let image = items.randomElement() ?? "animal_world_01"

        let biggestIndex = Int.random(in: 0..<4)

        var scales: [CGFloat] = Array(repeating: 1.0, count: 4)
        scales[biggestIndex] = 1.25

        return BiggestOneModel(
            image: image,
            scales: scales,
            biggestIndex: biggestIndex
        )
    }
}
