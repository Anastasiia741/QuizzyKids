//  PasswordChangedView.swift
//  Quizzy Kids

import SwiftUI

struct PasswordChangedView: View {
    @EnvironmentObject private var coordinator: AppCoordinator

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer().frame(height: 120)

                Image(systemName: "checkmark")
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: 85, height: 85)
                    .background(Color.message100)
                    .clipShape(Circle())

                Text("Password changed")
                    .font(AppFont.title2())
                    .foregroundColor(.black)
                    .padding(.top, 18)

                Text("Your password has been updated! You can\nnow log in with your new credentials.")
                    .font(AppFont.body())
                    .foregroundStyle(.grayscale400)
                    .multilineTextAlignment(.center)
                    .padding(.top, 10)

                Button {
                    coordinator.popToRoot()
                    coordinator.push(.login)
                } label: {
                    Text("Log in")
                }
                .buttonStyle(
                    AppButtonStyle(
                        type: .primary,
                        customTextColor: .black,
                        customBackgroundColor: .primary100,
                        customPressedBackgroundColor: Color.primary100.opacity(0.85),
                        bottomBorderColor: .black
                    )
                )
                .padding(.horizontal, 64)
                .padding(.top, 22)

                Spacer()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}
