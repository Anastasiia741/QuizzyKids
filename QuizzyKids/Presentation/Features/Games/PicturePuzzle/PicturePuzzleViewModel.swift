//  PicturePuzzleViewModel.swift
//  Quizzy Kids

import SwiftUI
import UIKit
internal import Combine

@MainActor
final class PicturePuzzleViewModel: ObservableObject {

    enum State { case picking, playing, win, lose }

    struct PieceState: Identifiable, Equatable {
        let id = UUID()
        let correctIndex: Int
        let image: UIImage
        let edges: PieceEdges

        var position: CGPoint = .zero
        var rotation: Double = 0
        var flipped: Bool = false
        var placedIndex: Int? = nil
        var isCorrectPlacement: Bool = false
        static func == (lhs: Self, rhs: Self) -> Bool {
            lhs.id == rhs.id
        }
    }

    @Published var state: State = .picking
    @Published var remainingSeconds: Int = 40
    @Published var pieces: [PieceState] = []
    private let difficultyRoute: [Int] = [4, 6, 9, 12, 9, 12, 6, 9, 12]
    private var routeIndex: Int = 0

    private(set) var rows: Int = 2
    private(set) var cols: Int = 2

    private var timerTask: Task<Void, Never>?
    private var currentImageName: String = "games_puzzle_01"
    private var currentPieces: Int = 4

    func start(imageName: String, piecesCount: Int) {
        currentImageName = imageName
        currentPieces = piecesCount

        if let i = difficultyRoute.firstIndex(of: piecesCount) {
               routeIndex = i
           } else {
               routeIndex = 0
           }

        (rows, cols) = grid(for: piecesCount)
        remainingSeconds = timeLimit(for: piecesCount)

        guard let uiImage = UIImage(named: imageName) else {
            state = .picking
            return
        }

        let seed = stableSeed(imageName) ^ piecesCount
        let edgesGrid = buildEdgesGrid(rows: rows, cols: cols, seed: seed)

        let arr = slice(
            image: uiImage,
            rows: rows,
            cols: cols,
            bleedRatio: 0.22
        )
        .enumerated()
        .map {
            PieceState(
                correctIndex: $0.offset,
                image: $0.element,
                edges: edgesGrid[$0.offset]
            )
        }
        .shuffled()

        self.pieces = arr
        self.state = .playing
        startTimer()
    }

    func retrySame() {
        stop()
        start(imageName: currentImageName, piecesCount: currentPieces)
    }
    
    func pauseTimer() {
        SecondIntervalLoop.cancel(&timerTask)
    }

    func resumeTimer() {
        guard state == .playing else { return }
        startTimer()
    }
    
    func nextPiecesCount() -> Int {
        routeIndex = (routeIndex + 1) % difficultyRoute.count
        currentPieces = difficultyRoute[routeIndex]
        return currentPieces
    }

    func nextImageName(from options: [String]) -> String {
        let pool = options.filter { $0 != currentImageName }
        let next = pool.randomElement() ?? currentImageName
        currentImageName = next
        return next
    }

    func continueAfterLose(extraSeconds: Int = 15) {
        guard state == .lose else { return }
        remainingSeconds = max(remainingSeconds, 0) + extraSeconds
        state = .playing
        startTimer()
    }

    func scatterPieces(in trayRect: CGRect, seed: Int) {
        var gen = SeededGenerator(seed: UInt64(bitPattern: Int64(seed)))

        for i in pieces.indices {
            guard pieces[i].placedIndex == nil else { continue }

            let x = Double.random(
                in: trayRect.minX...trayRect.maxX,
                using: &gen
            )
            let y = Double.random(
                in: trayRect.minY...trayRect.maxY,
                using: &gen
            )

            pieces[i].position = CGPoint(x: x, y: y)
            pieces[i].rotation = Double.random(in: -18...18, using: &gen)
            pieces[i].flipped = Bool.random(using: &gen)
        }
    }

    func drop(pieceID: UUID, proposedPosition: CGPoint, boardRect: CGRect) {
        let snapAnimation = Animation.interactiveSpring(response: 0.35, dampingFraction: 0.9)

        guard let index = pieces.firstIndex(where: { $0.id == pieceID }) else { return }
        guard state == .playing else { return }

        guard boardRect.contains(proposedPosition) else {
            withAnimation(.easeInOut(duration: 0.18)) {
                pieces[index].placedIndex = nil
                pieces[index].isCorrectPlacement = false
            }
            return
        }

        let correctCell = pieces[index].correctIndex
        let correctCenter = cellCenter(correctCell, boardRect: boardRect)

        let cellSize = min(
            boardRect.width / CGFloat(cols),
            boardRect.height / CGFloat(rows)
        )
        let snapRadius = cellSize * 0.45

        if distance(proposedPosition, correctCenter) <= snapRadius {
            if isCellOccupied(correctCell, except: pieceID) {
                UINotificationFeedbackGenerator().notificationOccurred(.error)
                return
            }

            withAnimation(snapAnimation) {
                pieces[index].position = correctCenter
                pieces[index].placedIndex = correctCell
                pieces[index].isCorrectPlacement = true
                pieces[index].rotation = 0
                pieces[index].flipped = false
            }

            checkWin()
            return
        }

        let cell = nearestCellIndex(for: proposedPosition, boardRect: boardRect)

        if isCellOccupied(cell, except: pieceID) {
            UINotificationFeedbackGenerator().notificationOccurred(.warning)
            return
        }

        let center = cellCenter(cell, boardRect: boardRect)

        withAnimation(snapAnimation) {
            pieces[index].position = center
            pieces[index].placedIndex = cell
            pieces[index].isCorrectPlacement = (cell == correctCell) 
            pieces[index].rotation = 0
            pieces[index].flipped = false
        }

        if pieces[index].isCorrectPlacement {
            checkWin()
        } else {
            UINotificationFeedbackGenerator().notificationOccurred(.error)
        }
    }

    private func checkWin() {
        guard pieces.allSatisfy({ $0.placedIndex != nil }) else { return }
        let solved = pieces.allSatisfy { $0.isCorrectPlacement }
        if solved {
            stop()
            state = .win
        }
    }

    private func startTimer() {
        stop()
        SecondIntervalLoop.start(&timerTask) { [weak self] in
            guard let self else { return true }
            guard self.state == .playing else { return true }

            self.remainingSeconds -= 1

            if self.remainingSeconds <= 0 {
                self.remainingSeconds = 0
                self.stop()
                let solved =
                    self.pieces.allSatisfy({ $0.placedIndex != nil }) &&
                    self.pieces.allSatisfy({ $0.isCorrectPlacement })

                self.state = solved ? .win : .lose
                return true
            }
            return false
        }
    }

    func stop() {
        SecondIntervalLoop.cancel(&timerTask)
    }

    private func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        hypot(a.x - b.x, a.y - b.y)
    }

    private func grid(for pieces: Int) -> (Int, Int) {
        switch pieces {
        case 4: return (2, 2)
        case 6: return (2, 3)
        case 9: return (3, 3)
        case 12: return (3, 4)
        default: return (2, 2)
        }
    }

    private func timeLimit(for pieces: Int) -> Int {
        40 + pieces * 5
    }

    private func stableSeed(_ s: String) -> Int {
        s.unicodeScalars.reduce(0) { ($0 &* 31) &+ Int($1.value) }
    }

    private func nearestCellIndex(for point: CGPoint, boardRect: CGRect) -> Int {
        let cellW = boardRect.width / CGFloat(cols)
        let cellH = boardRect.height / CGFloat(rows)

        let relX = (point.x - boardRect.minX) / cellW
        let relY = (point.y - boardRect.minY) / cellH

        let c = max(0, min(cols - 1, Int(relX)))
        let r = max(0, min(rows - 1, Int(relY)))

        return r * cols + c
    }

    private func cellCenter(_ idx: Int, boardRect: CGRect) -> CGPoint {
        let cellW = boardRect.width / CGFloat(cols)
        let cellH = boardRect.height / CGFloat(rows)

        let r = idx / cols
        let c = idx % cols

        return CGPoint(
            x: boardRect.minX + (CGFloat(c) + 0.5) * cellW,
            y: boardRect.minY + (CGFloat(r) + 0.5) * cellH
        )
    }

    private func isCellOccupied(_ idx: Int, except pieceID: UUID) -> Bool {
        pieces.contains { $0.id != pieceID && $0.placedIndex == idx }
    }

    private func seededBool(_ seed: Int) -> Bool {
        var x = UInt64(bitPattern: Int64(seed))
        x &*= 6_364_136_223_846_793_005
        x &+= 1_442_695_040_888_963_407
        x ^= x >> 33
        return (x & 1) == 0
    }

    private func buildEdgesGrid(rows: Int, cols: Int, seed: Int) -> [PieceEdges] {
        var grid = Array(
            repeating: PieceEdges(
                top: .flat,
                right: .flat,
                bottom: .flat,
                left: .flat
            ),
            count: rows * cols
        )
        func idx(_ r: Int, _ c: Int) -> Int { r * cols + c }

        for r in 0..<rows {
            for c in 0..<cols {
                let top: PuzzleEdge =
                    (r == 0) ? .flat : grid[idx(r - 1, c)].bottom.opposite
                let left: PuzzleEdge =
                    (c == 0) ? .flat : grid[idx(r, c - 1)].right.opposite

                let right: PuzzleEdge =
                    (c == cols - 1)
                    ? .flat
                    : (seededBool(seed + idx(r, c) * 17 + 1) ? .out : .in)

                let bottom: PuzzleEdge =
                    (r == rows - 1)
                    ? .flat
                    : (seededBool(seed + idx(r, c) * 31 + 7) ? .out : .in)

                grid[idx(r, c)] = PieceEdges(
                    top: top,
                    right: right,
                    bottom: bottom,
                    left: left
                )
            }
        }
        return grid
    }

    private func slice(
        image: UIImage,
        rows: Int,
        cols: Int,
        bleedRatio: CGFloat
    ) -> [UIImage] {
        guard let cg = image.cgImage else { return [] }

        let W = cg.width
        let H = cg.height

        let tileW = W / cols
        let tileH = H / rows

        let bleedPx = Int(CGFloat(min(tileW, tileH)) * bleedRatio)

        let fullRect = CGRect(x: 0, y: 0, width: W, height: H)

        var result: [UIImage] = []
        result.reserveCapacity(rows * cols)

        for r in 0..<rows {
            for c in 0..<cols {

                let x0 = c * tileW
                let y0 = r * tileH
                let x1 = (c == cols - 1) ? W : (c + 1) * tileW
                let y1 = (r == rows - 1) ? H : (r + 1) * tileH

                let base = CGRect(
                    x: x0,
                    y: y0,
                    width: x1 - x0,
                    height: y1 - y0
                )

                let wanted = base.insetBy(dx: -CGFloat(bleedPx), dy: -CGFloat(bleedPx))
                let clipped = wanted.intersection(fullRect).integral

                guard let croppedCG = cg.cropping(to: clipped) else {
                    result.append(UIImage())
                    continue
                }

                let outSize = wanted.size
                let renderer = UIGraphicsImageRenderer(size: outSize)

                let out = renderer.image { _ in
                    let dx = clipped.minX - wanted.minX
                    let dy = clipped.minY - wanted.minY

                    UIImage(
                        cgImage: croppedCG,
                        scale: image.scale,
                        orientation: image.imageOrientation
                    )
                    .draw(
                        in: CGRect(
                            x: dx,
                            y: dy,
                            width: clipped.width,
                            height: clipped.height
                        )
                    )
                }

                result.append(out)
                
            }
        }

        return result
        
    }
}



