//  OnboardingPage.swift
//  Quizzy Kids

import SwiftUI

struct OnboardingPage: Identifiable {
    let id = UUID()
    let imageName: String
    let title: String
    let subtitle: String
    let buttonTitle: String
    let backgroundShapeName: String
}

extension OnboardingPage {
    static let pages: [OnboardingPage] = [
        OnboardingPage(
            imageName: "ui_shape_07",
            title: "Hi there, Brainy\nBuddy!",
            subtitle:
                "Welcome to QuizzyKids – where learning feels like playing!",
            buttonTitle: "Next",
            backgroundShapeName: "ui_bg_04"
        ),
        OnboardingPage(
            imageName: "ui_bg_03",
            title: "Join the Exciting Quiz\nChallenge!",
            subtitle:
                "Test your brain with cool questions on animals, math, colors, and more!",
            buttonTitle: "Next",
            backgroundShapeName: "ui_bg_05"
            
        ),
        OnboardingPage(
            imageName: "ui_shape_08",
            title: "Win Stars & Unlock\nBadges!",
            subtitle: "Earn rewards as you learn – become a Quizzy Champion!",
            buttonTitle: "Get started",
            backgroundShapeName: "ui_bg_06"
            
        ),
    ]
}

struct OnboardingView: View {
    @State private var currentIndex: Int = 0
    let pages = OnboardingPage.pages
    
    var onFinish: () -> Void
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            
            Image(pages[currentIndex].backgroundShapeName)
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: .bottom)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Spacer()
                    Button("Skip") { onFinish() }
                        .font(AppFont.caption1())
                        .foregroundColor(.secondary200)
                        .padding(.trailing, 20)
                        .padding(.top, 14)
                }
                
                TabView(selection: $currentIndex) {
                    ForEach(pages.indices, id: \.self) { index in
                        pageView(pages[index]).tag(index)
                    }
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .padding(.horizontal, 20)
                
                Button(action: nextTapped) {
                    Text(pages[currentIndex].buttonTitle)
                        .font(AppFont.caption2())
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(AppButtonStyle(type: .primary))
                .padding(.horizontal, 20)
                .padding(.bottom, 32)
            }
        }
        .animation(.easeInOut, value: currentIndex)
    }
    
    private func nextTapped() {
        if currentIndex < pages.count - 1 {
            currentIndex += 1
        } else {
            onFinish()
        }
    }
    
    @ViewBuilder
    private func pageView(_ page: OnboardingPage) -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 240)
            
            VStack(spacing: 12) {
                Text(page.title).font(AppFont.title2()).multilineTextAlignment(.center)
                Text(page.subtitle).font(AppFont.body()).multilineTextAlignment(.center).padding(.horizontal, 20)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
    }
}
