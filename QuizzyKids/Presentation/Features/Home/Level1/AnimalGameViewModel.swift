//  AnimalGameViewModel.swift
//  Quizzy Kids

import FirebaseStorage
import SwiftUI
import Kingfisher
internal import Combine


private enum AnimalQuizProgress {
    static let mapUnlockedLevelKey = "nk_unlockedAnimalLevel"
    static let level1FiveMilestoneSeenKey = "animalQuiz.l1.fiveMilestoneAlertSeen"
}

@MainActor
final class AnimalGameViewModel: ObservableObject {
    @Published var allAnimals: [AnimalItem] = []
    @Published var imageURLs: [String: URL] = [:]
    @Published var prompt: AnimalItem? = nil
    @Published var choices: [AnimalItem] = []
    @Published var selectedIndex: Int? = nil

    @Published var attemptsLeft: Int = 3
    @Published var answerState: AnimalAnswerState = .idle
    @Published var timeLeft: Int = 30

    @Published var isLoading = false
    @Published var showLottie = false
    @Published var showLoseAlert = false
    @Published var showLevelUnlocked = false
    @Published var showTwoStarsMilestone = false
    /// Paused after Exit on completion / lose alerts; blocks play until Resume from pause menu.
    @Published private(set) var isGameplayPaused = false

    private let repo: AnimalRepository
    private let storage = Storage.storage()

    private let level: Int
    private var timerTask: Task<Void, Never>?
    private var correctCount = 0
    private var lastLossTrigger: LossTrigger?

    private enum LossTrigger {
        case timerExpired
        case attemptsExhausted
    }

    init(level: Int, repo: AnimalRepository) {
        self.level = level
        self.repo = repo
    }

    convenience init(level: Int) {
        self.init(level: level, repo: FirebaseAnimalRepository())
    }

    func onAppear() {
        Task { await load() }
    }

    private func load() async {
        isLoading = true
        defer { isLoading = false }

        do {
            let loaded = try await repo.fetchAnimals(level: level)
            allAnimals = loaded
            await resolveAllImageURLsAndPrefetch()
            restartLevel()
        } catch {
            print("Load error:", error)
        }
    }

    /// New round; keeps `correctCount` (used after 5th correct → Next).
    func beginNewRoundPreservingScore() {
        guard allAnimals.count >= 12 else { return }

        stopTimer()

        attemptsLeft = 3
        selectedIndex = nil
        answerState = .idle

        let shuffled = allAnimals.shuffled()
        choices = Array(shuffled.prefix(12))
        prompt = choices.randomElement()

        if !isGameplayPaused {
            startTimer(resetDuration: true)
        }
    }

    func selectChoice(at index: Int) {
        guard !isGameplayPaused else { return }
        guard choices.indices.contains(index) else { return }
        selectedIndex = index

        if answerState == .wrong {
            answerState = .idle
        }
    }

    func checkAnswer() async {
        guard !isGameplayPaused else { return }
        guard let prompt, let selectedIndex else { return }

        stopTimer()

        let selected = choices[selectedIndex]
        if selected.id == prompt.id {
            handleCorrect()
        } else {
            handleWrong()
        }
    }

    private func handleCorrect() {
        answerState = .correct
        showLottie = true
        correctCount += 1

        Task {
            await Task.quizSleep(seconds: 0.8)
            showLottie = false

            if correctCount == 10 {
                await SettingsViewModel.shared.adjustBonuses(by: 2)
                showTwoStarsMilestone = true
                return
            }

            if correctCount == 5, shouldShowFiveUnlockAlert() {
                UserDefaults.standard.set(true, forKey: AnimalQuizProgress.level1FiveMilestoneSeenKey)
                showLevelUnlocked = true
                return
            }

            beginNewRoundPreservingScore()
        }
    }

    /// First session to 5: show once. Skip if the next map node is already unlocked (`unlockedLevel >= 2`).
    private func shouldShowFiveUnlockAlert() -> Bool {
        guard level == 1 else { return false }
        if UserDefaults.standard.bool(forKey: AnimalQuizProgress.level1FiveMilestoneSeenKey) { return false }
        let mapUnlocked = UserDefaults.standard.integer(forKey: AnimalQuizProgress.mapUnlockedLevelKey)
        return mapUnlocked < 2
    }

    private func handleWrong() {
        answerState = .wrong
        attemptsLeft -= 1

        if attemptsLeft <= 0 {
            applyRoundFailurePenalty(trigger: .attemptsExhausted)
        } else {
            startTimer(resetDuration: true)
        }
    }

    /// −1 бонус при провале раунда: время вышло или 3 неверные ответа. +2 — только за прохождение (10 верных), см. `handleCorrect`.
    private func applyRoundFailurePenalty(trigger: LossTrigger) {
        lastLossTrigger = trigger
        Task { @MainActor [weak self] in
            guard let self else { return }
            await SettingsViewModel.shared.adjustBonuses(by: -1)
            self.showLoseAlert = true
        }
    }

    func restartLevel() {
        correctCount = 0
        showLoseAlert = false
        showLevelUnlocked = false
        showTwoStarsMilestone = false
        isGameplayPaused = false
        lastLossTrigger = nil
        beginNewRoundPreservingScore()
    }

    func continueAfterFiveUnlock() {
        showLevelUnlocked = false
        beginNewRoundPreservingScore()
    }

    func continueAfterLoss() {
        showLoseAlert = false
        switch lastLossTrigger {
        case .timerExpired:
            answerState = .idle
            selectedIndex = nil
            if !isGameplayPaused {
                startTimer(resetDuration: true)
            }
        case .attemptsExhausted, .none:
            beginNewRoundPreservingScore()
        }
        lastLossTrigger = nil
    }

    func pauseGameplay() {
        stopTimer()
        isGameplayPaused = true
    }

    func resumeGameplayFromPauseMenu() {
        guard isGameplayPaused else { return }
        if correctCount >= 10 {
            correctCount = 0
        }
        isGameplayPaused = false
        beginNewRoundPreservingScore()
    }

    /// Call when opening the pause overlay (header pause).
    func pauseForMenuOverlay() {
        stopTimer()
    }

    /// Resume after closing pause menu with Resume (only if not in gameplay-paused-from-exit state).
    func resumeAfterPauseMenuClosed() {
        guard !isGameplayPaused else { return }
        guard timeLeft > 0 else { return }
        startTimer(resetDuration: false)
    }

    var showLevelWinLottie: Bool { showTwoStarsMilestone }

    var selectedChoiceForCenter: AnimalItem? {
        guard let selectedIndex, choices.indices.contains(selectedIndex) else { return nil }
        return choices[selectedIndex]
    }

    var shouldShowCenterWrongBorder: Bool {
        answerState == .wrong
    }

    private func startTimer(resetDuration: Bool) {
        stopTimer()
        if resetDuration {
            timeLeft = 30
        }
        SecondIntervalLoop.start(&timerTask) { [weak self] in
            guard let self else { return true }
            guard !Task.isCancelled else { return true }
            self.timeLeft -= 1
            if self.timeLeft <= 0 {
                self.timeLeft = 0
                self.applyRoundFailurePenalty(trigger: .timerExpired)
                return true
            }
            return false
        }
    }

    private func stopTimer() {
        SecondIntervalLoop.cancel(&timerTask)
    }
}

// MARK: - Images

extension AnimalGameViewModel {
    private func resolveAllImageURLsAndPrefetch() async {
        guard !allAnimals.isEmpty else { return }
        let storage = storage
        let items = allAnimals

        var merged: [String: URL] = [:]
        merged.reserveCapacity(items.count)
        var prefetchList: [URL] = []
        prefetchList.reserveCapacity(items.count)

        await withTaskGroup(of: (String, URL?).self) { group in
            for item in items {
                group.addTask { [item] in
                    if let cached = await AnimalURLCache.shared.get(forPath: item.image) {
                        return (item.id, cached)
                    }
                    do {
                        let ref = storage.reference(withPath: item.image)
                        let url = try await ref.downloadURL()
                        await AnimalURLCache.shared.set(url, forPath: item.image)
                        return (item.id, url)
                    } catch {
                        return (item.id, nil)
                    }
                }
            }
            for await (id, url) in group {
                if let url {
                    merged[id] = url
                    prefetchList.append(url)
                }
            }
        }

        imageURLs = merged
        if !prefetchList.isEmpty {
            ImagePrefetcher(urls: prefetchList).start()
        }
    }
}
