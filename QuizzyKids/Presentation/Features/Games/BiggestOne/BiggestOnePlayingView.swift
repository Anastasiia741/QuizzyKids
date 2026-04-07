//  BiggestOnePlayingView.swift
//  Quizzy Kids

import SwiftUI

struct BiggestOnePlayingView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    @StateObject private var vm = BiggestOneViewModel()
    @StateObject private var winView = WinView()
    @StateObject private var successPresenter = WinView(lotties: ["Google Pay - Success"])

    @State private var showBack = false

    @State private var isSuccess = false
    @State private var isFinalWin = false

    @State private var lastTappedIndex: Int? = nil

    private var columns: [GridItem] {
        Array(repeating: GridItem(spacing: 18), count: 2)
    }

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 14) {
                Spacer(minLength: 0)
                
                Text("Pick the biggest one")
                    .font(AppFont.caption1())
                    .foregroundStyle(.grayscale400)
                    .padding(.top, 16)
                    .padding(.bottom, 6)
                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(0..<4, id: \.self) { i in
                        cell(index: i)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)

            if vm.state == .lose {
                ResultView(
                    placedCount: min(vm.roundIndex + 1, vm.total),
                    totalCount: vm.total,
                    title: "Oops!",
                    message: "No attempts left.",
                    lottieName: nil,
                    lottiePlayID: nil,
                    onRetry: {
                        lastTappedIndex = nil
                        vm.retrySame()
                    },
                    onContinue: {
                        lastTappedIndex = nil
                        vm.retrySame()
                    },
                    onExit: { coordinator.pop() }
                )
                .zIndex(999)
            }

            if isFinalWin {
                ResultView(
                    placedCount: vm.total,
                    totalCount: vm.total,
                    title: "Great job!",
                    message: "You finished all rounds!",
                    lottieName: winView.name,
                    lottiePlayID: winView.playID,
                    onRetry: {
                        isFinalWin = false
                        lastTappedIndex = nil
                        vm.start()
                    },
                    onContinue: {
                        coordinator.pop()
                    },
                    onExit: { coordinator.pop() }
                )
                .id(winView.playID)
                .zIndex(1000)
            }
        }
        .winLottieOverlay(isWin: isSuccess, presenter: successPresenter, centered: true)
        .winLottieOverlay(isWin: isFinalWin, presenter: winView, centered: true)

        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { showBack = true },
                title: "Biggest one",
                showsTitle: true
            )
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .task { vm.start() }
        .confirmAlert(isPresented: $showBack, text: "Exit the game?", showsAvatar: false) {
            coordinator.pop()
        }
        .onChange(of: vm.state) { _, newState in
            guard newState == .win else { return }
            handleCorrect()
        }
    }

    @ViewBuilder
    private func cell(index: Int) -> some View {
        let scale = vm.currentRound.scales[index]
        let shouldShake = (lastTappedIndex == index && vm.wrongID != nil)

        Button {
            guard vm.state == .playing, !vm.isLocked else { return }
            lastTappedIndex = index
            vm.select(index: index)
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .fill(Color.white.opacity(0.001))

                Image(vm.currentRound.image)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .scaleEffect(scale)
                    .clipped()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .contentShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .buttonStyle(.plain)
        .disabled(vm.isLocked)
        .modifier(ShakeEffect(animatableData: shouldShake ? 1 : 0))
        .animation(.easeOut(duration: 0.35), value: shouldShake)
    }

    @MainActor
    private func handleCorrect() {
        Task { @MainActor in
            isSuccess = true
            try? await Task.sleep(nanoseconds: 1_900_000_000)
            isSuccess = false

            lastTappedIndex = nil

            let isLast = (vm.roundIndex == vm.total - 1)
            if isLast {
                isFinalWin = true
                winView.trigger()
                return
            }

            vm.goNext()
        }
    }
}
