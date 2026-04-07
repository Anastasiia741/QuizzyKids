//  DifferenceGameView.swift
//  Quizzy Kids

import SwiftUI

struct DifferencesView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let data: GameSessionData?

    private let columns = [
        GridItem(.flexible(), spacing: 20),
        GridItem(.flexible(), spacing: 20),
    ]

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            LazyVGrid(columns: columns, spacing: 20) {
                ForEach(FindDifferencesMockDB.ids, id: \.self) { id in
                    Button {
                        coordinator.push(.findDifferences(levelID: id))
                    } label: {
                        Image(FindDifferencesMockDB.previewImage(for: id))
                            .resizable()
                            .scaledToFill()
                            .frame(height: 180)
                            .frame(maxWidth: .infinity)
                            .clipped()
                            .clipShape(
                                RoundedRectangle(
                                    cornerRadius: 12,
                                    style: .continuous
                                )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 20)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
}
