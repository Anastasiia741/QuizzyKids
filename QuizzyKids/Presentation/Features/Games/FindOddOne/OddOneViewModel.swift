//  FindOddOneViewModel.swift
//  Quizzy Kids

import SwiftUI
internal import Combine

@MainActor
final class OddOneViewModel: ObservableObject {
    @Published private(set) var model = FindOddOneModel()
    @Published private(set) var state: GameState = .idle
    @Published private(set) var timeLeft: Int

    let questions: [FindOddOneQuestion]
    private let seconds: Int
    private var timerTask: Task<Void, Never>?

    init(questions: [FindOddOneQuestion], seconds: Int = 60) {
        self.questions = questions
        self.seconds = seconds
        self.timeLeft = seconds
        assert(questions.allSatisfy { q in q.items.contains(where: { $0.id == q.correctItemID }) })
    }

    convenience init(seconds: Int = 60) {
        self.init(questions: FindOddOneMockDB.items, seconds: seconds)
    }

    var currentQuestion: FindOddOneQuestion {
        questions[min(model.currentIndex, questions.count - 1)]
    }

    var progressText: String {
        "\(min(model.currentIndex + 1, questions.count))/\(questions.count)"
    }

    func start() {
        resetRound(keepIndex: true)
        state = .playing
        startTimer()
    }

    func stop() {
        stopTimer()
        state = .idle
    }

    func pauseTimer() {
        stopTimer()
    }

    func resumeTimer() {
        guard state == .playing else { return }
        startTimer()
    }

    func select(_ item: FindOddOneItem) {
        guard state == .playing, !model.isLocked else { return }

        model.selectedID = item.id
        let isRight = (item.id == currentQuestion.correctItemID)

        if isRight {
            model.isCorrect = true
            model.isLocked = true
            model.wrongID = nil
            UINotificationFeedbackGenerator().notificationOccurred(.success)

            pauseTimer()
            state = .win
        } else {
            model.isCorrect = false
            model.wrongID = item.id
            UINotificationFeedbackGenerator().notificationOccurred(.error)

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) { [weak self] in
                self?.model.wrongID = nil
            }
        }
    }

    func retrySame() {
        resetRound(keepIndex: true)
        state = .playing
        startTimer()
    }

    func goNext() {
        stopTimer()

        if model.currentIndex < questions.count - 1 {
            model.currentIndex += 1
            resetRound(keepIndex: true)
            state = .playing
            startTimer()
        } else {
            state = .win
        }
    }

    func continueAfterLose(extraSeconds: Int) {
        guard state == .lose else { return }
        timeLeft = max(1, extraSeconds)
        model.isLocked = false
        state = .playing
        startTimer()
    }


    private func resetRound(keepIndex: Bool) {
        let idx = model.currentIndex
        model = FindOddOneModel()
        if keepIndex { model.currentIndex = idx }
        timeLeft = seconds
    }

    private func startTimer() {
        stopTimer()
        SecondIntervalLoop.start(&timerTask) { [weak self] in
            guard let self else { return true }
            guard self.state == .playing else { return true }
            self.timeLeft -= 1
            if self.timeLeft <= 0 {
                self.timeLeft = 0
                self.model.isLocked = true
                self.state = .lose
                return true
            }
            return false
        }
    }

    private func stopTimer() {
        SecondIntervalLoop.cancel(&timerTask)
    }
}
