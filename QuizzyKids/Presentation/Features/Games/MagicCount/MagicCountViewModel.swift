//  MagicCountViewModel.swift
//  Quizzy Kids

import SwiftUI
internal import Combine

@MainActor
final class MagicCountViewModel: ObservableObject {
    @Published private(set) var state: GameState = .playing
    @Published private(set) var roundIndex: Int = 0
    @Published private(set) var attemptsLeft: Int = 3
    @Published private(set) var showWrongText: Bool = false

    @Published private(set) var options: [Int] = []
    @Published private(set) var selected: Int? = nil

    private var rounds: [MagicCountModel] = []
    private let baseRounds: [MagicCountModel]

    let items: [NumbersModel] = NumbersData.items
    
    init(rounds: [MagicCountModel]? = nil) {
        self.baseRounds = rounds ?? MagicCountMockDB.items
        self.rounds = self.baseRounds
        loadRound()
    }

    var total: Int { rounds.count }

    var correctCount: Int {
        currentRound?.count ?? 1
    }

    var imageName: String {
        currentRound?.image.rawValue ?? ""
    }

    private var currentRound: MagicCountModel? {
        guard !rounds.isEmpty else { return nil }
        return rounds[min(roundIndex, rounds.count - 1)]
    }

    func countDigitAsset(for value: Int) -> String {
        items.first(where: { $0.value == value })?.imageDigit.rawValue ?? "\(value)"
    }

    func start() {
        rounds = baseRounds.shuffled()       
        roundIndex = 0
        loadRound()
        state = .playing
    }

    func select(value: Int) {
        guard state == .playing else { return }
        selected = value
        showWrongText = false
    }

    func check() {
        guard state == .playing else { return }
        guard let selected, let round = currentRound else { return }

        if selected == round.count {
            state = .win
            return
        }

        attemptsLeft -= 1
        showWrongText = true

        if attemptsLeft <= 0 {
            state = .lose
        }
    }

    func retrySame() {
        loadRound()
        state = .playing
    }

    func goNext() {
        guard roundIndex + 1 < rounds.count else { return }
        roundIndex += 1
        loadRound()
        state = .playing
    }

    private func loadRound() {
        attemptsLeft = 3
        showWrongText = false
        selected = nil

        let correct = currentRound?.count ?? 1
        options = makeOptions(correct: correct, optionsCount: 4, range: 1...10)
    }

    private func makeOptions(correct: Int, optionsCount: Int, range: ClosedRange<Int>) -> [Int] {
        let maxUnique = (range.upperBound - range.lowerBound + 1)
        let target = min(optionsCount, maxUnique)

        var set: Set<Int> = [correct]
        while set.count < target {
            set.insert(Int.random(in: range))
        }
        return Array(set).shuffled()
    }
}
