//  NumberKnowledgeView.swift
//  Quizzy Kids

import SwiftUI

struct NumberKnowledgeView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        ProgressMapView(
            config: .init(
                backgroundImageName: Background.bg09.rawValue,
                unlockedKey: "nk_unlockedLevel",
                lastAnimatedKey: "nk_lastAnimatedLevel",
                openLevel: { id in
                    switch id {
                    case 2: coordinator.push(.numbersDraw(levelId: id))
                    case 3: coordinator.push(.numbersCount(levelId: id))
                    case 4: coordinator.push(.numbersSense(levelId: id))
                    default: coordinator.push(.numbersSound(levelId: id))
                    }
                }
            )
        )
    }
}
