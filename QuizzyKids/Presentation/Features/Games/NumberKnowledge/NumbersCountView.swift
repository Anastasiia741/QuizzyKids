//  NumbersCountView.swift
//  Quizzy Kids

import SwiftUI

struct NumbersCountView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = NumbersViewModel()
    @StateObject private var winPresenter = WinView()
    @State private var isWin: Bool = false
    @State private var showBack: Bool = false

    @State private var showResultOverlay: Bool = false

    let levelId: Int

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accent100.ignoresSafeArea()

            VStack(spacing: 16) {
                fruitsGrid
                selectedNumberBox

                Text("00:58")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.black.opacity(0.6))

                if vm.round.showWrongText {
                    Text("wrong! please try again.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.red)
                }

                Spacer(minLength: 0)
            }
            .padding(.top, 20)
            .padding(.horizontal, 20)
            .padding(.bottom, 150)

//            BottomView(
//                style: .numbers,
//                numberAssets: vm.round.options.map { vm.countDigitAsset(for: $0) },
//                showsButton: true,
//                buttonTitle: "Check",
//                onButtonTap: { onCheck() },
//                isSelected: { i in
//                    guard i < vm.round.options.count else { return false }
//                    return vm.round.selected == vm.round.options[i]
//                },
//                onTap: { i in
//                    guard i < vm.round.options.count else { return }
//                    vm.selectCountOption(vm.round.options[i])
//                }
//            )

            if showResultOverlay {
                ResultView(
                    placedCount:  vm.countTaskIndex + 1,
                    totalCount: vm.countTotalTasks,
                    title: "Oops!",
                    message: "No attempts left.",
                    lottieName: nil,
                    lottiePlayID: nil,
                    onRetry: {
                        showResultOverlay = false
                        startRound()
                    },
                    onContinue: {
                        showResultOverlay = false
                    },
                    onExit: {
                        coordinator.pop()
                    }
                )
                .transition(.opacity)
                .zIndex(999)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { showBack = true },
                title: "Number knowledge",
                showsTitle: true
            )
        }
        .safeAreaInset(edge: .bottom, spacing: 12) {
            BottomView(
                options: vm.round.options,
                selected: vm.round.selected,
                onTap: { value in
                    vm.selectCountOption(value)
                }, content: { value in
                        .image(vm.countDigitAsset(for: value))
                },
                showsBottomButton: true,
                bottomButtonTitle: "Check",
                onBottomButtonTap: {
                    onCheck()
                }
            )
        }

        .onAppear {
            startRound()
            showResultOverlay = false
        }
        .winLottieOverlay(isWin: isWin, presenter: winPresenter)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .confirmAlert(
            isPresented: $showBack,
            text: "Exit the game?",
            showsAvatar: false
        ) { coordinator.pop() }
    }

    private var fruitsGrid: some View {
        guard let task = vm.currentCountTask else { return AnyView(EmptyView()) }

        let columns = Array(repeating: GridItem(.flexible(), spacing: 16), count: 3)
        return AnyView(
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(0..<task.count, id: \.self) { _ in
                    Image(task.image.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 64)
                }
            }
            .padding(.top, 10)
        )
    }

    private var selectedNumberBox: some View {
        RoundedRectangle(cornerRadius: 22)
            .fill(Color.white.opacity(0.35))
            .overlay(
                Text(vm.round.selected.map(String.init) ?? "")
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundStyle(Color.orange)
            )
            .frame(width: 150, height: 150)
            .padding(.top, 12)
    }

    private func startRound() {
        guard let task = vm.currentCountTask else { return }
           vm.startCountRound(correct: task.count)
    }

    private func onCheck() {
        guard let task = vm.currentCountTask else { return }
        let result = vm.checkCount(correct: task.count)
        switch result {
        case .correct:
            isWin = true
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_200_000_000)
                isWin = false

                if vm.advanceCountTask() {
                           startRound()
                       } else {
                           NumbersProgress.unlockedLevel = max(NumbersProgress.unlockedLevel, 4)
                           coordinator.pop()
                       }
            }

        case .wrongHasAttempts:
            break

        case .wrongNoAttempts:
            showResultOverlay = true
        }
    }
}
