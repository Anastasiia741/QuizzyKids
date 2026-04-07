//  Floating.swift
//  Quizzy Kids

import Foundation
import SwiftUI

struct Floating: ViewModifier {
    let amplitude: CGFloat
    let rotation: Double
    let duration: Double
    let delay: Double

    @State private var up = false

    func body(content: Content) -> some View {
        content
            .offset(y: up ? -amplitude : amplitude)
            .rotationEffect(.degrees(up ? rotation : -rotation))
            .animation(
                .easeInOut(duration: duration)
                    .repeatForever(autoreverses: true)
                    .delay(delay),
                value: up
            )
            .onAppear { up = true }
    }
}

extension View {
    func floating(
        amplitude: CGFloat = 10,
        rotation: Double = 1.2,
        duration: Double = 2.6,
        delay: Double = 0
    ) -> some View {
        modifier(
            Floating(
                amplitude: amplitude,
                rotation: rotation,
                duration: duration,
                delay: delay
            )
        )
    }
}
