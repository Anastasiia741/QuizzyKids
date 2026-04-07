//  PrivacyPolicyView.swift
//  Quizzy Kids

import SwiftUI

struct PrivacyPolicyView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                Text(mockPrivacyText)
                    .font(AppFont.body2())
                    .foregroundStyle(.grayscale400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 20)
                    .padding(.top, 16)
                    .padding(.bottom, 24)
            }
            .padding(.top, 40)
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { coordinator.pop() },
                title: "Privacy policy",
                showsTitle: true,
            )
        }
        .navigationBarBackButtonHidden(true)
    }
    private var mockPrivacyText: String {
        """
        Last Updated: 12 June 2025
        
        QuizzyKids is committed to protecting your child’s privacy. This Privacy Policy explains how we collect, use, and protect personal information within our app.
        
        Why We Collect It
        We use the data to:
        • Track learning progress
        • Unlock achievements and content
        • Improve gameplay and educational features
        • Send parent updates (if opted in)
        
        
        How We Protect Your Data
        We use encryption and secure servers to protect your information. Data is never sold or shared with third parties for advertising.
        
        Children's Privacy
        We do not knowingly collect personal information from children. If you believe a child has provided personal information, please contact us.
        We follow the rules under COPPA (Children’s Online Privacy Protection Act). If we discover we've collected information from a child under 13 without parental consent, we will delete it promptly.
        
        Contact Us
        If you have any questions about this policy, contact us at support@quizzykids.com
        """
    }
}

