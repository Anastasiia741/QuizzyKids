//  AppVisitStreak.swift
//  Quizzy Kids

import Foundation

enum AppVisitStreak {
    private static let lastVisitKey = "appVisit.lastVisitStartOfDay"
    private static let streakKey = "appVisit.consecutiveStreak"

    static func registerVisitIfNeeded() {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let defaults = UserDefaults.standard

        if defaults.object(forKey: lastVisitKey) == nil {
            defaults.set(today.timeIntervalSince1970, forKey: lastVisitKey)
            defaults.set(1, forKey: streakKey)
            return
        }

        let lastTs = defaults.double(forKey: lastVisitKey)
        let lastStart = cal.startOfDay(for: Date(timeIntervalSince1970: lastTs))
        if lastStart == today { return }

        if let yesterday = cal.date(byAdding: .day, value: -1, to: today),
           cal.isDate(lastStart, inSameDayAs: yesterday) {
            let s = defaults.integer(forKey: streakKey)
            defaults.set(max(1, s) + 1, forKey: streakKey)
        } else {
            defaults.set(1, forKey: streakKey)
        }
        defaults.set(today.timeIntervalSince1970, forKey: lastVisitKey)
    }

    static var consecutiveDays: Int {
        max(0, UserDefaults.standard.integer(forKey: streakKey))
    }

    static func hasVisitedToday() -> Bool {
        let defaults = UserDefaults.standard
        guard let ts = defaults.object(forKey: lastVisitKey) as? TimeInterval else { return false }
        let lastStart = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: ts))
        return Calendar.current.isDateInToday(lastStart)
    }
}
