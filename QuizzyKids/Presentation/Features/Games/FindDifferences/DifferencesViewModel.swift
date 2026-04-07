//  SpotDiffViewModel.swift
//  Quizzy Kids

internal import Combine
import Foundation

@MainActor
final class DifferencesViewModel: ObservableObject {

    enum State: Equatable {
        case playing
        case win
        case lose
    }

    @Published private(set) var found: Set<String> = []
    @Published private(set) var timeLeft: Int
    @Published private(set) var isPaused: Bool = true
    @Published private(set) var state: State = .playing

    let levelID: String
    let topImage: String
    let bottomImage: String
    let differences: [DiffPoint]

    private let seconds: Int
    private nonisolated(unsafe) var timerTask: Task<Void, Never>?

    init(levelID: String, seconds: Int = 60) {
        self.levelID = levelID
        self.seconds = seconds
        self.timeLeft = seconds

        self.topImage = FindDifferencesMockDB.topImage(for: levelID)
        self.bottomImage = FindDifferencesMockDB.bottomImage(for: levelID)
        self.differences = FindDifferencesMockDB.points(for: levelID)
    }

    var total: Int { differences.count }
    var foundCount: Int { found.count }
    var isCompleted: Bool { total > 0 && foundCount == total }
    var isTimeUp: Bool { timeLeft == 0 }

    func start() {
        state = .playing
        if timerTask == nil { startTimerLoop() }
        isPaused = false
    }

    func pauseTimer() {
        isPaused = true
    }

    func resumeTimer() {
        guard state == .playing, !isTimeUp, !isCompleted else { return }
        if timerTask == nil { startTimerLoop() }
        isPaused = false
    }

    func stop() {
        isPaused = true
        SecondIntervalLoop.cancel(&timerTask)
    }

    func retrySame() {
        stop()
        found.removeAll()
        timeLeft = seconds
        state = .playing
        start()
    }

    func continueAfterLose(extraSeconds: Int = 15) {
        guard state == .lose else { return }
        stop()
        timeLeft = max(extraSeconds, 1)
        state = .playing
        start()
    }

    func handleTap(normalized: CGPoint) {
        guard state == .playing, !isPaused, !isTimeUp, !isCompleted else {
            return
        }

        if let hit = differences.first(where: { d in
            let dx = normalized.x - d.x
            let dy = normalized.y - d.y
            return (dx * dx + dy * dy) <= (d.radius * d.radius)
        }) {
            let before = found.count
            found.insert(hit.id)

            if before != found.count, isCompleted {
                state = .win
                pauseTimer()
            }
        }
    }

    private func startTimerLoop() {
        SecondIntervalLoop.start(&timerTask) { [weak self] in
            guard let self else { return true }
            if self.isPaused { return false }
            if self.state != .playing { return true }

            if self.timeLeft > 0 {
                self.timeLeft -= 1
            }

            if self.timeLeft == 0 {
                self.state = .lose
                self.pauseTimer()
                return true
            }
            return false
        }
    }

    deinit { timerTask?.cancel() }
}
