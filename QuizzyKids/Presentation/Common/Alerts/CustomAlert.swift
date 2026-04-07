//  CustomAlert.swift
//  Quizzy Kids

import SwiftUI

private struct AlertOverlayModifier<AlertContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let onBackgroundTap: () -> Void
    let alertContent: () -> AlertContent
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black.opacity(0.25)
                    .ignoresSafeArea()
                    .onTapGesture {
                        isPresented = false
                        onBackgroundTap()
                    }
                
                alertContent()
                    .padding(.horizontal, 24)
            }
        }
        .animation(.easeInOut(duration: 0.18), value: isPresented)
    }
}

enum CustomAlertButtonLayout {
    case squareGrid
    case confirmYesNo
}

struct CustomAlert: View {
    struct Action: Identifiable {
        let id = UUID()
        let title: String
        let type: AppButtonStyleType
        let handler: () -> Void
    }

    let text: String
    var showsAvatar: Bool = false
    var avatarImageName: String? = nil
    var buttonLayout: CustomAlertButtonLayout = .squareGrid
    var actions: [Action] = []

    @AppStorage(AvatarStorage.key) private var profileAvatarAsset: String = Avatar.avatar01.rawValue

    private var resolvedAvatarImageName: String {
        if let override = avatarImageName, !override.isEmpty {
            return override
        }
        let stored = profileAvatarAsset
        return stored.isEmpty ? Avatar.avatar01.rawValue : stored
    }

    var body: some View {
        VStack(spacing: 18) {
            if showsAvatar {
                Image(resolvedAvatarImageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 54, height: 54)
                    .clipShape(Circle())
            }

            Text(text)
                .font(AppFont.headline())
                .foregroundColor(.black)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 24)
                .padding(.top, showsAvatar ? 0 : 8)

            if buttonLayout == .confirmYesNo, actions.count >= 2 {
                ConfirmYesNoButtonRow(
                    noTitle: actions[0].title,
                    yesTitle: actions[1].title,
                    onNo: actions[0].handler,
                    onYes: actions[1].handler
                )
            } else {
                HStack(spacing: 12) {
                    ForEach(actions.prefix(2)) { action in
                        Button(action: action.handler) {
                            Text(action.title)
                                .frame(height: 52)
                        }
                        .buttonStyle(
                            AppButtonStyle(
                                type: action.type,
                                customPressedBackgroundColor: Color.primary100.opacity(0.85),
                                useSquareAlertShape: true
                            )
                        )
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
        .padding(.top, 20)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .frame(width: 320)
    }
}

private struct ConfirmYesNoButtonRow: View {
    let noTitle: String
    let yesTitle: String
    let onNo: () -> Void
    let onYes: () -> Void

    private let corner: CGFloat = 12
    private let depth: CGFloat = 3
    private let buttonWidth: CGFloat = 108
    private let buttonHeight: CGFloat = 46

    var body: some View {
        HStack(spacing: 12) {
            Spacer(minLength: 0)

            Button(action: onNo) {
                Text(noTitle)
                    .font(AppFont.caption2())
                    .foregroundColor(.primary100)
                    .frame(width: buttonWidth, height: buttonHeight)
                    .background(Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: corner, style: .continuous)
                            .stroke(Color.primary100, lineWidth: 2)
                    )
            }
            .buttonStyle(ConfirmAlertPlainPressStyle())

            Button(action: onYes) {
                ZStack {
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .fill(Color.grayscale400)
                        .offset(y: depth)
                    RoundedRectangle(cornerRadius: corner, style: .continuous)
                        .fill(Color.primary100)
                    Text(yesTitle)
                        .font(AppFont.caption2())
                        .foregroundColor(.grayscale400)
                }
                .frame(width: buttonWidth, height: buttonHeight)
                .compositingGroup()
            }
            .buttonStyle(ConfirmAlertPrimary3DPressStyle(depth: depth))

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 20)
    }
}

private struct ConfirmAlertPlainPressStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.97 : 1)
            .animation(.easeOut(duration: 0.1), value: configuration.isPressed)
    }
}

private struct ConfirmAlertPrimary3DPressStyle: ButtonStyle {
    let depth: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .offset(y: configuration.isPressed ? depth * 0.45 : 0)
            .animation(.easeOut(duration: 0.12), value: configuration.isPressed)
    }
}

struct AlertCard<Content: View>: View {
    let maxWidth: CGFloat
    let content: Content
    
    init(maxWidth: CGFloat = 340, @ViewBuilder content: () -> Content) {
        self.maxWidth = maxWidth
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            content
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22))
        .frame(maxWidth: maxWidth)
    }
}

extension View {
    fileprivate func alertOverlay<AlertContent: View>(isPresented: Binding<Bool>, onBackgroundTap: @escaping () -> Void = {}, @ViewBuilder content: @escaping () -> AlertContent) -> some View {
        modifier(
            AlertOverlayModifier(
                isPresented: isPresented,
                onBackgroundTap: onBackgroundTap,
                alertContent: content
            )
        )
    }
}


extension View {
    func confirmAlert(isPresented: Binding<Bool>, text: String, showsAvatar: Bool = false, avatarImageName: String? = nil, onNo: @escaping () -> Void = {}, onYes: @escaping () -> Void) -> some View {
        alertOverlay(isPresented: isPresented, onBackgroundTap: {
            isPresented.wrappedValue = false
            onNo()
        }) {
            CustomAlert(
                text: text,
                showsAvatar: showsAvatar,
                avatarImageName: avatarImageName,
                buttonLayout: .confirmYesNo,
                actions: [
                    .init(title: "No", type: .transparent, handler: {
                        isPresented.wrappedValue = false
                        onNo()
                    }),
                    .init(title: "Yes", type: .primary, handler: {
                        isPresented.wrappedValue = false
                        onYes()
                    })
                ]
            )
        }
    }
    
    func customTwoButtonAlert(
        isPresented: Binding<Bool>,
        text: String,
        showsAvatar: Bool = false,
        avatarImageName: String? = nil,
        leftTitle: String,
        rightTitle: String,
        leftType: AppButtonStyleType = .transparent,
        rightType: AppButtonStyleType = .primary,
        onLeft: @escaping () -> Void,
        onRight: @escaping () -> Void
    ) -> some View {
        alertOverlay(isPresented: isPresented, onBackgroundTap: {
            isPresented.wrappedValue = false
        }) {
            CustomAlert(
                text: text,
                showsAvatar: showsAvatar,
                avatarImageName: avatarImageName,
                actions: [
                    .init(title: leftTitle, type: leftType, handler: {
                        isPresented.wrappedValue = false
                        onLeft()
                    }),
                    .init(title: rightTitle, type: rightType, handler: {
                        isPresented.wrappedValue = false
                        onRight()
                    })
                ]
            )
        }
    }
    
    func singleAlert(isPresented: Binding<Bool>, text: String, buttonTitle: String = "Back", showsAvatar: Bool = false, avatarImageName: String? = nil, onClose: @escaping () -> Void) -> some View {
        alertOverlay(isPresented: isPresented, onBackgroundTap: {
            isPresented.wrappedValue = false
            onClose()
        }) {
            CustomAlert(
                text: text,
                showsAvatar: showsAvatar,
                avatarImageName: avatarImageName,
                actions: [
                    .init(title: buttonTitle, type: .primary, handler: {
                        isPresented.wrappedValue = false
                        onClose()
                    })
                ]
            )
        }
    }
    
    func pauseAlert(isPresented: Binding<Bool>, onAction: @escaping (PauseAlert.Action) -> Void) -> some View {
        alertOverlay(isPresented: isPresented) {
            PauseAlert { action in
                isPresented.wrappedValue = false
                onAction(action)
            }
        }
    }
    
    func completedAlert(isPresented: Binding<Bool>, message: String, onRestart: @escaping () -> Void, onContinue: @escaping () -> Void, onExit: @escaping () -> Void ) -> some View {
        alertOverlay(isPresented: isPresented) {
            CompletedAlert(
                message: message,
                onRetry: {
                    isPresented.wrappedValue = false
                    onRestart()
                },
                onContinue: {
                    isPresented.wrappedValue = false
                    onContinue()
                },
                onExit: {
                    isPresented.wrappedValue = false
                    onExit()
                }
            )
        }
    }
    
    func oneStarDownAlert(isPresented: Binding<Bool>, starsCount: Int, totalStars: Int, message: String, onRestart: @escaping () -> Void, onNext: @escaping () -> Void, onExit: @escaping () -> Void ) -> some View {
        alertOverlay(isPresented: isPresented) { OneStarDownAlert(
            starsCount: starsCount,
            totalStars: totalStars,
            message: message,
            onRetry: {
                isPresented.wrappedValue = false
                onRestart()
            },
            onContinue: {
                isPresented.wrappedValue = false
                onNext()
            },
            onExit: {
                isPresented.wrappedValue = false
                onExit()
            }
        )
        }
    }
    
    func optionsAlert(isPresented: Binding<Bool>, sound: Binding<Double>, music: Binding<Double>, onClose: @escaping () -> Void) -> some View {
        alertOverlay(isPresented: isPresented, onBackgroundTap: onClose) {
            OptionsAlert(
                sound: sound,
                music: music,
                onClose: {
                    isPresented.wrappedValue = false
                    onClose()
                }
            )
        }
    }
}
