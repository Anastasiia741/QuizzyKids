//  AnimalWorldViewModel.swift
//  Quizzy Kids

import UIKit
internal import Combine

@MainActor
final class AnimalWorldViewModel: ObservableObject {

    private let items: [AnimalWorldModel] = AnimalWorldMockDB.items
    private let maxAttempts = 3

    @Published private(set) var index: Int = 0
    @Published private(set) var state: GameState = .idle
    @Published var question = AnimalWorldQuestion()

    var total: Int { items.count }

    var current: AnimalWorldModel? {
        items.isEmpty ? nil : items[min(index, items.count - 1)]
    }

    func start() {
        index = 0
        state = .playing
        startRound()
    }

    func startRound() {
        question = AnimalWorldQuestion()
        question.attemptsLeft = maxAttempts
        question.items = makeShownItems()
    }

    func select(_ item: AnimalWorldItem) {
        guard state == .playing, !question.isLocked, let current else { return }

        question.selectedID = item.id

        if item.image == current.oddOne {
            question.isLocked = true
            question.showWrongText = false
            question.wrongID = nil
            return
        }

        question.attemptsLeft -= 1
        question.showWrongText = true
        question.wrongID = item.id

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
            self?.question.wrongID = nil
        }

        if question.attemptsLeft <= 0 {
            question.isLocked = true
            state = .lose
        }
    }

    func goNext() {
        guard state == .playing else { return }

        if index + 1 < items.count {
            index += 1
            startRound()
        } else {
            state = .win
        }
    }

    func retrySame() {
        state = .playing
        startRound()
    }

    private func makeShownItems() -> [AnimalWorldItem] {
        guard let current else { return [] }

        var images = current.images
        if !images.contains(current.oddOne) { images.append(current.oddOne) }

        let desired = 4
        let filler = images.first(where: { $0 != current.oddOne }) ?? current.oddOne

        if images.count < desired {
            images.append(contentsOf: repeatElement(filler, count: desired - images.count))
        } else if images.count > desired {
            images = Array(images.filter { $0 != current.oddOne }.prefix(desired - 1)) + [current.oddOne]
        }

        return images.shuffled().map { AnimalWorldItem(image: $0) }
    }
}
