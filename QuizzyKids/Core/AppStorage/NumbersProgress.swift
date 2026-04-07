//  NumbersProgress.swift
//  Quizzy Kids

import SwiftUI

enum NumbersProgress {
    @AppStorage("nk_unlockedLevel") static var unlockedLevel: Int = 0
    @AppStorage("nk_completedLevel") static var completedLevel: Bool = false
    @AppStorage("nk_lastAnimatedLevel") static var lastAnimatedLevel: Int = 0
}
