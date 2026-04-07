//  AnimalGameQuizLevel1.swift
//  Quizzy Kids

import SwiftUI
import Kingfisher

private enum AnimalMapProgress {
    static let unlockedStorageKey = "nk_unlockedAnimalLevel"

    static func unlockNextMapLevelFromCurrent() {
        let current = UserDefaults.standard.integer(forKey: unlockedStorageKey)
        let next = min(max(current + 1, 1), 4)
        guard next > current else { return }
        UserDefaults.standard.set(next, forKey: unlockedStorageKey)
    }

    static func unlockMapLevelIfNeeded(minimum: Int) {
        let current = UserDefaults.standard.integer(forKey: unlockedStorageKey)
        guard minimum > current else { return }
        UserDefaults.standard.set(minimum, forKey: unlockedStorageKey)
    }
}

struct AnimalGameQuizLevel1: View, TimeFormatting {
    @EnvironmentObject private var coordinator: AppCoordinator
    @ObservedObject private var settingsVM = SettingsViewModel.shared
    @StateObject private var vm = AnimalGameViewModel(level: 1)
    @StateObject private var winView = WinView()
    @StateObject private var successPresenter = WinView(lotties: ["Google Pay - Success"])

    @State private var showExitConfirm = false
    @State private var showPause = false

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()

            VStack(spacing: 10) {
                Text(vm.prompt?.name ?? "")
                    .font(.title)
                    .foregroundColor(.black)
                    .padding(.top, 18)

                ZStack {
                    RoundedRectangle(cornerRadius: 18)
                        .fill(Color.white.opacity(0.6))

                    RoundedRectangle(cornerRadius: 16)
                        .stroke(
                            vm.shouldShowCenterWrongBorder ? .message200 : Color.clear,
                            lineWidth: 2
                        )

                    if let centerItem = vm.selectedChoiceForCenter,
                       let url = vm.imageURLs[centerItem.id] {
                        KFImage(url)
                            .resizable()
                            .scaledToFit()
                            .padding(12)
                    }
                }
                .frame(width: 170, height: 170)
                .padding(.top, 6)

                Text(formatTime(vm.timeLeft, style: .zeroMinutesSeconds))
                    .font(AppFont.callout())
                    .foregroundColor(.black.opacity(0.8))
                    .padding(.top, 4)
            }
            .allowsHitTesting(!vm.isGameplayPaused)
        }
        .navigationBarBackButtonHidden(true)
        .winLottieOverlay(isWin: vm.showLottie, presenter: successPresenter, centered: false)

        .oneStarDownAlert(
            isPresented: $vm.showLoseAlert,
            starsCount: settingsVM.profile?.bonuses ?? 100,
            totalStars: 100,
            message: "One star down, many\nmore to win!",
            onRestart: { vm.restartLevel() },
            onNext: { vm.continueAfterLoss() },
            onExit: { vm.pauseGameplay() }
        )

        .customTwoButtonAlert(
            isPresented: $vm.showLevelUnlocked,
            text: "New level unlocked!\n\nYou made 5 correct answers.",
            leftTitle: "Restart",
            rightTitle: "Next",
            onLeft: {
                AnimalMapProgress.unlockMapLevelIfNeeded(minimum: 2)
                coordinator.pop()
            },
            onRight: { vm.continueAfterFiveUnlock() }
        )

        .completedAlert(
            isPresented: $vm.showTwoStarsMilestone,
            message: "Yay! You earned a shiny new star!",
            onRestart: { vm.restartLevel() },
            onContinue: {
                AnimalMapProgress.unlockNextMapLevelFromCurrent()
                coordinator.pop()
            },
            onExit: { vm.pauseGameplay() }
        )

        .confirmAlert(
            isPresented: $showExitConfirm,
            text: "Exit the game?",
            showsAvatar: false,
            onNo: {
                guard !vm.isGameplayPaused else { return }
                vm.resumeAfterPauseMenuClosed()
            },
            onYes: {
                vm.pauseForMenuOverlay()
                coordinator.pop()
            }
        )

        .pauseAlert(isPresented: $showPause) { action in
            switch action {
            case .resume:
                if vm.isGameplayPaused {
                    vm.resumeGameplayFromPauseMenu()
                } else {
                    vm.resumeAfterPauseMenuClosed()
                }
            case .restart:
                vm.restartLevel()
            case .home, .level:
                coordinator.pop()
            case .exit:
                showExitConfirm = true
            }
        }

        .onChange(of: vm.showTwoStarsMilestone) { _, isOn in
            if isOn { winView.trigger() }
        }

        .onAppear { vm.onAppear() }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                backgroundImage: nil,
                showsBack: true,
                onBack: {
                    vm.pauseForMenuOverlay()
                    showExitConfirm = true
                },
                title: "Animal game",
                showsTitle: true,
                rightAssetIcon: Icons.icon10.rawValue,
                onRightTap: {
                    vm.pauseForMenuOverlay()
                    showPause = true
                }
            )
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomView(
                options: Array(vm.choices.indices),
                selected: vm.selectedIndex,
                onTap: { vm.selectChoice(at: $0) },
                content: { index in
                    let item = vm.choices[index]
                    if let url = vm.imageURLs[item.id] { return .image(url.absoluteString) }
                    return .empty
                },
                showsBottomButton: true,
                bottomButtonTitle: "Check",
                onBottomButtonTap: { Task { await vm.checkAnswer() } },
                columnsCount: 4
            )
            .ignoresSafeArea(edges: .bottom)
            .disabled(vm.isGameplayPaused)
        }
    }
}
