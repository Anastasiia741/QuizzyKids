//  MainTab.swift
//  Quizzy Kids

import SwiftUI

struct MainTabView: View {
    @Binding var selectedIndex: Int
    let icons = [Icons.icon08, Icons.icon03, Icons.icon06, Icons.icon12]
    
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    private var isLarge: Bool { hSizeClass == .regular }
    
    private var circleSize: CGFloat { isLarge ? 62 : 54 }
    private var iconSize: CGFloat { isLarge ? 28 : 24 }
    private var vPad: CGFloat { isLarge ? 16 : 13 }
    private var hPad: CGFloat { isLarge ? 40 : 32 }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(icons.indices, id: \.self) { index in
                tabButton(index: index)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.vertical, vPad)
        .padding(.horizontal, hPad)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 100)
                .fill(.grayscale100)
        )
    }
    
    private func tabButton(index: Int) -> some View {
        let isSelected = selectedIndex == index
        
        return Button {
            selectedIndex = index
        } label: {
            ZStack {
                Circle()
                    .fill(.accent100)
                    .opacity(isSelected ? 1 : 0)
                    .frame(width: circleSize, height: circleSize)
                    .animation(.easeInOut(duration: 0.2), value: selectedIndex)
                
                Image(icons[index].rawValue)
                    .resizable()
                    .renderingMode(.template)
                    .scaledToFit()
                    .frame(width: iconSize, height: iconSize)
                    .foregroundColor(isSelected ? .secondary200 : .gray400)
                    .animation(.easeInOut(duration: 0.2), value: selectedIndex)
            }
            .frame(height: circleSize)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}


struct MainScreen: View {
    @EnvironmentObject private var authVM: AuthentificationViewModel
    @EnvironmentObject private var coordinator: AppCoordinator
    @Environment(\.scenePhase) private var scenePhase
    @State private var selectedIndex: Int = 0
    @State private var pendingMainTabIndexMirror: Int? = nil
    
    var body: some View {
        ZStack {
            Group {
                switch selectedIndex {
                case 0: HomeView()
                case 1: ReadingView()
                case 2: GamesView()
                case 3: SettingsView()
                default: HomeView()
                }
            }
            .transaction { t in
                t.animation = nil
            }
        }
        .overlay(alignment: .bottom) {
            MainTabView(selectedIndex: $selectedIndex)
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
        }
        .onChange(of: selectedIndex) { newIndex, _ in
            guard newIndex == 3 else { return }
            Task {
                await SettingsViewModel.shared.loadProfileIfNeeded(user: authVM.user)
            }
        }
      
        .onAppear {
            AppVisitStreak.registerVisitIfNeeded()
            Task { await LocalNotificationScheduler.shared.bootstrapOnLaunch() }
        }
        .onChange(of: scenePhase) { phase, _ in
            if phase == .active {
                AppVisitStreak.registerVisitIfNeeded()
                Task { await LocalNotificationScheduler.shared.handleSceneBecameActive() }
            }
            if phase == .background {
                Task { await LocalNotificationScheduler.shared.handleSceneDidEnterBackground() }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: .quizzyRewardUnlocked)) { note in
            let count = (note.userInfo?[QuizzyRewardUserInfoKey.countKey] as? Int) ?? 1
            LocalNotificationScheduler.shared.recordRewardEvents(count: count)
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

