//  PushNotificationTexts.swift
//  Quizzy Kids

import Foundation

enum QuizzyRewardUserInfoKey {
    static let countKey = "count"
}

extension Notification.Name {
    static let quizzyRewardUnlocked = Notification.Name("quizzyRewardUnlocked")
}

enum PushNotificationTexts {
    static let reengageBodies: [String] = [
        "We miss you! Let's play together 😊",
        "Your game is waiting for you! New tasks are ready!",
        "Come back – there's a surprise waiting for you 🎁",
    ]

    static let rewardBodies: [String] = [
        "You've earned a new star ⭐",
        "Great job! Collect your reward 🎉",
        "You've gotten even better! Check out your achievements",
    ]

    static func streakBodies(streakDays: Int) -> [String] {
        [
            "Your streak: \(streakDays) days in a row! Don't miss out today 🔥",
            "Come in today and continue your streak!",
            "You're already on your way to a super reward 🚀",
        ]
    }

    static func mergedRewardsBody(count: Int) -> String {
        "You got \(count) rewards! 🎉"
    }
}
