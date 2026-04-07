//  AchievementsSheetView.swift
//  Quizzy Kids

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    private let score: Int = 18

    private let days: [DailyBonusDay] = [
        .init(day: 1, stars: 5),
        .init(day: 2, stars: 2),
        .init(day: 3, stars: 4),
        .init(day: 4, stars: 1),
        .init(day: 5, stars: 6),
        .init(day: 6, stars: 7),
        .init(day: 7, stars: 5),
        .init(day: 8, stars: 10),
        .init(day: 9, stars: 4),
        .init(day: 10, stars: 8),
        .init(day: 11, stars: 11),
        .init(day: 12, stars: 3),
    ]

    var body: some View {
        ZStack() {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 0) {

                HStack {
                    Spacer()
                    closeButton
                }
                .padding(.vertical, 20)
                .padding(.trailing, 20)
                
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 20) {
                        scoreCard
                        dailyBonusCard
                        QuizCardView(
                           backgroundImage: "ui_banners_06",
                           buttonType: .primary,
                           buttonText: "Watch video",
                           alignment: .left,
                           route: AppRoute.notifications)
                        
                        QuizCardView(
                           backgroundImage: "ui_banners_07",
                           buttonType: .primary,
                           buttonText: "Watch video",
                           alignment: .right,
                           route: AppRoute.notifications)
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 24)
                }
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

private extension ScoreView {
    var closeButton: some View {
        Button {
             coordinator.dismissSheet()
        } label: {
            Image("Close")
                .frame(width: 40, height: 40)
        }
        .buttonStyle(.plain)
    }

    var scoreCard: some View {
        ZStack(alignment: .trailing) {
             Image("ui_banners_05")
                 .resizable()
                 .scaledToFit()
                 .frame(height: 169)
                 .frame(maxWidth: .infinity)

            HStack {
                Spacer(minLength: 0)

                VStack(spacing: 6) {
                    Text("Your Score")
                        .font(AppFont.largeTitle())
                        .foregroundColor(.grayscale400)

                    HStack(spacing: 6) {
                        Text("\(score)")
                            .font(AppFont.largeTitle())
                            .foregroundColor(.grayscale400)
                        Image("ui_icons_13")
                            .frame(width: 54, height: 54)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.vertical, 24)
        }
        .frame(height: 169)
    }

    var dailyBonusCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Daily Bonus")
                .font(AppFont.title3())
                .foregroundColor(.grayscale400)
            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 12), count: 4),
                spacing: 12
            ) {
                ForEach(days) { item in
                    DailyBonusCell(item: item)
                }
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 23)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.colorE0D0E9)
        )
    }

}


private struct DailyBonusDay: Identifiable, Hashable {
    let id = UUID()
    let day: Int
    let stars: Int
}

private struct DailyBonusCell: View {
    let item: DailyBonusDay

    var body: some View {
        VStack(spacing: 6) {
            HStack(spacing: 4) {
                Text("\(item.stars)")
                    .font(AppFont.caption2())
                    .foregroundColor(.black)

                Image("ui_icons_13")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 14, height: 14)
            }
            .frame(width: 62, height: 45)
            .background(RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.accent100)
                )

            Text("Day \(item.day)")
                .font(AppFont.footnote())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: 54)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(.secondary100)
        )
    }
}


