//  SettingsView.swift
//  Quizzy Kids

import SwiftUI
import FirebaseAuth

struct SettingsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @EnvironmentObject private var authVM: AuthentificationViewModel
    @StateObject private var vm = SettingsViewModel.shared
    @State private var showLogoutAlert = false
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
                VStack(spacing: 12) {
                    SettingsRow(title: "Profile", trailing: .chevron { coordinator.push(.profile) })
                    SettingsRow(title: "Achievements", trailing: .chevron { coordinator.push(.achievements) })
                    SettingsRow(title: "Notifications", trailing: .toggle(isOn: $vm.notificationsOn))
                    SettingsRow(title: "More", trailing: .chevron { coordinator.push(.more) })
                    SettingsRow(title: "Log out", trailing: .chevron { showLogoutAlert = true })
                }
                .padding(.horizontal, 20)
                .frame(maxWidth: .infinity, alignment: .top)
        }
        .safeAreaInset(edge: .top) {
            ProfileHeader(
                name: vm.profile?.name ?? authVM.user?.displayName ?? "—",
                bonuses: vm.profile?.bonuses ?? 100
            )
        }
        .onAppear {
            Task {
                await vm.loadProfileIfNeeded(user: authVM.user)
            }
        }
        .onChange(of: coordinator.path.count) { oldCount, newCount in
            guard newCount < oldCount else { return }
            Task {
                await vm.loadProfileIfNeeded(user: authVM.user)
            }
        }
        .confirmAlert(
            isPresented: $showLogoutAlert,
            text: "Are you sure you want to log out?",
            showsAvatar: false
        ) {
            let ok = authVM.signOut()
               if ok {
                   coordinator.path = [.login]
                 coordinator.dismissSheet()
               }
        }
    }
}


