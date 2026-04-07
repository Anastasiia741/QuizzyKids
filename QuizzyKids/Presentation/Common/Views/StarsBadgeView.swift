//  StarsBadgeView.swift
//  Quizzy Kids

import SwiftUI

struct StarsBadgeView: View {
    let starsCount: Int
    let onTap: (() -> Void)?

    init(starsCount: Int = 18, onTap: (() -> Void)? = nil) {
        self.starsCount = starsCount
        self.onTap = onTap
    }

    var body: some View {
        Button {
            onTap?()
        } label: {
            HStack(spacing: 8) {
                Text("\(starsCount)")
                    .font(AppFont.body2())
                    .foregroundColor(.black)
                Image("ui_icons_13")
                    .resizable()
                    .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 7)
            .background(.accent300)
            .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }
}
