//  AnimalWorldPlayingView.swift
//  Quizzy Kids

import SwiftUI

struct AnimalWorldPlayingView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = AnimalWorldViewModel()
    @StateObject private var winView = WinView()
    @StateObject private var successPresenter = WinView(lotties: ["Google Pay - Success"])

    @State private var showBack = false
    @State private var isSuccess = false
    @State private var isWin = false

    @State private var revealedTitle: String? = nil

    private var columns: [GridItem] {
        Array(repeating: GridItem(.fixed(150), spacing: 18), count: 2)
    }

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()

            VStack(spacing: 14) {
                Spacer(minLength: 0)

                Text("Find the odd one out")
                    .font(AppFont.caption1())
                    .foregroundStyle(.grayscale400)
                    .padding(.vertical, 16)
                
                Text(revealedTitle ?? " ")
                    .font(AppFont.marker(28))
                    .foregroundStyle(.grayscale400)
                    .opacity(revealedTitle == nil ? 0 : 1)
                    .frame(height: 34)
                    .animation(.easeInOut(duration: 0.2), value: revealedTitle)

                LazyVGrid(columns: columns, spacing: 18) {
                    ForEach(vm.question.items.prefix(4)) { item in
                        cell(item)
                    }
                }

                Text("\(vm.index + 1)/\(vm.total)")
                    .font(AppFont.caption1())
                    .foregroundStyle(.grayscale400)
                    .padding(.vertical, 10)

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 20)

            if vm.state == .win {
                ResultView(
                    placedCount: vm.index + 1,
                    totalCount: vm.total,
                    title: "Great job!",
                    message: "You found the odd one!",
                    lottieName: winView.name,
                    lottiePlayID: winView.playID,
                    onRetry: { vm.retrySame() },
                    onContinue: {
                        coordinator.pop()
                    },
                    onExit: {
                        coordinator.pop()
                    }
                )
                .id(winView.playID)
                .zIndex(999)
            }

            if vm.state == .lose {
                ResultView(
                    placedCount: vm.index + 1,
                    totalCount: vm.total,
                    title: "Oops!",
                    message: "No attempts left.",
                    lottieName: nil,
                    lottiePlayID: nil,
                    onRetry: { vm.retrySame() },
                    onContinue: { vm.retrySame() },
                    onExit: {
                        coordinator.pop()
                    }
                )
                .zIndex(999)
            }
        }
        .winLottieOverlay(isWin: isSuccess, presenter: successPresenter, centered: true)
        .winLottieOverlay(isWin: isWin, presenter: winView, centered: true)

        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { showBack = true },
                title: "Animal world",
                showsTitle: true
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
        .confirmAlert(isPresented: $showBack, text: "Exit the game?", showsAvatar: false) {
            coordinator.pop()
        }
    }

    @ViewBuilder
    private func cell(_ item: AnimalWorldItem) -> some View {
        let id = item.id
        let isWrong = vm.question.wrongID == id

        Button {
            guard !vm.question.isLocked else { return }

            let isCorrect = (item.image == vm.current?.oddOne)

            vm.select(item)

            guard isCorrect else { return }

            revealedTitle = vm.current?.title

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 900_000_000)

                let isLast = (vm.index == vm.total - 1)
                if isLast {
                    isWin = true
                    winView.trigger()
                    try? await Task.sleep(nanoseconds: 2_000_000_000)
                    isWin = false
                    revealedTitle = nil
                    vm.goNext()
                    return
                }

                isSuccess = true
                try? await Task.sleep(nanoseconds: 2_400_000_000)
                isSuccess = false

                revealedTitle = nil
                vm.goNext()
            }

        } label: {
            Image(item.image.rawValue)
                .resizable()
                .scaledToFit()
        }
        .disabled(vm.question.isLocked)
        .modifier(ShakeEffect(animatableData: isWrong ? 1 : 0))
        .animation(.easeOut(duration: 0.35), value: isWrong)
    }
}
