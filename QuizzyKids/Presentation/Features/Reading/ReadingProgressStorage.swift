//  ReadingProgressStorage.swift
//  Quizzy Kids

import Foundation

enum ReadingProgressStorage {
    private static let key = "reading.completedBookIDs"

    static func markCompleted(bookID: String) {
        var ids = Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
        guard !ids.contains(bookID) else { return }
        ids.insert(bookID)
        UserDefaults.standard.set(Array(ids), forKey: key)
        NotificationCenter.default.post(name: .readingProgressDidChange, object: nil)
        NotificationCenter.default.post(
            name: .quizzyRewardUnlocked,
            object: nil,
            userInfo: [QuizzyRewardUserInfoKey.countKey: 1]
        )
    }

    static var completedBookIDs: Set<String> {
        Set(UserDefaults.standard.stringArray(forKey: key) ?? [])
    }

    static var completedCount: Int {
        completedBookIDs.count
    }
}

extension Notification.Name {
    static let readingProgressDidChange = Notification.Name("readingProgressDidChange")
}
