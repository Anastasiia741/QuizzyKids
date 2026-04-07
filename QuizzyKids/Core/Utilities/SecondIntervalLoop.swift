//  SecondIntervalLoop.swift
//  Quizzy Kids

import Foundation

enum SecondIntervalLoop {
    @MainActor
    static func start(_ task: inout Task<Void, Never>?, tick: @escaping @MainActor () -> Bool) {
        task?.cancel()
        task = Task { @MainActor in
            while !Task.isCancelled {
                await Task.quizSleep(seconds: 1)
                guard !Task.isCancelled else { return }
                if tick() { return }
            }
        }
    }

    @MainActor
    static func cancel(_ task: inout Task<Void, Never>?) {
        task?.cancel()
        task = nil
    }
}
