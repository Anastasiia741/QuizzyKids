//  FindOddOneGameView.swift
//  Quizzy Kids

import SwiftUI

struct OddOnePlayingView: View, TimeFormatting {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = OddOneViewModel(seconds: 60)
    @StateObject private var winView = WinView()

    @State private var showBack = false
    @State private var showPause = false

    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(100), spacing: 18), count: 3)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.accent100.ignoresSafeArea()

                VStack(spacing: 14) {
                    Text(formatTime(vm.timeLeft))
                        .font(AppFont.caption1())
                        .monospacedDigit()
                        .foregroundStyle(.grayscale400)
                        .padding(.vertical, 16)
                        .padding(.bottom, 36)
                    LazyVGrid(columns: columns, spacing: 12) {
                        ForEach(vm.currentQuestion.items.prefix(12)) { item in
                            cell(item)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    Spacer(minLength: 0)
                }
            }
            .safeAreaInset(edge: .top, spacing: 12) {
                HeaderView(
                    showsBack: true,
                    onBack: {
                        vm.pauseTimer()
                        showBack = true
                    },
                    title: "Find odd one",
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
                isPresented: $showBack,
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
                    placedCount: 1,
                    totalCount: 1,
                    title: "Great job!",
                    message: "You found the odd one!",
                    lottieName: winView.name,
                    lottiePlayID: winView.playID, 
                    onRetry: { vm.retrySame() },
                    onContinue: { vm.goNext() },
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
                    placedCount: 0,
                    totalCount: 1,
                    title: "Time’s up!",
                    message: "Let’s try again.",
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

    @ViewBuilder
    private func cell(_ item: FindOddOneItem) -> some View {
        let id = item.id
        let isSelected = vm.model.selectedID == id
        let isWrong = vm.model.wrongID == id

        Button { vm.select(item) } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.001))

                Image(item.image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 90, height: 90)
                    .clipped()
            }
            .frame(width: 90, height: 90)
            .overlay {
                if isSelected {
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                        .stroke(.primary100, lineWidth: 2)
                }
            }
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(vm.model.isLocked)
        .modifier(ShakeEffect(animatableData: isWrong ? 1 : 0))
        .animation(.easeOut(duration: 0.35), value: isWrong)
    }
}
