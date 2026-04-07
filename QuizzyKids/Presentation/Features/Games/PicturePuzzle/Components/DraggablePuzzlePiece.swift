//  DraggablePuzzlePiece.swift
//  Quizzy Kids

import SwiftUI

 struct DraggablePuzzlePiece: View {
    let piece: PicturePuzzleViewModel.PieceState
    let smallSize: CGSize
    let bigSize: CGSize
    let boardRect: CGRect
    let onDrop: (CGPoint) -> Void
    let isOnBoard: Bool

    @State private var dragOffset: CGSize = .zero
    @State private var isDragging: Bool = false

    var body: some View {
        GeometryReader { proxy in
            let startFrame = proxy.frame(in: .named("root"))
            let startCenter = CGPoint(x: startFrame.midX, y: startFrame.midY)

            let currentPoint = CGPoint(
                x: startCenter.x + dragOffset.width,
                y: startCenter.y + dragOffset.height
            )

            let overBoard = boardRect.contains(currentPoint)
            let baseSize = isOnBoard ? bigSize : smallSize
            let pad = min(bigSize.width, bigSize.height) * 0.22
            let outer = CGSize(
                width: baseSize.width + pad * 2,
                height: baseSize.height + pad * 2
            )

            let shape = JigsawPieceShape(edges: piece.edges, padding: pad)

            let bigScale = min(bigSize.width / smallSize.width,
                               bigSize.height / smallSize.height)
            
            let liftScale: CGFloat = {
                guard !isOnBoard else { return 1.0 }
                return (isDragging || overBoard) ? bigScale : 1.0
            }()
            
            Image(uiImage: piece.image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: outer.width, height: outer.height)
                .mask(shape)
                .overlay {
                    shape.stroke(
                        piece.placedIndex != nil && !piece.isCorrectPlacement
                        ? Color.red.opacity(0.55)
                        : Color.black.opacity(0.12),
                        lineWidth: piece.placedIndex != nil && !piece.isCorrectPlacement ? 2 : 1
                    )
                }
                .shadow(radius: (isDragging || overBoard || isOnBoard) ? 4 : 1)

                .scaleEffect(liftScale)
                .animation(.easeInOut(duration: 0.12), value: liftScale)
                .zIndex(isDragging ? 1000 : 0)
                .position(x: proxy.size.width / 2, y: proxy.size.height / 2)
                .offset(dragOffset)

                .gesture(
                    DragGesture()
                        .onChanged { value in
                            isDragging = true
                            dragOffset = value.translation
                        }
                        .onEnded { _ in
                            isDragging = false
                            onDrop(currentPoint)
                            dragOffset = .zero
                        }
                )
        }
        .frame(width: isOnBoard ? bigSize.width : smallSize.width,
               height: isOnBoard ? bigSize.height : smallSize.height)
    }
}

