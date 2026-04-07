//  ChangePasswordView.swift
//  Quizzy Kids

import SwiftUI

struct ChangePasswordView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = SettingsViewModel.shared
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var alertText = ""
    @State private var showAlert = false
    @State private var passwordChanged = false
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 12) {
                VStack(spacing: 12) {
                    AppTextField(
                        text: $newPassword,
                        placeholder: "New password",
                        isSecure: true,
                        showsSecureToggle: true
                    )
                    
                    AppTextField(
                        text: $confirmPassword,
                        placeholder: "Confirm password",
                        isSecure: true,
                        showsSecureToggle: true
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                Spacer()
                Button {
                    Task { await onChangePasswordTap() }
                } label: {
                    Text(vm.isChangingPassword ? "Changing..." : "Change password")
                }
                .disabled(vm.isChangingPassword)
                .buttonStyle(
                    AppButtonStyle(
                        type: .primary,
                        customTextColor: .black,
                        customBackgroundColor: .primary100,
                        customPressedBackgroundColor: Color.primary100.opacity(0.8)
                    )
                )
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { coordinator.pop() },
                title: "Change password",
                showsTitle: true
            )
        }
        .navigationBarBackButtonHidden(true)
        .singleAlert(
            isPresented: $showAlert,
            text: alertText,
            buttonTitle: "Back",
            onClose: {
                if passwordChanged {
                    coordinator.pop()
                }
            }
        )
    }
    
    @MainActor
    private func onChangePasswordTap() async {
        guard !newPassword.isEmpty, !confirmPassword.isEmpty else {
            alertText = "Please fill in both fields"
            showAlert = true
            return
        }
        guard newPassword == confirmPassword else {
            alertText = "Passwords do not match"
            showAlert = true
            return
        }
        guard newPassword.count >= 6 else {
            alertText = "Password must be at least 6 characters"
            showAlert = true
            return
        }
        
        let success = await vm.changePassword(to: newPassword)
        if success {
            passwordChanged = true
            alertText = "Password changed successfully"
            showAlert = true
        } else {
            passwordChanged = false
            alertText = vm.passwordChangeErrorText ?? "Failed to change password"
            showAlert = true
        }
    }
}
