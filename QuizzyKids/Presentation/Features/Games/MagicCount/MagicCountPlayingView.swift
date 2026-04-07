//  MagicCountPlayingView.swift
//  Quizzy Kids

import SwiftUI


struct MagicCountPlayingView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = MagicCountViewModel()
    @StateObject private var winView = WinView()
    @StateObject private var successPresenter = WinView(lotties: ["Google Pay - Success"])
   
    @State private var showBack = false
    @State private var isSuccess = false
    @State private var isFinalWin = false

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 16) {
                Spacer(minLength: 0)

                CircleRingView(
                    count: vm.correctCount,
                    imageName: vm.imageName,
                    selectedText: vm.selected.map(String.init) ?? ""
                )
                   
                if vm.showWrongText {
                    Text("wrong! please try again.")
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(.message200)
                        .transition(.opacity)
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
                    onRetry: { vm.retrySame() },
                    onContinue: { vm.retrySame() },
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
                        vm.start()
                    },
                    onContinue: { coordinator.pop() },
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
                title: "Count the objects",
                showsTitle: true
            )
        }
        .safeAreaInset(edge: .bottom, spacing: 12) {
            BottomView(
                  options: vm.options,
                  selected: vm.selected,
                  onTap: { value in
                      vm.select(value: value)
                  }, content: { value in
                          .image(vm.countDigitAsset(for: value))
                  },
                  showsBottomButton: true,
                  onBottomButtonTap: {
                      vm.check()
                  }
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

  

    @MainActor
    private func handleCorrect() {
        Task { @MainActor in
            isSuccess = true
            try? await Task.sleep(nanoseconds: 1_600_000_000)
            isSuccess = false

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

private struct CircleRingView: View {
    let count: Int
    let imageName: String
    let selectedText: String

    var body: some View {
        GeometryReader { g in
            let n = max(1, count)
            let c = CGPoint(x: g.size.width/2, y: g.size.height/2)

            ZStack {
                ForEach(0..<n, id: \.self) { i in
                    Image(imageName)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity)
                        .frame(height: 100)
                        .position(point(i, n, c, g.size))
                }

                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color.white.opacity(0.35))
                    .frame(width: 120, height: 120)
                    .overlay(
                        Text(selectedText)
                            .font(.system(size: 64, weight: .heavy))
                            .foregroundStyle(.primary100)
                    )
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }

    private func point(_ i: Int, _ n: Int, _ c: CGPoint, _ s: CGSize) -> CGPoint {
        let item: CGFloat = 100
        let center: CGFloat = 150
        let gap: CGFloat = 16

        if n == 1 {
            return CGPoint(x: c.x, y: c.y - center/2 - gap - item/2)
        }

        if n <= 3 {
            let step = item + gap
            return CGPoint(
                x: c.x + (CGFloat(i) - CGFloat(n - 1)/2) * step,
                y: c.y - center/2 - gap - item/2   
            )
        }

        let maxR = min(s.width, s.height) / 2 - item/2 - 8
        let minR = center/2 + gap + item/2
        let r = max(minR, min(maxR, min(s.width, s.height) * 0.28))

        let a = (2 * Double.pi / Double(n)) * Double(i) - Double.pi / 2
        return CGPoint(x: c.x + CGFloat(cos(a)) * r, y: c.y + CGFloat(sin(a)) * r)
    }

}


