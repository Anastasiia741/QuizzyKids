//  PuzzlePlayingView.swift
//  Quizzy Kids

import SwiftUI

struct PuzzlePlayingView: View {
    private let images = ["games_puzzle_01", "games_puzzle_02", "games_puzzle_03", "games_puzzle_04"]
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = PicturePuzzleViewModel()
    @StateObject private var winView = WinView()
    @Namespace private var piecesNS

    let title: String
    let imageName: String
    let pieces: Int

    @State private var realBoardRect: CGRect = .zero
    @State private var showBack = false
    @State private var showPause = false

    var body: some View {
        GeometryReader { geo in
            let headerH: CGFloat = 120
            let trayH: CGFloat = 160

            let boardSide = max(
                220,
                min(geo.size.width - 40, geo.size.height - headerH - trayH - 40)
            )
            let boardRect = CGRect(
                x: (geo.size.width - boardSide) / 2,
                y: headerH + 12,
                width: boardSide,
                height: boardSide
            )

            let bigSize = CGSize(
                width: boardSide / CGFloat(max(vm.cols, 1)),
                height: boardSide / CGFloat(max(vm.rows, 1))
            )

            ZStack {
                Color.accent100.ignoresSafeArea()
                VStack(spacing: 0) {
                    Spacer(minLength: 0)
                    boardView(
                        boardSide: boardSide,
                        boardRect: boardRect,
                        bigSize: bigSize
                    )
                    Text("00:\(String(format: "%02d", vm.remainingSeconds))")
                        .font(AppFont.body2())
                        .foregroundStyle(
                            vm.remainingSeconds == 0
                                ? .secondary200 : .grayscale400
                        )
                        .padding(.top, 10)
                    Spacer(minLength: 0)
                    trayView(
                        boardRect: boardRect,
                        bigSize: bigSize,
                        trayH: trayH
                    )
                    .frame(height: trayH)
                    .frame(maxWidth: .infinity)
                }
            }
           
            .safeAreaInset(edge: .top, spacing: 12) {
                HeaderView(showsBack: true,
                    onBack: {
                        vm.pauseTimer()
                        showBack = true
                    }, title: title,
                    showsTitle: true,
                    rightAssetIcon: showPause ? "ui_icons_11" : "ui_icons_10",
                    onRightTap: {
                        vm.pauseTimer()
                        showPause = true
                    }
                )
            }
            .coordinateSpace(name: "root")
            .navigationBarBackButtonHidden(true)
            .task {
                vm.start(imageName: imageName, piecesCount: pieces)
            }
            .onChange(of: vm.state) { _, newState in
                if newState == .win { winView.trigger() }
            }
            .onDisappear {
                vm.stop()
            }

            .confirmAlert(
                isPresented: $showBack,
                text: "Exit the game?",
                showsAvatar: false,
                onNo: { vm.resumeTimer() }
            ) {
                vm.stop()
                coordinator.pop()
            }
            .singleAlert(
                isPresented: $showPause,
                text: "Pause",
                buttonTitle: "Back to game",
                showsAvatar: false,
                onClose: { vm.resumeTimer() }
            )

            if vm.state == .win {
                ResultView(
                    placedCount: vm.pieces.filter { $0.placedIndex != nil }
                        .count,
                    totalCount: vm.pieces.count,
                    title: "Great job!",
                    message: "You completed the puzzle!",
                    lottieName: winView.name,
                    lottiePlayID: winView.playID,
                    onRetry: { vm.retrySame() },
                    onContinue: {
                        let nextPieces = vm.nextPiecesCount()
                        let nextImage = vm.nextImageName(from: images)
                        vm.start(imageName: nextImage, piecesCount: nextPieces)
                    },
                    onExit: {
                        vm.stop()
                        coordinator.pop()
                    }
                )
                .id(winView.playID)
                .zIndex(999)
            }
            if vm.state == .lose {
                ResultView(
                    placedCount: vm.pieces.filter { $0.placedIndex != nil }
                        .count,
                    totalCount: vm.pieces.count,
                    title: "Time’s up!",
                    message: "You gave it your best. Let’s try again.",
                    lottieName: nil,
                    lottiePlayID: nil, 
                    onRetry: { vm.retrySame() },
                    onContinue: { vm.continueAfterLose(extraSeconds: 15) },
                    onExit: {
                        vm.stop()
                        coordinator.pop()
                    }
                )
                .zIndex(999)
            }
        }
    }

    @ViewBuilder
    private func boardView(
        boardSide: CGFloat,
        boardRect: CGRect,
        bigSize: CGSize
    ) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.white.opacity(0.35))
                .overlay {
                    RoundedRectangle(cornerRadius: 28, style: .continuous)
                        .stroke(.grayscale300, lineWidth: 1)
                }

            ForEach(vm.pieces.filter { $0.placedIndex != nil }) { piece in
                DraggablePuzzlePiece(
                    piece: piece,
                    smallSize: CGSize(width: 64, height: 64),
                    bigSize: bigSize,
                    boardRect: boardRect,
                    onDrop: { dropPoint in
                        vm.drop(
                            pieceID: piece.id,
                            proposedPosition: dropPoint,
                            boardRect: boardRect
                        )

                    },
                    isOnBoard: true
                )
                .position(
                    x: piece.position.x - boardRect.minX,
                    y: piece.position.y - boardRect.minY
                )
            }
        }
        .frame(width: boardSide, height: boardSide)
    }

    @ViewBuilder
    private func trayView(boardRect: CGRect, bigSize: CGSize, trayH: CGFloat)
        -> some View
    {
        let trayPieces = vm.pieces.filter { $0.placedIndex == nil }
        let columns = Array(
            repeating: GridItem(.flexible(), spacing: 12),
            count: 4
        )

        ZStack {
            Image("ui_bg_08")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .clipped()

            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(trayPieces) { piece in
                    DraggablePuzzlePiece(
                        piece: piece,
                        smallSize: CGSize(width: 64, height: 64),
                        bigSize: bigSize,
                        boardRect: boardRect,
                        onDrop: { dropPoint in
                            vm.drop(
                                pieceID: piece.id,
                                proposedPosition: dropPoint,
                                boardRect: boardRect
                            )
                        },
                        isOnBoard: false
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
        }
        .frame(maxWidth: .infinity)
        .frame(height: trayH)
        .ignoresSafeArea(edges: .bottom)
    }
}
