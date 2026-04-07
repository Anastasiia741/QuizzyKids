//  AvatarPickerSheet.swift
//  Quizzy Kids

import SwiftUI

struct AvatarPickerSheet: View {
    @Binding var selectedAvatar: String
    let onSelect: (String) -> Void

    private let avatars = AvatarStorage.all
    private let columnCount = 4
    private let gridSpacing: CGFloat = 12
    private let horizontalInset: CGFloat = 24
    private let verticalInset: CGFloat = 16

    private var gridColumns: [GridItem] {
        Array(
            repeating: GridItem(.flexible(minimum: 0), spacing: gridSpacing, alignment: .center),
            count: columnCount
        )
    }

    var body: some View {
        VStack(spacing: 16) {
            Capsule()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 44, height: 5)
                .padding(.top, 10)

            Text("Choose avatar")
                .font(AppFont.headline())
                .foregroundColor(.black)

            LazyVGrid(columns: gridColumns, alignment: .center, spacing: gridSpacing) {
                ForEach(avatars, id: \.self) { avatar in
                    Button {
                        onSelect(avatar)
                    } label: {
                        Color.clear
                            .aspectRatio(1, contentMode: .fit)
                            .overlay {
                                Image(avatar)
                                    .resizable()
                                    .scaledToFill()
                            }
                            .clipShape(Circle())
                            .overlay(
                                Circle().stroke(
                                    avatar == selectedAvatar ? Color.secondary200 : Color.clear,
                                    lineWidth: 2
                                )
                            )
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.horizontal, horizontalInset)
        .padding(.bottom, verticalInset)
    }
}
