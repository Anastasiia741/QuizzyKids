//  PieceEdges.swift
//  Quizzy Kids

import Foundation

struct SeededGenerator: RandomNumberGenerator {
    private var state: UInt64
    init(seed: UInt64) { self.state = seed == 0 ? 0x123_4567_89AB_CDEF : seed }
    mutating func next() -> UInt64 {
        state &*= 6_364_136_223_846_793_005
        state &+= 1_442_695_040_888_963_407
        return state
    }
}

public enum PuzzleEdge: Equatable, Sendable {
    case flat, out, `in`

    public var opposite: PuzzleEdge {
        switch self {
        case .flat: return .flat
        case .out: return .in
        case .in: return .out
        }
    }
}

public struct PieceEdges: Equatable, Sendable {
    public let top: PuzzleEdge
    public let right: PuzzleEdge
    public let bottom: PuzzleEdge
    public let left: PuzzleEdge

}
