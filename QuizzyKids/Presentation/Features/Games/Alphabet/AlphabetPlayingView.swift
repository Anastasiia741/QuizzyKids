//  AlphabetView.swift
//  Quizzy Kids

import SwiftUI
import AVFoundation

struct AlphabetPlayingView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = AlphabetViewModel()

    @State private var showBack = false
    @State private var isSoundMuted = false

    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 6)

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.white.ignoresSafeArea()

            if let selected = vm.selectedItem {
                VStack(spacing: 18) {
                    HStack(spacing: 12) {
                        Text(selected.letter)
                            .font(AppFont.marker(88))
                            .foregroundStyle(.secondary200)

                        Image(selected.image.rawValue)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 190, height: 190)
                    }
                    .frame(maxWidth: .infinity, alignment: .center)

                    Button { vm.playWord() } label: {
                        Text(vm.typedWord)
                            .font(AppFont.marker(34))
                            .foregroundStyle(.black)
                            .lineLimit(1)
                            .minimumScaleFactor(0.75)
                            .frame(maxWidth: .infinity, alignment: .center)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(!vm.isSoundOn)
                }
                .padding(.top, 40)
                .padding(.bottom, 20)

                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .center
                )
                            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { showBack = true },
                title: "Alphabet",
                showsTitle: true,
                rightAssetIcon: isSoundMuted ? "ui_icons_16" : "ui_icons_15",
                onRightTap: {
                    isSoundMuted.toggle()
                }
            )
        }
        .safeAreaInset(edge: .bottom, spacing: 0) {
            BottomView(
                options: Array(vm.items.indices),
                selected: vm.selectedItem.flatMap { s in vm.items.firstIndex(where: { $0.id == s.id }) },
                onTap: { i in vm.select(vm.items[i]) }, content: { i in .text(vm.items[i].letter) },
            )
//            .padding(.bottom, -geo.safeAreaInsets.bottom)

            }
        .task {
            vm.startFirstLetter()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
        .confirmAlert(isPresented: $showBack, text: "Exit the game?", showsAvatar: false) {
            coordinator.pop()
        }
    }

}
