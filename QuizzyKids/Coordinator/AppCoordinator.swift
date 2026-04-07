//  AppCoordinator.swift
//  Quizzy Kids

import SwiftUI
internal import Combine

enum AppRoute: Hashable {
    case notifications
    case quiz(type: GameType)
    case animalSound(levelId: Int)
    case readingGame(bookID: String)
    case game(type: GameType, sessionID: UUID)
    case picturePuzzlePlaying(title: String, imageName: String, pieces: Int)
    case alphabetLetters
    case findDifferences(levelID: String)
    case findOddOne
    case numbersSound(levelId: Int)
    case numbersDraw(levelId: Int)
    case numbersCount(levelId: Int)
    case numbersSense(levelId: Int)
    case biggestOne
    case magicCount
    case animalWorld
    
    case login
    case forgotPassword
    
    case profile
    case achievements
    case more
    case logout
    case dailyStreaks
    case changePassword
    case privacyPolicy
    case termsOfUse
    case deleteAccount
}


enum GameType: String, Hashable {
    case animals
    case picturePuzzle
    case alphabet
    case findDifferences
    case oddOne
    case animalWord
    case numberKnowledge
    case biggestOne
    case magicCount
}

enum AppSheet: Identifiable, Hashable {
    case scoreView
    case avatarPicker
    
    var id: String {
        switch self {
        case .scoreView: return "scoreView"
        case .avatarPicker: return "avatarPicker"
        }
    }
}


@MainActor
final class AppCoordinator: ObservableObject {
    @Published var path: [AppRoute] = []
    @Published var sheet: AppSheet? = nil
    
    func push(_ route: AppRoute) { path.append(route) }
    func pop() { _ = path.popLast() }
    func popToRoot() { path.removeAll() }
    func present(_ sheet: AppSheet) { self.sheet = sheet }
    func dismissSheet() { self.sheet = nil }
}

