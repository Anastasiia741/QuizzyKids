//  QuizzyKidsApp.swift
//  QuizzyKids


import SwiftUI
import SwiftData
import FirebaseCore


@main
struct QuizzyKidsApp: App {
    @UIApplicationDelegateAdaptor(QuizzyAppDelegate.self) private var appDelegate

    init() { FirebaseApp.configure() }
    
    var body: some Scene {
        WindowGroup {
            RootView()
        }
    }
}
