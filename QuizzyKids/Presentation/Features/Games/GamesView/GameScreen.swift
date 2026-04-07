//  GameScreen.swift
//  Quizzy Kids

import SwiftUI

struct GameScreen: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var alphabetVM = AlphabetViewModel()
    @State private var data: GameSessionData?
    let type: GameType
    let sessionID: UUID?
    
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            switch type {
            case .alphabet:
                AlphabetView(data: data)
            case .oddOne:
                OddOneView(data: data)
            case .numberKnowledge:
                NumberKnowledgeView()
            case .biggestOne:
                BiggestOneView(data: data)
            case .magicCount:
                MagicCountView(data: data)
            case .animalWord:
                AnimalWorldView(data: data)
            case .animals:
                AnimalView()
            default:
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 0) {
                        switch type {
                        case .picturePuzzle:
                            PicturePuzzleView(data: data)
                        case .findDifferences:
                            DifferencesView(data: data)
                            
                        default:
                            EmptyView()
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            if type == .animals {
                HeaderView(
                    backgroundImage: Background.bg12.rawValue,
                    showsBack: true,
                    onBack: { coordinator.pop() },
                    title: title,
                    showsTitle: true,
                    showsStarsBadge: true,
                    onTapStars: { coordinator.present(.scoreView) }
                )
            } else {
                HeaderView(
                    showsBack: true,
                    onBack: { coordinator.pop() },
                    title: title,
                    showsTitle: true,
                    showsStarsBadge: true,
                    onTapStars: { coordinator.present(.scoreView) }
                )
            }
        }

        .navigationBarBackButtonHidden(true)
        .task(id: sessionID) {
            data = GameMockEngine.makeSession(type: type)
        }
    }
    
    private var title: String {
        switch type {
        case .picturePuzzle: return "Picture puzzle"
        case .alphabet: return "A to Z Alphabet"
        case .findDifferences: return "Find differences"
        case .oddOne: return "Find odd one"
        case .animalWord: return "Animal word"
        case .numberKnowledge: return "Number knowledge"
        case .biggestOne: return "Choose the biggest One"
        case .magicCount: return "Magic count"
        case .animals: return "Animals"
        }
    }
    
    private func reload() {
        data = GameMockEngine.makeSession(type: type)
    }
}
