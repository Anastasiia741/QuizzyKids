//  ProgressMapConfig.swift
//  Quizzy Kids

import Foundation
import SwiftUI

struct ProgressMapConfig {
    let backgroundImageName: String
    let markerImageName: String
    let markerSize: CGSize

    let unlockedKey: String
    let lastAnimatedKey: String

    let openLevel: (Int) -> Void

    init(
        backgroundImageName: String,
        markerImageName: String = Numbers.level01.rawValue,
        markerSize: CGSize = CGSize(width: 60, height: 41),
        unlockedKey: String,
        lastAnimatedKey: String,
        openLevel: @escaping (Int) -> Void
    ) {
        self.backgroundImageName = backgroundImageName
        self.markerImageName = markerImageName
        self.markerSize = markerSize
        self.unlockedKey = unlockedKey
        self.lastAnimatedKey = lastAnimatedKey
        self.openLevel = openLevel
    }
}

struct ProgressMapView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    private let config: ProgressMapConfig
    private let levels: [NumberKnowledgeMap.LevelNode]
    @AppStorage private var unlockedLevel: Int
    @AppStorage private var lastAnimatedLevel: Int

    @State private var activePath: [CGPoint] = NumberKnowledgeMap.path1
    @State private var markerPoint: CGPoint = .zero
    @State private var isAnimating: Bool = false
    @State private var showMovingMarker: Bool = true
    @State private var rotateMarker: Bool = false

    init(config: ProgressMapConfig, levels: [NumberKnowledgeMap.LevelNode] = NumberKnowledgeMap.levels) {
        self.config = config
        self.levels = levels
        _unlockedLevel = AppStorage(wrappedValue: 0, config.unlockedKey)
        _lastAnimatedLevel = AppStorage(wrappedValue: 0, config.lastAnimatedKey)
    }

    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color.colorF9E9E7.ignoresSafeArea()

                Image(config.backgroundImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .clipped()
                    .ignoresSafeArea()

                ForEach(levels) { lvl in
                    levelButton(lvl)
                        .position(mapToImage(lvl.pos, in: geo.size))
                        .zIndex(2)
                }

                if showMovingMarker {
                    Image(config.markerImageName)
                        .resizable()
                        .scaledToFit()
                        .frame(width: config.markerSize.width, height: config.markerSize.height)
                        .scaleEffect(x: rotateMarker ? -1 : 1, y: 1)
                        .position(mapToImage(markerPoint, in: geo.size))
                        .zIndex(50)
                        .transition(.opacity)
                }
            }
            
            .onAppear {
                Task { await runAnimation() }
            }
            .onChange(of: unlockedLevel) { _, _ in
                Task { await runAnimation() }
            }
        }
    }

    @ViewBuilder
    private func levelButton(_ lvl: NumberKnowledgeMap.LevelNode) -> some View {
        let isUnlocked = lvl.id <= lastAnimatedLevel

        let unlockedColor: Color = {
            switch lvl.id {
            case 1: return .secondary100
            case 2: return .secondary200
            case 3: return .primary100
            case 4: return .accent100
            default: return .secondary100
            }
        }()
        
        
        let fillColor: Color = isUnlocked ? unlockedColor : .colorF3CBCD

        Button {
            guard isUnlocked else { return }
            config.openLevel(lvl.id)
        } label: {
            ZStack {
                Circle().fill(fillColor)

                Image(lvl.asset.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .frame(height: 62)
                    .opacity(isUnlocked ? 1 : 0.45)
            }
            .frame(width: 100, height: 100)
        }
        .buttonStyle(.plain)
    }

    private func mapToImage(_ normalized: CGPoint, in geoSize: CGSize) -> CGPoint {
        guard let img = UIImage(named: config.backgroundImageName) else {
            return CGPoint(x: normalized.x * geoSize.width, y: normalized.y * geoSize.height)
        }

        let scale = min(geoSize.width / img.size.width, geoSize.height / img.size.height)
        let w = img.size.width * scale
        let h = img.size.height * scale
        let rect = CGRect(
            x: (geoSize.width - w) / 2,
            y: (geoSize.height - h) / 2,
            width: w,
            height: h
        )

        return CGPoint(
            x: rect.minX + normalized.x * rect.width,
            y: rect.minY + normalized.y * rect.height
        )
    }

    @MainActor
    private func runAnimation() async {
        guard !isAnimating else { return }

        if unlockedLevel == 0 {
            await animatePath(level: 1)
            unlockedLevel = 1
            lastAnimatedLevel = 1
            return
        }

        guard unlockedLevel > lastAnimatedLevel else { return }

        let levelToAnimate = min(unlockedLevel, 4)
        await animatePath(level: levelToAnimate)
        lastAnimatedLevel = levelToAnimate

        if unlockedLevel == 3, lastAnimatedLevel == 3 {
            try? await Task.sleep(nanoseconds: 250_000_000)
            config.openLevel(3)
        }

        if unlockedLevel == 4, lastAnimatedLevel == 4 {
            try? await Task.sleep(nanoseconds: 250_000_000)
            config.openLevel(4)
        }
    }

    @MainActor
    private func animatePath(level: Int) async {
        guard !isAnimating else { return }

        let pts: [CGPoint]
        switch level {
        case 1: pts = NumberKnowledgeMap.path1
        case 2: pts = NumberKnowledgeMap.path2
        case 3: pts = NumberKnowledgeMap.path3
        case 4: pts = NumberKnowledgeMap.path4
        default: return
        }

        isAnimating = true
        showMovingMarker = true
        rotateMarker = (level == 2 || level == 4)

        activePath = pts
        markerPoint = pts.first ?? .zero

        let totalDuration: Double = 1.2
        let steps = max(pts.count - 1, 1)
        let stepDuration = totalDuration / Double(steps)

        for i in 1..<pts.count {
            withAnimation(.linear(duration: stepDuration)) {
                markerPoint = pts[i]
            }
            try? await Task.sleep(nanoseconds: UInt64(stepDuration * 1_500_000_000))
        }

        UIImpactFeedbackGenerator(style: .soft).impactOccurred()

        withAnimation(.easeOut(duration: 1.2)) {
            showMovingMarker = false
        }
        isAnimating = false
    }
}
