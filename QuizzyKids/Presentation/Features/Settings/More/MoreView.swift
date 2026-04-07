//  MoreView.swift
//  Quizzy Kids

import SwiftUI

struct MoreView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authVM: AuthentificationViewModel
    @StateObject private var vm = SettingsViewModel.shared
    @State private var showDeleteAlert = false
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 12) {
                SettingsRow(title: "Change password", trailing: .chevron { coordinator.push(.changePassword) })
                SettingsRow(title: "Privacy policy", trailing: .chevron { coordinator.push(.privacyPolicy) })
                SettingsRow(title: "Terms of use", trailing: .chevron { coordinator.push(.termsOfUse) })
                SettingsRow(title: "Delete account", trailing: .chevron { showDeleteAlert = true })
               Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            if authVM.authenticationState == .authenticating {
                Color.black.opacity(0.12).ignoresSafeArea()
                ProgressView().tint(.black).scaleEffect(1.3)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { coordinator.pop() },
                title: "More",
                showsTitle: true,
            )
        }
        .navigationBarBackButtonHidden(true)
        .confirmAlert(
            isPresented: $showDeleteAlert,
            text: "Are you sure you want\nto delete account?",
            showsAvatar: true
        ) {
            Task {
                let ok = await authVM.deleteAccount()
                if ok {
                    coordinator.path = [.login]
                } else {
                    if authVM.errorMessage.contains("log in again") {
                        coordinator.path = [.login]
                    }
                }
            }
        }
    }
}


