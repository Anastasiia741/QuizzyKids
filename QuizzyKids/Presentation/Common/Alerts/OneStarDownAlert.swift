//  CompletedAlert.swift
//  Quizzy Kids

import SwiftUI

struct OneStarDownAlert: View {
    let starsCount: Int
    let totalStars: Int
    let message: String
    let onRetry: () -> Void
    let onContinue: () -> Void
    let onExit: () -> Void

    var body: some View {
        VStack(spacing: -32) {
            card

            buttons
        }
        .frame(width: 365)
    }

    private var card: some View {
        ZStack(alignment: .top) {
            VStack(spacing: 0) {
                Spacer().frame(height: 32)

                CompletedAlertBonusRing(
                    currentBonuses: starsCount,
                    bonusCap: totalStars
                )
                .padding(.vertical, 10)

                Text(message)
                    .font(AppFont.title3())
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 18)

                Spacer().frame(height: 52)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 22)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22))
        }
    }

    private var buttons: some View {
        HStack(spacing: 12) {
            CompletedAlertSquareIconButton(
                systemName: "arrow.counterclockwise",
                background: .secondary200,
                size: CGSize(width: 50, height: 50),
                action: onRetry
            )

            CompletedAlertSquareIconButton(
                systemName: "play.fill",
                background: .primary100,
                size: CGSize(width: 64, height: 64),
                action: onContinue
            )

            CompletedAlertSquareIconButton(
                systemName: "xmark",
                background: .secondary200,
                size: CGSize(width: 50, height: 50),
                action: onExit
            )
        }
    }
}

private struct CompletedAlertBonusRing: View {
    let currentBonuses: Int
    let bonusCap: Int

    private var progress: CGFloat {
        let cap = max(1, bonusCap)
        let v = max(0, currentBonuses)
        return min(1, CGFloat(v) / CGFloat(cap))
    }

    private let iconSide: CGFloat = 36
    private var ringSize: CGFloat { iconSide + 43 }

    var body: some View {
        ZStack {
            Circle()
                .stroke(.colorF9E9E7, lineWidth: 5)
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    Color.primary100,
                    style: StrokeStyle(lineWidth: 5, lineCap: .round)
                )
                .rotationEffect(.degrees(-90))
            Image(Icons.icon13.rawValue)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundColor(.primary100)
                .frame(width: iconSide, height: iconSide)
        }
        .frame(width: ringSize, height: ringSize)
    }
}

struct CompletedAlertSquareIconButton: View {
    let systemName: String
    let background: Color
    let size: CGSize
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .font(.system(size: min(size.width, size.height) * 0.34, weight: .bold))
                .foregroundStyle(Color.white)
                .frame(width: size.width, height: size.height)
                .background(
                    RoundedRectangle(cornerRadius: 12, style: .continuous)
                        .fill(background)
                )
        }
        .buttonStyle(.plain)
    }
}

