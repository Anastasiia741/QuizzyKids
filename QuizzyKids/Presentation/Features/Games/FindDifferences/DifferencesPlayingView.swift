//  FindDifferencesGameView.swift
//  Quizzy Kids

import SwiftUI
import UIKit

struct DifferencesPlayingView: View, TimeFormatting {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm: DifferencesViewModel
    @StateObject private var winView = WinView()

    private let images = ["games_puzzle_01", "games_puzzle_02", "games_puzzle_03", "games_puzzle_04"]

    @State private var showBackConfirm = false
    @State private var showPause = false

    init(levelID: String) {
        _vm = StateObject(wrappedValue: DifferencesViewModel(levelID: levelID, seconds: 60))
    }

    var body: some View {
        GeometryReader { _ in
            ZStack {
                Color.accent100.ignoresSafeArea()
                VStack(spacing: 14) {
                    ZStack {
                        Text(formatTime(vm.timeLeft))
                            .font(AppFont.caption1())
                            .monospacedDigit()
                            .foregroundStyle(.grayscale400)

                        HStack {
                            Spacer()
                            Text("\(vm.foundCount)/\(vm.total)")
                                .font(AppFont.caption1())
                                .foregroundStyle(.grayscale400)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 8)
                                .background(Color.white)
                                .clipShape(Capsule())
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 16)

                    VStack(spacing: 18) {
                        FindDifferencesImageView(
                            imageName: vm.topImage,
                            differences: vm.differences,
                            found: vm.found,
                            onTapNormalized: vm.handleTap(normalized:)
                        )
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .padding(.horizontal, 20)

                        FindDifferencesImageView(
                            imageName: vm.bottomImage,
                            differences: vm.differences,
                            found: vm.found,
                            onTapNormalized: vm.handleTap(normalized:)
                        )
                        .frame(height: 300)
                        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                        .padding(.horizontal, 20)
                    }

                    Spacer(minLength: 0)
                }
            }
            .safeAreaInset(edge: .top, spacing: 12) {
                HeaderView(
                    showsBack: true,
                    onBack: {
                        vm.pauseTimer()
                        showBackConfirm = true
                    },
                    title: "Find \(vm.total) differences",
                    showsTitle: true,
                    rightAssetIcon: showPause ? "ui_icons_11" : "ui_icons_10",
                    onRightTap: {
                        vm.pauseTimer()
                        showPause = true
                    }
                )
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .navigationBar)
            .task { vm.start() }
            .onChange(of: vm.state) { _, newState in
                if newState == .win {
                    winView.trigger()
                }
            }
            .onDisappear { vm.stop() }

            .confirmAlert(
                isPresented: $showBackConfirm,
                text: "Exit the game?",
                showsAvatar: false,
                onNo: { vm.resumeTimer() }
            ) {
                vm.stop()
                coordinator.pop()
            }
            .singleAlert(
                isPresented: $showPause,
                text: "Pause",
                buttonTitle: "Back to game",
                showsAvatar: false,
                onClose: { vm.resumeTimer() }
            )

            if vm.state == .win {
                ResultView(
                    placedCount: vm.foundCount,
                    totalCount: vm.total,
                    title: "Great job!",
                    message: "You found all differences!",
                    lottieName: winView.name,
                    lottiePlayID: winView.playID,
                    onRetry: { vm.retrySame() },
                    onContinue: {
                        vm.stop()
                        coordinator.pop()
                    },
                    onExit: {
                        vm.stop()
                        coordinator.pop()
                    }
                )
                .id(winView.playID)
                .zIndex(999)
            }

            if vm.state == .lose {
                ResultView(
                    placedCount: vm.foundCount,
                    totalCount: vm.total,
                    title: "Time’s up!",
                    message: "You gave it your best. Let’s try again.",
                    lottieName: nil,
                    lottiePlayID: nil,  
                    onRetry: { vm.retrySame() },
                    onContinue: { vm.continueAfterLose(extraSeconds: 15) },
                    onExit: {
                        vm.stop()
                        coordinator.pop()
                    }
                )
                .zIndex(999)
            }
        }
    }
}
