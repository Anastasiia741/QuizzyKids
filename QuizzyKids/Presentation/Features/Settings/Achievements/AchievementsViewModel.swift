//  AchievementsViewModel.swift
//  Quizzy Kids

internal import Combine
import FirebaseAuth
import Foundation

@MainActor
final class AchievementsViewModel: ObservableObject {
    private let settings: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()

    static let storyReaderMaxBooks = 6

    let streakMilestones = [1, 3, 7, 12]

    @Published private(set) var booksReadCount = 0
    @Published private(set) var streakDays = 0

    init(settings: SettingsViewModel) {
        self.settings = settings
        settings.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        NotificationCenter.default.publisher(for: .readingProgressDidChange)
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.refreshReadingProgressOnly()
            }
            .store(in: &cancellables)
    }

    @MainActor
    convenience init() {
        self.init(settings: .shared)
    }

    var bonuses: Int {
        settings.profile?.bonuses ?? 0
    }

    var canOpenMoreGames: Bool {
        bonuses >= 150
    }

    var storyReaderFilledCount: Int {
        min(booksReadCount, Self.storyReaderMaxBooks)
    }

    var storyReaderSubtitle: String {
        let total = Self.storyReaderMaxBooks
        let read = min(booksReadCount, total)
        if read >= total {
            return "All \(total) books read!"
        }
        if read == 0 {
            return "Read up to \(total) books to fill the row"
        }
        let left = total - read
        let bookWord = left == 1 ? "book" : "books"
        return "\(read)/\(total) done — \(left) more \(bookWord)"
    }

    var streakSubtitle: String {
        if let next = streakMilestones.first(where: { $0 > streakDays }) {
            let need = next - streakDays
            if need <= 0 {
                return "\(streakDays) day streak"
            }
            let dayWord = need == 1 ? "day" : "days"
            return "Play \(need) more \(dayWord) for the next streak goal"
        }
        return "\(streakDays) day streak — you reached every goal here!"
    }

    func milestoneReached(_ day: Int) -> Bool {
        streakDays >= day
    }

    func loadRemoteProfile(user: User?) async {
        await settings.loadProfileIfNeeded(user: user)
    }

    func refreshLocalStats() {
        AppVisitStreak.registerVisitIfNeeded()
        booksReadCount = ReadingProgressStorage.completedCount
        streakDays = AppVisitStreak.consecutiveDays
    }

    private func refreshReadingProgressOnly() {
        booksReadCount = ReadingProgressStorage.completedCount
    }
}

