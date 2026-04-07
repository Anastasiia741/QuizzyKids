//  StreakCellView.swift
//  Quizzy Kids

import SwiftUI

struct StreakCellView: View {
    let dayText: String
    let active: Bool
    let iconBoxSize: CGSize
    let cellMinHeight: CGFloat

    init(
        dayText: String,
        active: Bool,
        iconBoxSize: CGSize = .init(width: 62, height: 45),
        cellMinHeight: CGFloat = 74
    ) {
        self.dayText = dayText
        self.active = active
        self.iconBoxSize = iconBoxSize
        self.cellMinHeight = cellMinHeight
    }

    var body: some View {
        VStack(spacing: 2) {
            VStack {
                Image(Icons.icon05.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .frame(width: iconBoxSize.width, height: iconBoxSize.height)
            .background(
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(Color.accent100)
            )

            Text(dayText)
                .font(AppFont.footnote())
                .foregroundColor(.white)
        }
        .frame(maxWidth: .infinity, minHeight: cellMinHeight)
        .padding(.vertical, 2)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(active ? Color.secondary200 : Color.secondary200.opacity(0.25))
        )
    }
}


