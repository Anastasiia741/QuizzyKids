//  BottomPanel.swift
//  Quizzy Kids

import SwiftUI

struct BottomView: View {
    @Environment(\.horizontalSizeClass) private var hSizeClass
    
    let options: [Int]
    let selected: Int?
    let onTap: (Int) -> Void
    let content: (Int) -> CircleButtonContent
    
    var showsBottomButton: Bool
    var bottomButtonTitle: String
    var onBottomButtonTap: (() -> Void)?
    
    var columnsCount: Int?
    
    private let hPadding: CGFloat = 16
    private let spacing: CGFloat = 12
    private let rowSpacing: CGFloat = 12
    
    private var bottomPadding: CGFloat { isPadLike ? 18 : 0 }
    private var isPadLike: Bool {
        (hSizeClass == .regular) || (UIDevice.current.userInterfaceIdiom == .pad)
    }
    
    private var buttonHeight: CGFloat { 44 }
    
    private var isTextMode: Bool {
        guard let first = options.first else { return false }
        if case .text = content(first) { return true }
        return false
    }
    
    private var resolvedColumnsCount: Int {
        if let columnsCount { return max(1, columnsCount) }
        
        if isTextMode { return isPadLike ? 6 : 7 }
        return min(5, max(options.count, 1))
    }
    
    private var columns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(), spacing: spacing, alignment: .center),
            count: resolvedColumnsCount
        )
    }
    
    init(
        options: [Int],
        selected: Int?,
        onTap: @escaping (Int) -> Void,
        content: @escaping (Int) -> CircleButtonContent,
        showsBottomButton: Bool = false,
        bottomButtonTitle: String = "Check",
        onBottomButtonTap: (() -> Void)? = nil,
        columnsCount: Int? = nil
    ) {
        self.options = options
        self.selected = selected
        self.onTap = onTap
        self.content = content
        self.showsBottomButton = showsBottomButton
        self.bottomButtonTitle = bottomButtonTitle
        self.onBottomButtonTap = onBottomButtonTap
        self.columnsCount = columnsCount
    }
    
    var body: some View {
        VStack(spacing: 0) {
            
            LazyVGrid(columns: columns, alignment: .center, spacing: rowSpacing) {
                ForEach(options, id: \.self) { value in
                    CircleButton(
                        content: content(value),
                        isSelected: selected == value,
                        action: { onTap(value) },
                    )
                }
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.horizontal, hPadding)
            .padding(.top, isPadLike ? 0 : 6)
            
            if showsBottomButton, let tap = onBottomButtonTap {
                Spacer().frame(height: 20)
                
                Button(bottomButtonTitle) { tap() }
                    .buttonStyle(AppButtonStyle(type: .primary))
                    .frame(height: buttonHeight)
                    .padding(.horizontal, hPadding)
                    .padding(.bottom)
            }
            
        }
        .frame(maxWidth: .infinity, alignment: isPadLike ? .center : .bottom)
        .background(
            Image(Background.bg08.rawValue)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
        )
    }
}
