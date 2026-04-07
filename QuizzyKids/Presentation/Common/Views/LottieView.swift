//  LottieView.swift
//  Quizzy Kids

internal import Combine
import Lottie
import SwiftUI

struct WinLottieOverlay: View {
    let name: String
    let playID: UUID
    var centered: Bool = false

    var body: some View {
        ZStack {
            Color.clear.ignoresSafeArea()

            if centered {
                LottieView(
                    name: name,
                    loopMode: .playOnce,
                    playID: playID,
                    layout: .centered(CGSize(width: 260, height: 260))
                )
            } else {
                LottieView(
                    name: name,
                    loopMode: .playOnce,
                    playID: playID,
                    layout: .fill
                )
                .ignoresSafeArea()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .allowsHitTesting(false)
    }
}


struct LottieView: UIViewRepresentable {
    enum Layout {
        case fill
        case centered(CGSize)
    }

    let name: String
    let loopMode: LottieLoopMode
    let playID: UUID
    var layout: Layout = .fill

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.backgroundColor = .clear

        let anim = LottieAnimationView(name: name)
        anim.backgroundColor = .clear
        anim.loopMode = loopMode
        anim.backgroundBehavior = .pauseAndRestore
        anim.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(anim)

        switch layout {
        case .fill:
            anim.contentMode = .scaleAspectFill
            NSLayoutConstraint.activate([
                anim.leadingAnchor.constraint(equalTo: container.leadingAnchor),
                anim.trailingAnchor.constraint(equalTo: container.trailingAnchor),
                anim.topAnchor.constraint(equalTo: container.topAnchor),
                anim.bottomAnchor.constraint(equalTo: container.bottomAnchor),
            ])

        case .centered(let size):
            anim.contentMode = .scaleAspectFit
            NSLayoutConstraint.activate([
                anim.centerXAnchor.constraint(equalTo: container.centerXAnchor),
                anim.centerYAnchor.constraint(equalTo: container.centerYAnchor),
                anim.widthAnchor.constraint(equalToConstant: size.width),
                anim.heightAnchor.constraint(equalToConstant: size.height),
            ])
        }

        context.coordinator.anim = anim
        context.coordinator.lastName = name
        context.coordinator.lastPlayID = playID

        anim.currentProgress = 0
        anim.play()

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let anim = context.coordinator.anim else { return }

        let shouldRestart =
            context.coordinator.lastName != name ||
            context.coordinator.lastPlayID != playID

        anim.loopMode = loopMode

        switch layout {
        case .fill: anim.contentMode = .scaleAspectFill
        case .centered: anim.contentMode = .scaleAspectFit
        }

        guard shouldRestart else { return }

        context.coordinator.lastName = name
        context.coordinator.lastPlayID = playID

        anim.animation = LottieAnimation.named(name)
        anim.currentProgress = 0
        anim.play()
    }

    final class Coordinator {
        weak var anim: LottieAnimationView?
        var lastName: String?
        var lastPlayID: UUID?
    }
}

final class WinView: ObservableObject {
    static let defaultLotties: [String] = [
        "Bubble Explosion",
        "Confetti",
        "Confetti Day",
        "Confetti Effects Lottie Animation",
        "Fireworks Silver Golden",
        "Success celebration",
    ]

    private let lotties: [String]
    @Published private(set) var name: String? = nil
    @Published private(set) var playID: UUID = UUID()

    init(lotties: [String] = defaultLotties) {
        self.lotties = lotties
    }

    func trigger() {
        name = lotties.randomElement()
        playID = UUID()
    }

    func reset() {
        name = nil
        playID = UUID()
    }
}

private struct WinLottieOverlayModifier: ViewModifier {
    let isWin: Bool
    let centered: Bool
    @ObservedObject var presenter: WinView

    func body(content: Content) -> some View {
        content
            .onChange(of: isWin) { _, newValue in
                if newValue { presenter.trigger() }
            }
            .overlay(alignment: .center) { 
                if isWin, let name = presenter.name {
                    WinLottieOverlay(name: name, playID: presenter.playID, centered: centered)
                        .zIndex(999)
                }
            }
    }
}

extension View {
    func winLottieOverlay(isWin: Bool, presenter: WinView, centered: Bool = false) -> some View {
        modifier(WinLottieOverlayModifier(isWin: isWin, centered: centered, presenter: presenter))
    }
}


