//  NumberKnowledgePlayingView.swift
//  Quizzy Kids

import SwiftUI

struct NumbersSoundView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = NumbersViewModel()
    @StateObject private var winPresenter = WinView()
    @State private var isWin = false
    
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 10), count: 5)
    private let fruitsColumns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 3)
    
    @State private var showBack = false
    private var isSoundMuted: Bool { !vm.isSoundOn }
    
    let levelId: Int
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.accent100.ignoresSafeArea()
            
            if let selected = vm.selectedItem {
                VStack(spacing: 18) {
                    HStack(alignment: .center, spacing: 12) {
                        LazyVGrid(
                            columns: Array(repeating: GridItem(.fixed(50)), count: 3),) {
                                ForEach(0..<selected.value, id: \.self) { _ in
                                    Image(selected.imageFruits.rawValue)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                            }
                            .frame(width: 50*3 + 8*2, height: 50*3 + 8*2, alignment: .center)
                        
                        Button { vm.playNumber() } label: {
                            Text("\(selected.value)")
                                .font(AppFont.marker(80))
                                .foregroundStyle(.secondary200)
                                .frame(width: 120, height: 120)
                        }
                        .buttonStyle(.plain)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)
                    
                    Button { vm.playNumber() } label: {
                        Text(vm.typedWord)
                            .font(AppFont.marker(60))
                            .foregroundStyle(.secondary200)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .frame(height: 70)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.top, 24)
                .padding(.bottom, 260)
                .animation(.easeInOut(duration: 0.22), value: selected.value)
            }
            
//            BottomView(
//                style: .numbers,
//                numberAssets: vm.items
//                    .map {
//                        $0.imageDigit.rawValue
//                    },
//                isSelected: {
//                    i in vm.items[i].id == vm.selectedItem?.id
//                },
//                onTap: { i in
//                    vm
//                        .userSelect(
//                            vm.items[i]
//                        )
//                }
//            )
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomView(
                options: Array(vm.items.indices),
                selected: vm.selectedItem.flatMap { selected in
                    vm.items.firstIndex(where: { $0.id == selected.id })
                },
                onTap: { i in
                    vm.userSelect(vm.items[i])
                }, content: { i in
                        .image(vm.items[i].imageDigit.rawValue)
                },
            )
        }

        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: {
                    showBack = true
                },
                title: "Number knowledge",
                showsTitle: true,
                rightAssetIcon: isSoundMuted ? "ui_icons_16" : "ui_icons_15",
                onRightTap: {
                    vm
                        .toggleSound()
                }
            )
        }
        .task { vm.startFirstNumber() }
        .onChange(of: vm.didFinishLevel) { _, finished in
            guard finished else { return }
            
            NumbersProgress.completedLevel = true
            NumbersProgress.unlockedLevel = max(NumbersProgress.unlockedLevel, 2)
            isWin = true
            
            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 2_200_000_000)
                isWin = false
                coordinator.pop()
            }
        }
        .winLottieOverlay(isWin: isWin, presenter: winPresenter)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .confirmAlert(
            isPresented: $showBack,
            text: "Exit the game?",
            showsAvatar: false
        ) {
            coordinator.pop()
        }
    }
}


