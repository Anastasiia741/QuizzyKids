//  FindDifferencesImageView.swift
//  Quizzy Kids

import SwiftUI

struct FindDifferencesImageView: View {
    let imageName: String
    let differences: [DiffPoint]
    let found: Set<String>
    let onTapNormalized: (CGPoint) -> Void

    var body: some View {
        GeometryReader { geo in
            let container = geo.size
            let uiImage = UIImage(named: imageName)
            let imageSize = uiImage?.size ?? CGSize(width: 1, height: 1)
            let drawnRect = aspectFitRect(
                container: container,
                image: imageSize
            )

            ZStack {
                if let uiImage {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: container.width, height: container.height)
                } else {
                    Rectangle().fill(.gray.opacity(0.2))
                }

                ForEach(differences) { d in
                    if found.contains(d.id) {
                        let center = CGPoint(
                            x: drawnRect.minX + d.x * drawnRect.width,
                            y: drawnRect.minY + d.y * drawnRect.height
                        )
                        let r = max(12, d.radius * drawnRect.width)

                        Circle()
                            .stroke(.white, lineWidth: 4)
                            .background(
                                Circle().stroke(
                                    .black.opacity(0.35),
                                    lineWidth: 6
                                )
                            )
                            .frame(width: r * 2, height: r * 2)
                            .position(center)
                    }
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onEnded { value in
                        let loc = value.location
                        guard drawnRect.contains(loc) else { return }

                        let nx = (loc.x - drawnRect.minX) / drawnRect.width
                        let ny = (loc.y - drawnRect.minY) / drawnRect.height
                        onTapNormalized(CGPoint(x: nx, y: ny))
                    }
            )
        }
    }

    private func aspectFitRect(container: CGSize, image: CGSize) -> CGRect {
        let containerRatio = container.width / max(container.height, 1)
        let imageRatio = image.width / max(image.height, 1)

        if imageRatio > containerRatio {
            let width = container.width
            let height = width / imageRatio
            let y = (container.height - height) / 2
            return CGRect(x: 0, y: y, width: width, height: height)
        } else {
            let height = container.height
            let width = height * imageRatio
            let x = (container.width - width) / 2
            return CGRect(x: x, y: 0, width: width, height: height)
        }
    }
}
