//  RootView.swift
//  Quizzy Kids

import SwiftUI
import Firebase
import GoogleSignIn

struct RootView: View {
    @State private var showSplash = true
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @StateObject private var authVM = AuthentificationViewModel()
    @StateObject private var coordinator = AppCoordinator()
    
    var body: some View {
        NavigationStack(path: $coordinator.path) {
            Group {
                if showSplash {
                    SplashScreenView()
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                showSplash = false
                            }
                        }
                } else if !hasSeenOnboarding {
                    OnboardingView {
                        hasSeenOnboarding = true
                    }
                } else if authVM.authenticationState == .authenticated {
                    MainScreen()
                } else {
                    LoginView(startMode: .signUp)
                }
            }
            .navigationDestination(for: AppRoute.self) { route in
                build(route)
            }
            .onOpenURL { url in
                if GIDSignIn.sharedInstance.handle(url) { return }
            }
            .onChange(of: authVM.authenticationState) { _, newValue in
                guard newValue == .authenticated else { return }
                var t = Transaction()
                t.disablesAnimations = true
                withTransaction(t) {
                    coordinator.path.removeAll()
                }
            }
        }
        .environmentObject(coordinator)
        .environmentObject(authVM)
    }
    
    @ViewBuilder
    private func build(_ route: AppRoute) -> some View {
        
        switch route {
        case .notifications:
            NotificationsView()
        case .quiz(let type):
            GameScreen(type: type, sessionID: nil)
        case .animalSound(levelId: let levelId):
            AnimalGameQuizLevel1()
        case .readingGame(let bookID):
            ReadingGameView(bookID: bookID)
        case .game(let type, let sessionID):
            GameScreen(type: type, sessionID: sessionID)
        case .picturePuzzlePlaying(let title, let imageName, let pieces):
            PuzzlePlayingView(
                title: title,
                imageName: imageName,
                pieces: pieces
            )
        case .alphabetLetters:
            AlphabetPlayingView()
        case let .findDifferences(levelID):
            DifferencesPlayingView(levelID: levelID)
        case .findOddOne:
            OddOnePlayingView()
        case .numbersSound(let levelId):
            NumbersSoundView(levelId: levelId)
        case .numbersDraw(let levelId):
            NumbersDrawView(levelId: levelId)
        case .numbersCount(let levelId):
            NumbersCountView(levelId: levelId)
        case .numbersSense(let levelId):
            NumbersSenseView(levelId: levelId)
        case .biggestOne:
            BiggestOnePlayingView()
        case .magicCount:
            MagicCountPlayingView()
        case .animalWorld:
            AnimalWorldPlayingView()
        case .login:
            LoginView(startMode: .login)
        case .forgotPassword:
            ForgotPasswordView()
        case .profile:
            ProfileView()
        case .achievements:
            AchievementsView()
        case .more:
            MoreView()
        case .logout:
            TermsOfUseView()
        case .dailyStreaks:
            DailyStreaksView()
        case .changePassword:
            ChangePasswordView()
        case .privacyPolicy:
            PrivacyPolicyView()
        case .termsOfUse:
            TermsOfUseView()
        case .deleteAccount:
            TermsOfUseView()
        
        }
    }
}




