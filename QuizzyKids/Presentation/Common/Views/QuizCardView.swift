//  QuizCardView.swift
//  Quizzy Kids

import SwiftUI

enum QuizCardAlignment {
    case left
    case right
}

struct QuizCardView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let backgroundImage: String
    let route: AppRoute?
    let buttonType: AppButtonStyleType
    let buttonText: String
    let alignment: QuizCardAlignment

    let onTap: (() -> Void)?
    let titleText: String?

    let cardImage: String?
    let cardImageSide: QuizCardAlignment?
    let cardImageSize: CGSize

    init(
        backgroundImage: String,
        buttonType: AppButtonStyleType,
        buttonText: String,
        alignment: QuizCardAlignment,
        route: AppRoute? = nil,
        onTap: (() -> Void)? = nil,
        titleText: String? = nil,
        cardImage: String? = nil,
        cardImageSide: QuizCardAlignment? = nil,
        cardImageSize: CGSize = CGSize(width: 120, height: 120)
    ) {
        self.backgroundImage = backgroundImage
        self.buttonType = buttonType
        self.buttonText = buttonText
        self.alignment = alignment
        self.route = route
        self.onTap = onTap
        self.titleText = titleText
        self.cardImage = cardImage
        self.cardImageSide = cardImageSide
        self.cardImageSize = cardImageSize
    }

    private var resolvedImageSide: QuizCardAlignment {
        cardImageSide ?? (alignment == .left ? .right : .left)
    }

    var body: some View {
        ZStack {
            Image(backgroundImage)
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()
                .clipShape(RoundedRectangle(cornerRadius: 32, style: .continuous))

            if let cardImage {
                HStack {
                    if resolvedImageSide == .left {
                        cardImageView(cardImage)
                        Spacer()
                    } else {
                        Spacer()
                        cardImageView(cardImage)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .allowsHitTesting(false)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .overlay(alignment: alignment == .left ? .bottomLeading : .bottomTrailing) {
            Button {
                if let onTap {
                    onTap()
                } else if let route {
                    coordinator.push(route)
                }
            } label: {
                Text(buttonText)
                    .font(AppFont.caption2())
                    .foregroundColor(.grayscale400)
            }
            .buttonStyle(AppButtonStyle(type: buttonType))
            .frame(width: 117)
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }

    private func cardImageView(_ name: String) -> some View {
        Image(name)
            .resizable()
            .scaledToFit()
            // без жестких размеров: только мягкое ограничение, чтобы не раздувало
            .frame(maxWidth: cardImageSize.width, maxHeight: cardImageSize.height)
            .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
            .overlay {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(.grayscale300, lineWidth: 1)
            }
    }
}
