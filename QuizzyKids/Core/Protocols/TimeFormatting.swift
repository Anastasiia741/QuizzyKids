//  TimeFormatting.swift
//  Quizzy Kids

import Foundation

enum TimeFormatStyle: Sendable {
    case minutesAndSeconds
    case zeroMinutesSeconds
}

protocol TimeFormatting {}

extension TimeFormatting {
    func formatTime(_ seconds: Int, style: TimeFormatStyle = .minutesAndSeconds) -> String {
        let clamped = max(0, seconds)
        switch style {
        case .minutesAndSeconds:
            return String(format: "%02d:%02d", clamped / 60, clamped % 60)
        case .zeroMinutesSeconds:
            return String(format: "00:%02d", clamped)
        }
    }
}
