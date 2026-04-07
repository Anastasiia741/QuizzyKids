//  NotificationItem.swift
//  Quizzy Kids
//  Created by Анастасия Набатова on 12/12/25.

import Foundation

struct NotificationModel: Identifiable, Hashable {
   let id = UUID()
   let title: String
   let message: String
   let time: String

   static let notificationMockDB: [NotificationModel] = [
       .init(title: "Level Completed!",
             message: "You completed Level 1 in “Mini Math Puzzle”! Keep going, superstar!",
             time: "1m ago"),
       .init(title: "You Earned a Star!",
             message: "You scored 1 star in “Odd One Out” — keep spotting those differences!",
             time: "32m ago"),
       .init(title: "New Puzzle Unlocked!",
             message: "Ready for a challenge? Try the new 3-level in “Count Dash Puzzle”!",
             time: "1h ago"),
       .init(title: "A New Story is Here!",
             message: "Read “Timmy and the Talking Tree” now in your reading section!",
             time: "3d ago"),
       .init(title: "Level Up!",
             message: "You moved to Level 2 in “Number Knocked”! Numbers are fun, right?",
             time: "4d ago"),
   ]
}
