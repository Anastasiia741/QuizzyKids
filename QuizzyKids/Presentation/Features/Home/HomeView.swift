//  HomeView.swift
//  Quizzy Kids

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @State private var data: GameSessionData?
    @AppStorage(AvatarStorage.key) private var profileAvatarAsset: String = Avatar.avatar01.rawValue

    private var headerAvatarImage: String {
        profileAvatarAsset.isEmpty ? Avatar.avatar01.rawValue : profileAvatarAsset
    }

    var body: some View {
        ZStack {
            Color.accent100
                .ignoresSafeArea()
            VStack() {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        QuizCardView(
                            backgroundImage: Banner.banner01.rawValue,
                            buttonType: .secondary,
                            buttonText: "Start now",
                            alignment: .left,
                            route:  .quiz(type: .animals),
                        )
                        QuizCardView(
                            backgroundImage: Banner.banner02.rawValue,
                            buttonType: .primary,
                            buttonText: "Start now",
                            alignment: .right,
                            route:  .quiz(type: .alphabet),
                        )
                        
                        QuizCardView(
                            backgroundImage: Banner.banner03.rawValue,
                            buttonType: .secondary,
                            buttonText: "Start now",
                            alignment: .left,
                            route: .quiz(type: .picturePuzzle),
                        )
                        
                        QuizCardView(
                            backgroundImage: Banner.banner04.rawValue,
                            buttonType: .primary,
                            buttonText: "Start now",
                            alignment: .right,
                            route:  .quiz(type: .animals),
                        )
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, UIDevice.current.userInterfaceIdiom == .pad ? 80 : 30)
                }
            }
            .safeAreaInset(edge: .top, spacing: 12) {
                HeaderView(
                    avatarImage: headerAvatarImage,
                    titleTop: "Good morning",
                    showsNotification: true,
                    onTapNotification: { coordinator.push(.notifications) },
                    showsStarsBadge: true,
                    onTapStars: { coordinator.present(.scoreView) }
                )
            }
        }
    }
}

