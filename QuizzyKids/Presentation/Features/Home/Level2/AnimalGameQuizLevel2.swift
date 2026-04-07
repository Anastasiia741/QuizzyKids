//  AnimalGameQuizLevel2.swift
//  Quizzy Kids


import SwiftUI
import Kingfisher

struct AnimalGameQuizLevel2: View, TimeFormatting {
    @EnvironmentObject private var coordinator: AppCoordinator
    @ObservedObject private var settingsVM = SettingsViewModel.shared
    @StateObject private var vm = AnimalGameViewModel(level: 2)

    @StateObject private var winView = WinView()
    @StateObject private var successPresenter = WinView(lotties: ["Google Pay - Success"])

    @State private var showBack = false
    @State private var showPause = false

    var body: some View {
        ZStack {
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
            }
            .winLottieOverlay(isWin: vm.showLottie, presenter: successPresenter, centered: false)
            .safeAreaInset(edge: .top, spacing: 12) {
                HeaderView(
                    backgroundImage: nil,
                    showsBack: true,
                    onBack: { showBack = true },
                    title: "Level 2",
                    showsTitle: true,
                    rightAssetIcon: Icons.icon10.rawValue,
                    onRightTap: { showPause = true }
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
            }

            if vm.showLevelWinLottie, let winName = winView.name {
                WinLottieOverlay(name: winName, playID: winView.playID, centered: true)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .ignoresSafeArea()
                    .zIndex(2)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onChange(of: vm.showLevelWinLottie) { _, isOn in
            if isOn { winView.trigger() }
        }

        .onAppear { vm.onAppear() }
        .toolbar(.hidden, for: .navigationBar)
        .navigationBarBackButtonHidden(true)

//        .completedAlert(
//            isPresented: $vm.showLoseAlert,
//            starsCount: settingsVM.profile?.bonuses ?? 100,
//            totalStars: 100,
//            message: "One star down, many\nmore to win!",
//            onRestart: { coordinator.pop() },
//            onNext: { vm.restartLevel() },
//            onSettings: { showBack = true }
//        )
//
//        .completedAlert(
//            isPresented: $vm.showLevelUnlocked,
//            starsCount: settingsVM.profile?.bonuses ?? 100,
//            totalStars: 100,
//            message: "New level unlocked!\n\nYou made 5 correct answers.",
//            onRestart: { coordinator.pop() },
//            onNext: { vm.restartLevel() },
//            onSettings: { showBack = true }
//        )
//        .completedAlert(
//            isPresented: $vm.showTwoStarsMilestone,
//            starsCount: settingsVM.profile?.bonuses ?? 100,
//            totalStars: 100,
//            message: "You earned 2 stars.",
//            onRestart: { coordinator.pop() },
//            onNext: { vm.restartLevel() },
//            onSettings: { showBack = true }
//        )

        .confirmAlert(
            isPresented: $showBack,
            text: "Exit the game?",
            showsAvatar: false,
            onNo: { },
            onYes: { coordinator.pop() }
        )

        .pauseAlert(isPresented: $showPause) { action in
            switch action {
            case .resume:
                break
            case .restart:
                vm.restartLevel()
            case .home, .level:
                coordinator.pop()
            case .exit:
                showBack = true
            }
        }
    }
}

#Preview {
    AnimalGameQuizLevel2()
        .environmentObject(AppCoordinator())
}
