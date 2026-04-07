//  BiggestOneViewModel 2.swift
//  Quizzy Kids

import Foundation
internal import Combine

@MainActor
final class BiggestOneViewModel: ObservableObject {
    @Published private(set) var state: GameState = .playing
    @Published private(set) var roundIndex: Int = 0
    @Published private(set) var attemptsLeft: Int = 3
    @Published private(set) var currentRound: BiggestOneModel
    @Published private(set) var wrongID: UUID? = nil
    @Published private(set) var isLocked: Bool = false

    private let rounds: [BiggestOneModel]

    init(rounds: [BiggestOneModel]? = nil) {
        self.rounds = rounds ?? BiggestOneMockDB.rounds
        self.currentRound = self.rounds.first ?? BiggestOneModel(image: "", scales: [1,1,1,1], biggestIndex: 0)
        resetRound()
    }

    var total: Int { rounds.count }

    func start() {
        roundIndex = 0
        loadRound()
    }

    func select(index: Int) {
        guard state == .playing, !isLocked else { return }
        guard index >= 0, index < 4 else { return }

        if index == currentRound.biggestIndex {
            isLocked = true
            state = .win
            return
        }

        attemptsLeft -= 1
        wrongID = UUID()
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 250_000_000)
            self.wrongID = nil
        }

        if attemptsLeft <= 0 {
            isLocked = true
            state = .lose
        }
    }

    func retrySame() {
        resetRound()
        state = .playing
    }

    func goNext() {
        guard roundIndex + 1 < rounds.count else { return }
        roundIndex += 1
        loadRound()
    }

    private func loadRound() {
        currentRound = rounds[min(roundIndex, rounds.count - 1)]
        resetRound()
        state = .playing
    }

    private func resetRound() {
        attemptsLeft = 3
        wrongID = nil
        isLocked = false
    }
}
