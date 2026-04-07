//  SwiftUIView.swift
//  Quizzy Kids

import SwiftUI

struct TermsOfUseView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                Text(mockTermsOfUseText)
                    .font(AppFont.body2())
                    .foregroundStyle(.grayscale400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
            }
            .padding(.top, 16)
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { coordinator.pop() },
                title: "Terms of use",
                showsTitle: true,
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    
    private var mockTermsOfUseText: String {
        """
        Last Updated: 12 June 2025
        
        Welcome to QuizzyKids! These Terms of Use (“Terms”) govern your use of our app. By using QuizzyKids, you (the parent/guardian and child) agree to follow these rules.
        
        App Usage
        • QuizzyKids is an educational app designed for children with the guidance of a parent or guardian
        • By using the app, you agree to use it only for learning, playing, and personal entertainment — not for commercial purposes.
        
        Parental Responsibility
        • Parents or guardians are responsible for supervising their child’s use of the app.
        • Features that involve progress tracking, data access, or updates may require parental consent.
        
        
        User Safety & Privacy
        • We value your privacy. Our Privacy Policy explains what data we collect and how we use it.
        • We do not allow messaging or sharing personal information within the app.
        
        Updates & Changes
        • We may update the app or its features from time to time to improve learning and performance.
        • We may also update these Terms — we’ll notify you if anything important changes.
        """
    }
}

