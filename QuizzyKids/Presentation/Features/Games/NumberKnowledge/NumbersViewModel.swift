//  NumbersViewModel.swift
//  Quizzy Kids

import AVFoundation
internal import Combine
import Foundation

@MainActor
final class NumbersViewModel: ObservableObject, SoundTypingVM {
    @Published var items: [NumbersModel] = NumbersData.items
    @Published var selectedItem: NumbersModel?
    @Published var round = RoundState()
    var countTasks: [NumbersCount] { NumbersCountData.tasks }
    
    @Published var typedWord: String = ""
    @Published var isSoundOn: Bool = true
    let speech = SpeechService()
    var typingTask:Task<Void, Never>?
    private var lastSelectID: UUID?
    private var didAutoStart = false
    
    @Published var currentValue: Int = 1
    @Published var progressIndex: Int = 0
    @Published var strokeIndex: Int = 0
    @Published var drawnStrokes: [[CGPoint]] = []
    @Published var currentStroke: [CGPoint] = []
    @Published var isCompleted: Bool = false
    
    
    @Published var countTaskIndex: Int = 0
    
    
    @Published var matchRoundIndex: Int = 0
    @Published var matchNumbers: [Int] = []
    @Published var matchSelectedIndex: Int? = nil
    @Published var matchAttemptsLeft: Int = 3
    @Published var matchShowWrongText: Bool = false
    @Published var matchPerRowResult: [Bool]? = nil
    
    
    let threshold: CGFloat = 28
    private let maxLookahead: Int = 14
    
    deinit { typingTask?.cancel() }
    
    @Published var tappedValues: Set<Int> = []
    @Published var didFinishLevel: Bool = false
    
    var shouldTrackLevel: Bool {
        !NumbersProgress.completedLevel
    }
    
    var isLevel1Complete: Bool {
        tappedValues.count >= 10
    }
}

//MARK: NumbersSoundView
extension NumbersViewModel {
    func userSelect(_ item: NumbersModel) {
        select(item, playSpeech: true)
        guard shouldTrackLevel, !didFinishLevel else { return }
        tappedValues.insert(item.value)
        didFinishLevel = tappedValues.count >= 10
    }
    
    func select(_ item: NumbersModel, playSpeech: Bool = true) {
        guard lastSelectID != item.id else { return }
        lastSelectID = item.id
        
        selectedItem = item
        startTyping(word: item.word)
        
        if playSpeech {
            guard isSoundOn else { return }
            speech.speakWord(item.word)
        }
    }
    
    func playNumber() {
        guard let selectedItem else { return }
        guard isSoundOn else { return }
        speech.speakWord(selectedItem.word)
    }
    
    func startFirstNumber() {
        guard !didAutoStart else { return }
        didAutoStart = true
        
        if shouldTrackLevel {
            tappedValues.removeAll()
            didFinishLevel = false
        }
        
        guard selectedItem == nil, let first = items.first else { return }
        select(first, playSpeech: true)
        guard shouldTrackLevel, !didFinishLevel else { return }
        tappedValues.insert(first.value)
        didFinishLevel = tappedValues.count >= 10
    }
}

//MARK: NumbersDrawView
extension NumbersViewModel {
    
    private var drawData: [DrawData] {
        NumbersDrawPaths.data(for: currentValue)
    }
    
    var currentTargets: [CGPoint] {
        guard strokeIndex < drawData.count else { return [] }
        return drawData[strokeIndex].path.map(\.cg)
    }
    
    var currentSteps: [CGPoint] {
        guard strokeIndex < drawData.count else { return [] }
        return drawData[strokeIndex].steps.map(\.cg)
    }
    
    var currentStepTargetIndexes: [Int] {
        let targets = currentTargets
        let steps = currentSteps
        guard !targets.isEmpty, !steps.isEmpty else { return [] }
        
        return steps
            .map { closestIndex(to: $0, in: targets) }
            .sorted()
    }
    
    func resetForCurrent() {
        strokeIndex = 0
        progressIndex = 0
        drawnStrokes.removeAll()
        currentStroke.removeAll()
        isCompleted = false
    }
    
    func setDrawValue(_ value: Int) {
        currentValue = value
        resetForCurrent()
    }
    
    func startDrawLevel() {
        setDrawValue(1)
    }
    
    func selectForDraw(_ item: NumbersModel) {
        setDrawValue(item.value)
    }
    
    func isStepCompleted(_ stepNumber: Int) -> Bool {
        let idxs = currentStepTargetIndexes
        guard stepNumber < idxs.count else { return false }
        return progressIndex >= idxs[stepNumber]
    }
    
    private func closestIndex(to point: CGPoint, in targets: [CGPoint]) -> Int {
        var bestIndex = 0
        var bestDist = CGFloat.greatestFiniteMagnitude
        
        for (i, t) in targets.enumerated() {
            let d = hypot(point.x - t.x, point.y - t.y)
            if d < bestDist {
                bestDist = d
                bestIndex = i
            }
        }
        return bestIndex
    }
    
    func endStroke() {
        guard !currentStroke.isEmpty else { return }
        drawnStrokes.append(currentStroke)
        currentStroke.removeAll()
    }
    
    func handleDrag(point: CGPoint, targets: [CGPoint]) {
        guard !isCompleted, !targets.isEmpty else { return }
        
        if currentStroke.isEmpty {
            guard let startIndex = findStartIndex(from: progressIndex, targets: targets, point: point) else { return }
            progressIndex = max(progressIndex, startIndex)
        }
        
        currentStroke.append(point)
        
        while progressIndex < targets.count {
            let t = targets[progressIndex]
            if hypot(point.x - t.x, point.y - t.y) <= threshold {
                progressIndex += 1
            } else {
                break
            }
        }
        
        guard progressIndex >= targets.count else { return }
        
        endStroke()
        
        if strokeIndex + 1 < drawData.count {
            strokeIndex += 1
            progressIndex = 0
        } else {
            isCompleted = true
        }
    }
    
    private func findStartIndex(from index: Int, targets: [CGPoint], point: CGPoint) -> Int? {
        guard index < targets.count else { return nil }
        
        let end = min(index + maxLookahead, targets.count - 1)
        
        var best: Int?
        var bestDist = CGFloat.greatestFiniteMagnitude
        
        for i in index...end {
            let t = targets[i]
            let d = hypot(point.x - t.x, point.y - t.y)
            if d <= threshold, d < bestDist {
                bestDist = d
                best = i
            }
        }
        return best
    }
}

//MARK: NumbersCountView
extension NumbersViewModel {
    var currentCountTask: NumbersCount? {
        guard !countTasks.isEmpty else { return nil }
        let safeIndex = min(countTaskIndex, countTasks.count - 1)
        return countTasks[safeIndex]
    }
    
    var countTotalTasks: Int { countTasks.count }
    
    
    enum CountCheckResult { case correct, wrongHasAttempts, wrongNoAttempts }
    
    func countDigitAsset(for value: Int) -> String {
        items.first(where: { $0.value == value })?.imageDigit.rawValue ?? "\(value)"
    }
    
    func startCountRound(correct: Int, optionsCount: Int = 4, range: ClosedRange<Int> = 1...10) {
        round.attemptsLeft = 3
        round.selected = nil
        round.showWrongText = false
        round.options = makeCountOptions(correct: correct, optionsCount: optionsCount, range: range)
    }
    
    func selectCountOption(_ value: Int) {
        round.selected = value
        round.showWrongText = false
    }
    
    func checkCount(correct: Int) -> CountCheckResult {
        guard let selected = round.selected else {
            return .wrongHasAttempts
        }
        
        if selected == correct {
            round.showWrongText = false
            return .correct
        }
        
        round.attemptsLeft -= 1
        round.showWrongText = true
        
        return round.attemptsLeft <= 0 ? .wrongNoAttempts : .wrongHasAttempts
    }
    
    private func makeCountOptions(
        correct: Int,
        optionsCount: Int,
        range: ClosedRange<Int>
    ) -> [Int] {
        let maxUnique = (range.upperBound - range.lowerBound + 1)
        let targetCount = min(optionsCount, maxUnique)
        
        var set: Set<Int> = [correct]
        while set.count < targetCount {
            set.insert(Int.random(in: range))
        }
        return Array(set).shuffled()
    }
    
    func resetCountProgress() {
        countTaskIndex = 0
    }
    
    func advanceCountTask() -> Bool {
        guard countTaskIndex + 1 < countTasks.count else { return false }
        countTaskIndex += 1
        return true
    }
}

//MARK: NumbersSenseView
extension NumbersViewModel {
    
    enum MatchCheckResult { case correctAll, wrongHasAttempts, wrongNoAttempts }
    
    var matchRounds: [NumbersSensesQuestion] {
          NumbersMatchMockDBData.items
      }
    
    var currentMatchRound: NumbersSensesQuestion? {
        guard !matchRounds.isEmpty else { return nil }
        let i = min(matchRoundIndex, matchRounds.count - 1)
        return matchRounds[i]
    }
    
    var matchTotalRounds: Int { matchRounds.count }
    
    func startMatchRound() {
        guard let round = currentMatchRound else { return }
        
        matchAttemptsLeft = 3
        matchShowWrongText = false
        matchSelectedIndex = nil
        matchPerRowResult = nil
        
        let correct = round.rows.map(\.correctValue)
        matchNumbers = correct.shuffled()
    }
    
    func tapMatchNumber(at index: Int) {
        guard index >= 0, index < matchNumbers.count else { return }
        guard matchPerRowResult == nil else { return } // после Check не двигаем
        
        if let sel = matchSelectedIndex {
            if sel == index {
                matchSelectedIndex = nil
            } else {
                matchNumbers.swapAt(sel, index)
                matchSelectedIndex = nil
            }
        } else {
            matchSelectedIndex = index
        }
    }
    
    func checkMatch() -> MatchCheckResult {
        guard let round = currentMatchRound else { return .wrongHasAttempts }
        
        let correct = round.rows.map(\.correctValue)
        let perRow = zip(matchNumbers, correct).map { $0 == $1 }
        matchPerRowResult = perRow
        
        if perRow.allSatisfy({ $0 }) {
            matchShowWrongText = false
            return .correctAll
        }
        
        matchAttemptsLeft -= 1
        matchShowWrongText = true
        
        return matchAttemptsLeft <= 0 ? .wrongNoAttempts : .wrongHasAttempts
    }
    
    func advanceMatchRound() -> Bool {
        guard matchRoundIndex + 1 < matchRounds.count else { return false }
        matchRoundIndex += 1
        startMatchRound()
        return true
    }
    
    func resetMatchHighlights() {
        matchPerRowResult = nil
        matchSelectedIndex = nil
        matchShowWrongText = false
    }
    
    func digitAsset(for value: Int) -> String {
        items.first(where: { $0.value == value })?.imageDigit.rawValue ?? "\(value)"
    }
}
