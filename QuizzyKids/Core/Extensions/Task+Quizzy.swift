//  Task+Quizzy.swift
//  Quizzy Kids

import Foundation

extension Task where Success == Never, Failure == Never {
    static func quizSleep(seconds: Double) async {
        let ns = UInt64(max(0, seconds) * 1_000_000_000)
        guard ns > 0 else { return }
        try? await Task.sleep(nanoseconds: ns)
    }
}
