//  ReadingView.swift
//  Quizzy Kids

import SwiftUI

struct GamesView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    private let items = GameMockDB.items
    
    var body: some View {
        ZStack {
            Color.accent100
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                VStack(spacing: 0) {
                    LazyVGrid(
                        columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                        ],
                        content: {
                            ForEach(items) { item in
                                Button {
                                    coordinator.push(.game(type: item.type, sessionID: UUID()))
                                } label: {
                                    CardView(image: item.image.rawValue)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    )
                }
                .padding(.horizontal, 20)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                titleTop: "Good morning",
                showsStarsBadge: true,
                onTapStars: { coordinator.present(.scoreView) }
            )
        }
    }
}


struct GameSessionData: Hashable {
    let id: UUID
    let payload: String
}

enum GameMockEngine {
    static func makeSession(type: GameType) -> GameSessionData {
        let random = Int.random(in: 1000...9999)
        return GameSessionData(id: UUID(), payload: "\(type.rawValue)-\(random)")
    }
}




