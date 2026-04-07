//  SpeechService.swift
//  Quizzy Kids

import Foundation
import AVFoundation
internal import Combine

@MainActor
protocol SoundTypingVM: AnyObject, ObservableObject {
    var typedWord: String { get set }
    var isSoundOn: Bool { get set }

    var speech: SpeechService { get }
    var typingTask: Task<Void, Never>? { get set }
}


@MainActor
extension SoundTypingVM {

    func toggleSound() {
        isSoundOn.toggle()
        if !isSoundOn { speech.stop() }
    }

    func startTyping(word: String) {
        typingTask?.cancel()
        typedWord = ""

        typingTask = Task.detached(priority: .userInitiated) { [weak self] in
            guard let self else { return }

            for ch in word {
                try? await Task.sleep(nanoseconds: 90_000_000)
                if Task.isCancelled { return }

                await MainActor.run {
                    self.typedWord.append(ch)
                }
            }
        }
    }
}

final class SpeechService {
    private let synth = AVSpeechSynthesizer()
    private let q = DispatchQueue(label: "speech.queue")

    func speakLetter(_ text: String, language: String = "en-GB") {
        let clean = String(text.prefix(1)).lowercased()
        speak(clean, language: language)
    }

    func speakWord(_ text: String, language: String = "en-GB") {
        speak(text, language: language)
    }

    private func speak(_ text: String, language: String) {
        q.async { [weak self] in
            guard let self else { return }

            if self.synth.isSpeaking {
                self.synth.stopSpeaking(at: .immediate)
            }

            let u = AVSpeechUtterance(string: text)
            u.voice = AVSpeechSynthesisVoice(language: language)
            u.rate = 0.45
            self.synth.speak(u)
        }
    }

    func stop() {
        q.async { [weak self] in
            self?.synth.stopSpeaking(at: .immediate)
        }
    }
}


