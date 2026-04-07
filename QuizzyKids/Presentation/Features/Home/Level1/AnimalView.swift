//  AnimalView.swift
//  Quizzy Kids

import SwiftUI

struct AnimalView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ZStack{
            ProgressMapView(
                config: .init(
                    backgroundImageName: Background.bg11.rawValue,
                    unlockedKey: "nk_unlockedAnimalLevel",
                    lastAnimatedKey: "nk_lastAnimatedAnimalLevel",
                    openLevel: { id in
                        switch id {
                        case 2: coordinator.push(.animalSound(levelId: id))
                        case 3: coordinator.push(.animalSound(levelId: id))
                        case 4: coordinator.push(.animalSound(levelId: id))
                        default: coordinator.push(.animalSound(levelId: id))
                        }
                    }
                )
            )
        }
        .navigationBarBackButtonHidden(true)
    }
}
