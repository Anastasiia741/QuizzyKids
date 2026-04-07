//  NumberKnowledge.swift
//  Quizzy Kids

import SwiftUI
import CoreGraphics

struct NumberKnowledgeMap {
    struct LevelNode: Identifiable {
        let id: Int
        let asset: Numbers
        let pos: CGPoint
    }

    enum PathID: Int, CaseIterable {
        case p1 = 1, p2, p3, p4
    }

    static let levels: [LevelNode] = [
        .init(id: 1, asset: .level02, pos: CGPoint(x: 0.92, y: 0.79)),
        .init(id: 2, asset: .level03, pos: CGPoint(x: 0.08, y: 0.56)),
        .init(id: 3, asset: .level04, pos: CGPoint(x: 0.92, y: 0.30)),
        .init(id: 4, asset: .level05, pos: CGPoint(x: 0.08, y: 0.08)),
    ]

    static let path1: [CGPoint] = [
        CGPoint(x: 0.16, y: 0.932),
        CGPoint(x: 0.30, y: 0.932),
        CGPoint(x: 0.44, y: 0.932),
        CGPoint(x: 0.58, y: 0.932),
        CGPoint(x: 0.67, y: 0.932),
        CGPoint(x: 0.71, y: 0.928),
        CGPoint(x: 0.74, y: 0.922),
        CGPoint(x: 0.77, y: 0.912),
        CGPoint(x: 0.80, y: 0.898),
        CGPoint(x: 0.83, y: 0.882),
        CGPoint(x: 0.85, y: 0.862),
        CGPoint(x: 0.87, y: 0.842),
        CGPoint(x: 0.89, y: 0.822),
        CGPoint(x: 0.905, y: 0.805),
        CGPoint(x: 0.92, y: 0.79),
    ]

    static let path2: [CGPoint] = [
        CGPoint(x: 0.92, y: 0.79),
        CGPoint(x: 0.91, y: 0.765),
        CGPoint(x: 0.895, y: 0.73),
        CGPoint(x: 0.87, y: 0.695),
        CGPoint(x: 0.83, y: 0.655),
        CGPoint(x: 0.70, y: 0.628),
        CGPoint(x: 0.62, y: 0.632),
        CGPoint(x: 0.54, y: 0.632),
        CGPoint(x: 0.46, y: 0.632),
        CGPoint(x: 0.38, y: 0.632),
        CGPoint(x: 0.30, y: 0.632),
        CGPoint(x: 0.22, y: 0.632),
        CGPoint(x: 0.16, y: 0.630),
        CGPoint(x: 0.13, y: 0.624),
        CGPoint(x: 0.11, y: 0.606),
        CGPoint(x: 0.09, y: 0.582),
        CGPoint(x: 0.08, y: 0.56),
    ]

    static let path3: [CGPoint] = [
        CGPoint(x: 0.09, y: 0.545),
        CGPoint(x: 0.11, y: 0.525),
        CGPoint(x: 0.14, y: 0.500),
        CGPoint(x: 0.18, y: 0.478),
        CGPoint(x: 0.23, y: 0.465),
        CGPoint(x: 0.30, y: 0.458),
        CGPoint(x: 0.38, y: 0.456),
        CGPoint(x: 0.46, y: 0.456),
        CGPoint(x: 0.54, y: 0.456),
        CGPoint(x: 0.62, y: 0.456),
        CGPoint(x: 0.70, y: 0.456),
        CGPoint(x: 0.76, y: 0.452),
        CGPoint(x: 0.81, y: 0.442),
        CGPoint(x: 0.85, y: 0.425),
        CGPoint(x: 0.88, y: 0.402),
        CGPoint(x: 0.90, y: 0.370),
        CGPoint(x: 0.915, y: 0.335),
        CGPoint(x: 0.92, y: 0.30),
    ]

    static let path4: [CGPoint] = [
        CGPoint(x: 0.92, y: 0.30),
        CGPoint(x: 0.91, y: 0.275),
        CGPoint(x: 0.895, y: 0.250),
        CGPoint(x: 0.870, y: 0.225),
        CGPoint(x: 0.835, y: 0.205),
        CGPoint(x: 0.790, y: 0.195),
        CGPoint(x: 0.740, y: 0.192),
        CGPoint(x: 0.66, y: 0.192),
        CGPoint(x: 0.58, y: 0.192),
        CGPoint(x: 0.50, y: 0.192),
        CGPoint(x: 0.42, y: 0.192),
        CGPoint(x: 0.34, y: 0.192),
        CGPoint(x: 0.26, y: 0.192),
        CGPoint(x: 0.18, y: 0.192),
        CGPoint(x: 0.14, y: 0.192),
        CGPoint(x: 0.12, y: 0.176),
        CGPoint(x: 0.10, y: 0.152),
        CGPoint(x: 0.09, y: 0.125),
        CGPoint(x: 0.085, y: 0.100),
        CGPoint(x: 0.08, y: 0.08),
    ]

    static func path(_ id: PathID) -> [CGPoint] {
        switch id {
        case .p1: return path1
        case .p2: return path2
        case .p3: return path3
        case .p4: return path4
        }
    }
}

struct NumbersModel: Identifiable {
    let id = UUID()
    let value: Int
    let word: String
    let imageDigit: NumPlay
    let imageFruits: NumFruits
}

enum NumbersData {

    static let items: [NumbersModel] = (1...10).compactMap { n in
        guard
            let digit = Game.NumPlay(
                rawValue: String(format: "games_numbers_numPlay_%02d", n)
            ),
            let fruits = Game.NumFruits(
                rawValue: String(format: "games_numbers_numFruits_%02d", n)
            )
        else { return nil }

        return NumbersModel(
            value: n,
            word: word(for: n),
            imageDigit: digit,
            imageFruits: fruits
        )
    }

    private static func word(for n: Int) -> String {
        switch n {
        case 1: return "One"
        case 2: return "Two"
        case 3: return "Three"
        case 4: return "Four"
        case 5: return "Five"
        case 6: return "Six"
        case 7: return "Seven"
        case 8: return "Eight"
        case 9: return "Nine"
        case 10: return "Ten"
        default: return "\(n)"
        }
    }
}


