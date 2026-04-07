//  AlphabetViewModel.swift
//  Quizzy Kids

internal import Combine
import SwiftUI

@MainActor
final class AlphabetViewModel: ObservableObject, SoundTypingVM {
    @Published var items: [AlphabetModel] = AlphabetData.items
    @Published var selectedItem: AlphabetModel?
    @Published var typedWord: String = ""
    @Published var isSoundOn: Bool = true
    
    let speech = SpeechService()
    
    var typingTask: Task<Void, Never>?
    private var lastSelectID: UUID?
    private var didAutoStart = false
    
    func select(_ item: AlphabetModel, playSpeech: Bool = true) {
        if lastSelectID == item.id { return }
        lastSelectID = item.id
        
        selectedItem = item
        startTyping(word: item.word)
        
        guard isSoundOn, playSpeech else { return }
        speech.speakLetter(item.letter)
    }
    
    func playWord() {
        guard let selectedItem, isSoundOn else { return }
        speech.speakWord(selectedItem.word)
    }
    
    func startFirstLetter() {
        guard !didAutoStart else { return }
        didAutoStart = true
        
        guard selectedItem == nil, let first = items.first else { return }
        select(first, playSpeech: true)
    }
    
    deinit {
        typingTask?.cancel()   
    }
}


