//  AppButtonStyle.swift
//  Quizzy Kids

import SwiftUI
import Kingfisher

enum AppButtonStyleType {
    case primary
    case secondary
    case outline
    case transparent
    case social
}

struct AppButtonStyle: ButtonStyle {
    let type: AppButtonStyleType
    
    var customTextColor: Color?
    var customBackgroundColor: Color?
    var customPressedBackgroundColor: Color?
    var bottomBorderColor: Color = .grayscale400
    var useSquareAlertShape: Bool = false

    func makeBody(configuration: Configuration) -> some View {
        let isPressed = configuration.isPressed
        
        switch type {
        case .social:
            return AnyView(
                configuration.label
                    .font(AppFont.body2())
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 42)
                    .background(Color.white)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .stroke(Color.black.opacity(0.7), lineWidth: 1)
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                    .scaleEffect(isPressed ? 0.98 : 1.0)
                    .animation(.easeOut(duration: 0.1), value: isPressed)
            )
            
        default:
            if useSquareAlertShape {
                return AnyView(
                    configuration.label
                        .font(AppFont.caption2())
                        .foregroundColor(foregroundColor)
                        .multilineTextAlignment(.center)
                        .minimumScaleFactor(0.8)
                        .lineLimit(2)
                        .padding(10)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(background(isPressed: isPressed))
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .scaleEffect(isPressed ? 0.98 : 1.0)
                        .animation(.easeOut(duration: 0.1), value: isPressed)
                )
            }
            return AnyView(
                configuration.label
                    .font(AppFont.caption2())
                    .foregroundColor(foregroundColor)
                    .padding(.vertical, 11)
                    .frame(maxWidth: .infinity)
                    .background(background(isPressed: isPressed))
                    .animation(.easeOut(duration: 0.1), value: isPressed)
                    .cornerRadius(12)
                    .background(
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(bottomBorderColor)
                    )
                    .shadow(color: Color.black, radius: 4, x: 0, y: 4)
                    .scaleEffect(isPressed ? 0.98 : 1.0)
                    .animation(.easeOut(duration: 0.1), value: isPressed)
            )
        }
    }
    
    private var foregroundColor: Color {
        if let customTextColor { return customTextColor }
        
        switch type {
        case .primary, .secondary:
            return .grayscale400
        case .outline, .transparent:
            return .primary100
        case .social:
            return .grayscale400
        }
    }
    
    private func background(isPressed: Bool) -> Color {
        if let customBackgroundColor, let customPressedBackgroundColor {
            return isPressed ? customPressedBackgroundColor : customBackgroundColor
        }
        
        switch type {
        case .primary:
            return isPressed ? Color.primary100.opacity(0.8) : .primary100
        case .secondary:
            return isPressed ? Color.secondary100.opacity(0.8) : .secondary100
        case .outline:
            return .clear
        case .transparent:
            return .white
        case .social:
            return .grayscale400
        }
    }
}

enum CircleButtonContent: Equatable {
    case image(String)
    case text(String)
    /// Плейсхолдер без текста (например, пока нет URL в кэше).
    case empty
}


struct CircleButton: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    let content: CircleButtonContent
    let isSelected: Bool
    let action: () -> Void
    var size: CGFloat = 64
    
    private var isPadLike: Bool {
        (hSizeClass == .regular) || (UIDevice.current.userInterfaceIdiom == .pad)
    }
    
    private var textSize: CGFloat { isPadLike ? 36 : 32 }
    
    var body: some View {
        Button(action: action) {
            Group {
                switch content {
                    
                case .image(let name):
                    VStack {
                        imageView(from: name)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? .primary100 : Color.clear, lineWidth: 2)
                            )
                            .background(isSelected ? Color.white : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(width: size, height: size)
                    
                case .text(let title):
                    ZStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(isSelected ? Color.white : Color.clear)
                        Text(title)
                            .font(AppFont.marker(textSize))
                            .foregroundStyle(isSelected ? .grayscale400 : .primary100)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .padding(6)
                        
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .strokeBorder(isSelected ? .primary100 : Color.clear, lineWidth: 2)
                    }

                case .empty:
                    VStack {
                        RoundedRectangle(cornerRadius: 12, style: .continuous)
                            .fill(Color.white.opacity(0.35))
                            .frame(width: 54, height: 54)
                            .padding(12)
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(isSelected ? .primary100 : Color.clear, lineWidth: 2)
                            )
                            .background(isSelected ? Color.white : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .frame(width: size, height: size)
                }
            }
        }
        .buttonStyle(.plain)
        .disabled(content == .empty)
    }
    
    @ViewBuilder
    private func imageView(from name: String) -> some View {
        if let url = URL(string: name), url.scheme != nil {
            KFImage(url)
                .resizable()
                .scaledToFit()
                .frame(width: 54, height: 54)
        } else {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 54, height: 54)
        }
    }
}
