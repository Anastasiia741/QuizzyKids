//  ResetPasswordView.swift
//  Quizzy Kids

import SwiftUI
import FirebaseAuth

struct ResetPasswordView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authVM: AuthentificationViewModel

    let oobCode: String
    @State private var newPassword = ""
    @State private var confirmPassword = ""

    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()

            VStack(spacing: 0) {
                HeaderView(onBack: { coordinator.pop() }, title: nil)
                Spacer().frame(height: 34)

                Text("Reset Your Password")
                    .font(AppFont.title2())
                    .foregroundColor(.grayscale400)

                VStack(spacing: 12) {
                    AppTextField(text: $newPassword, placeholder: "New password", isSecure: true, hasError: authVM.passwordHasError)
                    AppTextField(text: $confirmPassword, placeholder: "Confirm password", isSecure: true, hasError: authVM.passwordHasError)
                }
                .padding(.horizontal, 20)
                .padding(.top, 22)

                if !authVM.errorMessage.isEmpty {
                    Text(authVM.errorMessage)
                        .font(AppFont.body())
                        .foregroundStyle(.red)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, 20)
                        .padding(.top, 10)
                }

                Button {
                    Task {
//                        _ = await authVM.resetPassword(
//                            oobCode: oobCode,
//                            newPassword: newPassword,
//                            confirmPassword: confirmPassword
//                        )
                    }
                } label: {
                    Text("Reset password")
                }
                .disabled(newPassword.isEmpty || confirmPassword.isEmpty)
                .opacity((newPassword.isEmpty || confirmPassword.isEmpty) ? 0.8 : 1.0)
                .buttonStyle(AppButtonStyle(
                    type: .primary,
                    customTextColor: .black,
                    customBackgroundColor: .primary100,
                    customPressedBackgroundColor: Color.primary100.opacity(0.85),
                    bottomBorderColor: .black
                ))
                .padding(.horizontal, 20)
                .padding(.top, 18)

                Spacer(minLength: 0)
                Image("ui_bg_02").resizable().scaledToFit().frame(maxWidth: .infinity).padding(.bottom, 8)
            }
        }
        .navigationBarBackButtonHidden(true)
        .onChange(of: newPassword) { _, _ in authVM.passwordHasError = false; authVM.errorMessage = "" }
        .onChange(of: confirmPassword) { _, _ in authVM.passwordHasError = false; authVM.errorMessage = "" }
    }
}
