//  ReadingGameView.swift
//  Quizzy Kids

import AVFoundation
import SwiftUI

struct ReadingGameView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    let bookID: String
    @State private var book: ReadingBookModel?
    @State private var stepIndex: Int = 0
   
    private let synth = AVSpeechSynthesizer()
    private var totalSteps: Int { 1 + (book?.pages.count ?? 0) }
    private let cardHeight: CGFloat = 420
    private let stepsHeight: CGFloat = 190

    @State private var showBackConfirm = false
    @State private var isSpeaking = false
    
    var body: some View {
        ZStack {
            Color.accent100.ignoresSafeArea()
            VStack(spacing: 0) {
                Spacer(minLength: 0)
                contentCard
                    .frame(height: cardHeight)
                    .padding(.horizontal, 20)
                Spacer(minLength: 0)
                stepsGrid
                    .frame(height: stepsHeight)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 12)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                showsBack: true,
                onBack: { showBackConfirm = true },
                rightAssetIcon: isSpeaking ? "ui_icons_16" : "ui_icons_15",
                onRightTap: { toggleAudio() }
            )
        }
        .navigationBarBackButtonHidden(true)
        .onAppear {
            book = ReadingMockDB.book(id: bookID)
            stepIndex = 0
        }
        .onChange(of: stepIndex) { _, newStep in
            markBookCompletedIfNeeded(stepIndex: newStep)
        }
        .confirmAlert(
            isPresented: $showBackConfirm,
            text: "Leave this book?",
            showsAvatar: false,
            onNo: { }
        ) {
            stopAudio()
            coordinator.pop()
        }
    }

    private var contentCard: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.colorE0D0E9.opacity(0.5))

            if let book {
                if stepIndex == 0 {
                    Image(book.image.rawValue)
                        .resizable()
                        .scaledToFit()
                        .padding(.vertical, 18)
                        .padding(.horizontal, 18)
                } else {
                    let pageText = book.pages[stepIndex - 1]
                    Text(pageText)
                        .font(AppFont.title1())
                        .foregroundColor(.grayscale400)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 24)
                        .padding(.horizontal, 18)
                }
            }
        }
    }

    private var stepsGrid: some View {
        ZStack {
            Image("ui_bg_08")
                .resizable()
                .scaledToFill()
                .clipped()

            LazyVGrid(
                columns: Array(
                    repeating: GridItem(.flexible(), spacing: 10),
                    count: 5
                ),
                spacing: 10
            ) {
                ForEach(1...10, id: \.self) { number in
                    let index = number - 1
                    let enabled = index < totalSteps

                    Button {
                        stopAudio()
                        stepIndex = index
                    } label: {
                        Text("\(number)")
                            .font(AppFont.title1())
                            .foregroundColor(
                                index == stepIndex ? .white : .black
                            )
                            .frame(width: 64, height: 64)
                            .background(
                                index == stepIndex ? .primary100 : .accent100
                            )
                            .clipShape(Circle())
                    }
                    .buttonStyle(.plain)
                    .disabled(!enabled)
                    .opacity(enabled ? 1 : 0.35)
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 14)
        }
        .clipShape(RoundedRectangle(cornerRadius: 24, style: .continuous))
        .clipped()
    }

    private func toggleAudio() {
        guard let book else { return }
        guard stepIndex != 0 else {
            stopAudio()
            return
        }
        if isSpeaking {
            stopAudio()
            return
        }
        isSpeaking = true
        let text = book.pages[stepIndex - 1]

        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = 0.48
        utterance.voice = AVSpeechSynthesisVoice(language: "en-GB")
        synth.speak(utterance)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if !synth.isSpeaking { isSpeaking = false }
        }
    }

    private func stopAudio() {
        synth.stopSpeaking(at: .immediate)
        isSpeaking = false
    }

    /// Последний шаг — финальная страница книги (после обложки).
    private func markBookCompletedIfNeeded(stepIndex: Int) {
        guard let book else { return }
        let lastIndex = (1 + book.pages.count) - 1
        guard stepIndex == lastIndex else { return }
        ReadingProgressStorage.markCompleted(bookID: book.id)
    }
}
