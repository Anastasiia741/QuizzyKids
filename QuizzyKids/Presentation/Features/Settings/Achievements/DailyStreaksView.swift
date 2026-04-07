//  DailyStreaksView.swift
//  Quizzy Kids

import SwiftUI

struct DailyStreaksView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    private let days: [Int] = [
        1, 3, 7, 10, 12,
        15, 17, 20, 23, 25,
        28, 31, 33, 34, 37,
        40, 44, 46, 50, 52,
        54, 57, 60, 63, 66,
        70, 74, 76, 80, 83,
        86, 90, 93, 96, 100,
    ]

    private var streak: Int { AppVisitStreak.consecutiveDays }

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 0) {
                    LazyVGrid(
                        columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 5),
                        spacing: 12
                    ) {
                        ForEach(days.indices, id: \.self) { idx in
                            let day = days[idx]
                            let active = streak >= day

                            StreakCellView(
                                dayText: "\(day) Day",
                                active: active,
                                iconBoxSize: .init(width: 56, height: 42),
                                cellMinHeight: 70
                            )
                        }
                    }

                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
                }
            
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                titleTop: "Daily streaks",
                showsStarsBadge: true,
                onTapStars: { coordinator.present(.scoreView) }
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            AppVisitStreak.registerVisitIfNeeded()
        }
    }
}
