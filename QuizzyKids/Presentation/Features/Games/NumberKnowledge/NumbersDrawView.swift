//  NumbersDrawView.swift
//  Quizzy Kids

import SwiftUI
import CoreGraphics

struct NumbersDrawView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @StateObject private var vm = NumbersViewModel()
    @StateObject private var winPresenter = WinView()
    @StateObject private var successPresenter = WinView(lotties: ["Google Pay - Success"])
    let levelId: Int
    @State private var showBack = false
    @State private var isSuccess = false
    @State private var isWin = false
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            
            VStack(spacing: 12) {
                Spacer(minLength: 0)
                
                Image(NumPlay.by(vm.currentValue).rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 260)
                    .padding(.horizontal, 24)
                    .overlay {
                        drawingLayer
                    }
                
                Spacer(minLength: 0)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { showBack = true },
                title: "Write the number",
                showsTitle: true
            )
        }
        .safeAreaInset(edge: .bottom, spacing: 12) {
            BottomView(
                options: Array(vm.items.indices),
                selected: vm.items.firstIndex(where: { $0.value == vm.currentValue }),
                onTap: { i in
                    vm.selectForDraw(vm.items[i])
                },
                content: { i in
                        .image(vm.items[i].imageDigit.rawValue)
                }
            )
        }

        .onAppear { vm.startDrawLevel() }
        .onChange(of: vm.isCompleted) { _, done in
            guard done else { return }
            handleCompleted()
        }
        .confirmAlert(isPresented: $showBack, text: "Exit the game?", showsAvatar: false) {
            coordinator.pop()
        }
        .winLottieOverlay(isWin: isSuccess, presenter: successPresenter, centered: true)
        .winLottieOverlay(isWin: isWin, presenter: winPresenter)
        .navigationBarBackButtonHidden(true)
        .toolbar(.hidden, for: .navigationBar)
    }
    
    
    private var drawingLayer: some View {
        GeometryReader { geo in
            let rect = geo.frame(in: .local)
            
            let targets = vm.currentTargets.map { mapToRect($0, rect) }
            
            let steps = vm.currentSteps.map { mapToRect($0, rect) }
            
            let dashPattern: [CGFloat] = [10, 20]
            let dashedGray  = StrokeStyle(lineWidth: 2, lineCap: .round, lineJoin: .round, dash: dashPattern)
            let dashedGreen = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round, dash: dashPattern)
            let solidGreen  = StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round)
            
            ZStack {
                makePath(targets)
                    .stroke(.grayscale300, style: dashedGray)
                
                makePath(Array(targets.prefix(max(vm.progressIndex, 1))))
                    .stroke(Color.secondary200, style: dashedGreen)
                
                ForEach(vm.drawnStrokes, id: \.self) { stroke in
                    makePath(stroke)
                        .stroke(Color.secondary200, style: solidGreen)
                }
                
                makePath(vm.currentStroke)
                    .stroke(Color.secondary200, style: solidGreen)
                
                ForEach(Array(steps.enumerated()), id: \.offset) { index, point in
                    let done = vm.isStepCompleted(index)
                    
                    ZStack {
                        Circle()
                            .fill(done ? Color.secondary200 : Color.grayscale300.opacity(0.25))
                            .frame(width: 34, height: 34)
                        
                        Circle()
                            .stroke(done ? Color.secondary200 : Color.grayscale300, lineWidth: 2)
                            .frame(width: 34, height: 34)
                        
                        Text("\(index + 1)")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundStyle(Color.white)
                    }
                    .position(point)
                }
            }
            .contentShape(Rectangle())
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { vm.handleDrag(point: $0.location, targets: targets) }
                    .onEnded { _ in vm.endStroke() }
            )
        }
    }
    
    private func makePath(_ points: [CGPoint]) -> Path {
        Path { p in
            guard let first = points.first else { return }
            p.move(to: first)
            points.dropFirst().forEach { p.addLine(to: $0) }
        }
    }
    
    private func mapToRect(_ normalized: CGPoint, _ rect: CGRect) -> CGPoint {
        CGPoint(
            x: rect.minX + normalized.x * rect.width,
            y: rect.minY + normalized.y * rect.height
        )
    }
    
    @MainActor
    private func handleCompleted() {
        if vm.currentValue < 10 {
            isSuccess = true

            Task { @MainActor in
                try? await Task.sleep(nanoseconds: 1_400_000_000)
                isSuccess = false
                vm.currentValue += 1
                vm.resetForCurrent()
            }
            return
        }

        isWin = true
        Task { @MainActor in
            try? await Task.sleep(nanoseconds: 2_200_000_000)
            isWin = false

            NumbersProgress.completedLevel = true
            NumbersProgress.unlockedLevel = max(NumbersProgress.unlockedLevel, 3)

            coordinator.pop() 
        }
    }
}

