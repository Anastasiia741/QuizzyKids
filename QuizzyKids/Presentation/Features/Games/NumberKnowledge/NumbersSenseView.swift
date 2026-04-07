//  NumbersSenceView.swift
//  Quizzy Kids

import SwiftUI

struct NumbersSenseView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = NumbersViewModel()
    @StateObject private var winPresenter = WinView()

    @State private var isWin: Bool = false
    @State private var showBack: Bool = false

    @State private var showResultOverlay: Bool = false
    @State private var resultPlayID: UUID? = nil

    let levelId: Int

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()

            if let round = vm.currentMatchRound {
                VStack(spacing: 0) {
                    HStack(alignment: .top, spacing: 18) {
                        leftFruitsColumn(round: round)
                        rightNumbersColumn
                    }
                    .padding(.horizontal, 22)
                    .padding(.top, 16)

                    Spacer()

                    if vm.matchShowWrongText {
                        Text("wrong! please try again.")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(Color.red)
                            .padding(.bottom, 8)
                    }

                    Button("Check") {
                        onCheck()
                    }
                    .buttonStyle(
                        AppButtonStyle(
                            type: .primary,
                            customTextColor: .black,
                            customBackgroundColor: .secondary100,
                            customPressedBackgroundColor: .secondary100.opacity(0.8)
                        )
                    )
                    .padding(.horizontal, 22)
                    .padding(.bottom, 18)
                }
            } else {
                // Если вдруг нет раундов/данных
                EmptyView()
            }

            if showResultOverlay {
                ResultView(
                    placedCount: vm.matchRoundIndex + 1,
                    totalCount: vm.matchTotalRounds,
                    title: "One star down, many more to win!",
                    message: "",
                    lottieName: nil,
                    lottiePlayID: resultPlayID,
                    onRetry: {
                        showResultOverlay = false
                        vm.startMatchRound()
                    },
                    onContinue: {
                        showResultOverlay = false
                    },
                    onExit: {
                        coordinator.pop()
                    }
                )
                .zIndex(999)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) { header }
        .onAppear { vm.startMatchRound() }
        .winLottieOverlay(isWin: isWin, presenter: winPresenter)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .confirmAlert(
            isPresented: $showBack,
            text: "Exit the game?",
            showsAvatar: false
        ) { coordinator.pop() }
    }

    private var header: some View {
        HeaderView(
            showsBack: true,
            onBack: { showBack = true },
            title: "Number knowledge",
            showsTitle: true,
            rightAssetIcon: vm.isSoundOn ? "ui_icons_15" : "ui_icons_16",
            onRightTap: { vm.toggleSound() }
        )
    }


    private func leftFruitsColumn(round: NumbersSensesQuestion) -> some View {
        VStack(spacing: 18) {
            ForEach(round.rows.indices, id: \.self) { i in
                Image(round.rows[i].image.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 64, height: 64)
            }
        }
    }

    private var rightNumbersColumn: some View {
        VStack(spacing: 18) {
            ForEach(vm.matchNumbers.indices, id: \.self) { i in
                numberCell(index: i, value: vm.matchNumbers[i])
            }
        }
    }

    private func numberCell(index: Int, value: Int) -> some View {
        let state = cellState(index: index)

        return Button {
            vm.tapMatchNumber(at: index)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.65))

                Image(vm.digitAsset(for: value))
                    .resizable()
                    .scaledToFit()
                    .frame(width: 26, height: 32)
            }
            .frame(width: 62, height: 62)
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(state.borderColor, lineWidth: state.borderWidth)
            )
        }
        .buttonStyle(.plain)
    }

    private func cellState(index: Int) -> (borderColor: Color, borderWidth: CGFloat) {
        // После проверки показываем зелёный/красный
        if let perRow = vm.matchPerRowResult, index < perRow.count {
            return perRow[index] ? (Color.green, 2) : (Color.red, 2)
        }

        // Во время игры — выделяем выбранную
        if vm.matchSelectedIndex == index {
            return (Color.primary100, 2)
        }

        return (Color.clear, 0)
    }


    private func onCheck() {
        let result = vm.checkMatch()

        switch result {
        case .correctAll:
            isWin = true
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_200_000_000)
                isWin = false

                if !vm.advanceMatchRound() {
                    coordinator.pop()
                }
            }

        case .wrongHasAttempts:
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 900_000_000)
                vm.resetMatchHighlights()
            }

        case .wrongNoAttempts:
            resultPlayID = UUID()
            showResultOverlay = true
        }
    }
}
