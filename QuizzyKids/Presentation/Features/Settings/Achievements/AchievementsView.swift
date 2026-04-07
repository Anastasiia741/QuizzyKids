//  AchievementGamesView.swift
//  Quizzy Kids

import SwiftUI

struct AchievementsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authVM: AuthentificationViewModel
    @Environment(\.scenePhase) private var scenePhase
    @StateObject private var viewModel = AchievementsViewModel()
    
    var body: some View {
        ZStack {
            Color.accent100
                .ignoresSafeArea()
            VStack(spacing: 20) {
                totalStar
                storyReaderCard
                dailyStreaksCard
                moreGamesFooter
            }
            .padding(.horizontal, 20)
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .safeAreaInset(edge: .top, spacing: 12, content:{
            HeaderView(
                showsBack: true,
                onBack: { coordinator.pop() },
                title: "Achievements",
                showsTitle: true
            )
        })
        .navigationBarBackButtonHidden(true)
        .task {
            await viewModel.loadRemoteProfile(user: authVM.user)
            viewModel.refreshLocalStats()
        }
        .onAppear {
            viewModel.refreshLocalStats()
        }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active {
                viewModel.refreshLocalStats()
            }
        }
    }
    
    private var totalStar: some View {
        VStack(spacing: 10) {
            Image(Shapes.shape04.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 112, height: 62)
            
            Text("Total star")
                .font(AppFont.title2())
                .foregroundStyle(.grayscale400)
            
            Text("\(viewModel.bonuses)")
                .font(AppFont.title3())
                .foregroundColor(.grayscale400)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(
                cornerRadius: 24,
                style: .continuous
            )
            .fill(.accent400)
        )
    }
    
    private var storyReaderCard: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text("Story reader")
                .font(AppFont.title3())
                .foregroundColor(.grayscale400)
            Text(viewModel.storyReaderSubtitle)
                .font(AppFont.body())
                .foregroundStyle(.grayscale400)
            HStack(spacing: 12) {
                ForEach(0..<AchievementsViewModel.storyReaderMaxBooks, id: \.self) { index in
                    Image(Icons.icon14.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 36, height: 36)
                        .opacity(index < viewModel.storyReaderFilledCount ? 1 : 0.25)
                }
            }
            .padding(.top, 4)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 24, style: .continuous)
                .fill(.colorE0D0E9).opacity(0.3)
        )
    }
    
    private var dailyStreaksCard: some View {
        Button {
            coordinator.push(.dailyStreaks)
        } label: {
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Daily streaks")
                            .font(AppFont.body())
                            .foregroundColor(.grayscale400)
                        Text(viewModel.streakSubtitle)
                            .font(AppFont.body2())
                            .foregroundStyle(.grayscale400)
                    }
                    Spacer()
                    Image(Icons.icon17.rawValue)
                }
                
                HStack(spacing: 10) {
                    ForEach(viewModel.streakMilestones, id: \.self) { day in
                        StreakCellView(
                            dayText: "\(day) Day",
                            active: viewModel.milestoneReached(day)
                        )
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 24)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(.colorF9E9E7)
            )
        }
        .buttonStyle(.plain)
    }
    
    
    private var moreGamesFooter: some View {
        if viewModel.canOpenMoreGames {
            AnyView(
                Button {
//                    coordinator.navigateToGamesTab()
                } label: {
                    Text("More games")
                }
                    .buttonStyle(AppButtonStyle(type: .primary))
            )
        } else {
            AnyView(
                Image(Banner.banner08.rawValue)
                    .resizable()
                    .scaledToFill()
                    .frame(height: 158)
                    .frame(maxWidth: .infinity)
            )
        }
    }
}
