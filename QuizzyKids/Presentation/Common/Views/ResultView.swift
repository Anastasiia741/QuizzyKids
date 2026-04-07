//  TimeUpOverlay.swift
//  Quizzy Kids

import SwiftUI

struct ResultView: View {
    let placedCount: Int
    let totalCount: Int

    let title: String
    let message: String

    let lottieName: String?
    let lottiePlayID: UUID?

    let onRetry: () -> Void
    let onContinue: () -> Void
    let onExit: () -> Void

    @State private var showCard: Bool = false

    private var progress: CGFloat {
        guard totalCount > 0 else { return 0 }
        return CGFloat(placedCount) / CGFloat(totalCount)
    }

    var body: some View {
        ZStack {
            Color.black.opacity(0.25).ignoresSafeArea()

            if let name = lottieName, let playID = lottiePlayID, !showCard {
                WinLottieOverlay(name: name, playID: playID)
                    .ignoresSafeArea()
                    .allowsHitTesting(false)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                showCard = true
                            }
                        }
                    }
            }

            if showCard || lottieName == nil {
                ZStack(alignment: .bottom) {
                    VStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .stroke(.primary100.opacity(0.3), lineWidth: 10)

                            Circle()
                                .trim(from: 0, to: progress)
                                .stroke(
                                    .primary100,
                                    style: StrokeStyle(lineWidth: 10, lineCap: .round)
                                )
                                .rotationEffect(.degrees(-90))

                            Image("ui_icons_13")
                        }
                        .frame(width: 93, height: 93)
                        .padding(.top, 2)

                        Text(title)
                            .font(AppFont.title2())
                            .foregroundStyle(.grayscale400)

                        Text(message)
                            .font(AppFont.title2())
                            .foregroundStyle(.grayscale400)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 20)

                        Color.clear.frame(height: 36)
                    }
                    .padding(.top, 18)
                    .padding(.bottom, 44)
                    .background(Color.white)
                    .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))

                    HStack(spacing: 12) {
                        IconButton(
                            systemName: "arrow.counterclockwise",
                            background: .secondary200,
                            action: onRetry,
                            size: CGSize(width: 50, height: 50)
                        )

                        IconButton(
                            systemName: "play.fill",
                            background: .primary100,
                            action: onContinue,
                            size: CGSize(width: 64, height: 64)
                        )

                        IconButton(
                            systemName: "xmark",
                            background: .secondary200,
                            action: onExit,
                            size: CGSize(width: 50, height: 50)
                        )
                    }
                    .offset(y: 22)
                }
                .padding(.horizontal, 28)
                .padding(.bottom, 22)
                .transition(.opacity)
            }
        }
        .onAppear {
            if lottieName == nil { showCard = true }
        }
    }
}

private struct IconButton: View {
    let systemName: String
    let background: Color
    let action: () -> Void
    var size: CGSize = CGSize(width: 52, height: 52)

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: 24))
                .frame(width: size.width, height: size.height)
                .background(background)
                .foregroundStyle(.white)
                .clipShape(
                    RoundedRectangle(cornerRadius: 14, style: .continuous)
                )
        }
    }
}
