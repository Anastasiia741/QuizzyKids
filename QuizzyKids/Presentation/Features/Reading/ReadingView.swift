//  ReadingView.swift
//  Quizzy Kids

import SwiftUI

struct ReadingView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    private let items = ReadingMockDB.books

    var body: some View {
        ZStack {
            Color.accent100
                .ignoresSafeArea()
            ScrollView(showsIndicators: false) {
                          LazyVGrid(
                              columns: [GridItem(.flexible()), GridItem(.flexible())],
                              spacing: 12
                          ) {
                              ForEach(items, id: \.id) { book in
                                  Button {
                                      coordinator.push(.readingGame(bookID: book.id))
                                  } label: {
                                      CardView(image: book.imageName) // ✅ тут rawValue
                                  }
                                  .buttonStyle(.plain)
                              }
                          }
                        

                    
                    .padding(.horizontal, 20)
                }
            }
            .safeAreaInset(edge: .top, spacing: 12) {
                HeaderView(
                    titleTop: "Good morning",
//                    name: "Jane Cooper",
                    showsStarsBadge: true,
//                    starsCount: 18,
                    onTapStars: { coordinator.present(.scoreView) }
                )
            }
        }
}


