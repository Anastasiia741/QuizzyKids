//  CompletedAlert.swift
//  Quizzy Kids

import SwiftUI

struct CompletedAlert: View {
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
            RoundedRectangle(cornerRadius: 22)
                .fill(Color.white)

            VStack(spacing: 0) {
                Spacer().frame(height: 110)

                HStack(spacing: 8) {
                    Text("+ 2")
                        .font(AppFont.title2())
                        .foregroundColor(.black)

                    Image(Icons.icon13.rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 34, height: 34)
                }
                .padding(.horizontal, 18)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.accent100.opacity(0.35))
                )

                Text(message)
                    .font(AppFont.title3())
                    .foregroundColor(.black)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 24)
                    .padding(.top, 22)

                Spacer().frame(height: 52)
            }
            .padding(.horizontal, 28)
            .padding(.bottom, 22)
            topDecoration
                .offset(y: -46)
        }
        .frame(height: 320)
    }
  
    private var topDecoration: some View {
        ZStack {
            Image(Shapes.shape11.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 92)
                .offset(y: -18)

            Image(Shapes.shape12.rawValue)
                .resizable()
                .scaledToFit()
                .frame(width: 280, height: 74)
                .offset(y: 46)
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
