//  NotificationsView.swift
//  Quizzy Kids

import SwiftUI

struct NotificationsView: View {
    @EnvironmentObject private var coordinator: AppCoordinator
    @ObservedObject private var history = InAppNotificationHistory.shared

    private static let emptyStateMessage = "No notifications right now!\nCome back later for new\nupdates!"

    var body: some View {
        ZStack(alignment: .top) {
            Color.accent100.ignoresSafeArea()

            if history.items.isEmpty {
                VStack(spacing: 16) {
                    Image("ui_shape_09")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 120, height: 123)

                    Text(Self.emptyStateMessage)
                        .font(AppFont.title2())
                        .foregroundColor(.grayscale400)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 185)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
            } else {
                VStack(spacing: 8) {
                    HStack {
                        Spacer()
                        Button("Clear all") {
                            history.removeAll()
                        }
                        .font(AppFont.body2())
                        .foregroundColor(.grayscale400)
                    }
                    .padding(.horizontal, 20)

                    List {
                        ForEach(history.items) { item in
                            NotificationInboxRow(item: item)
                                .listRowInsets(EdgeInsets(top: 6, leading: 20, bottom: 6, trailing: 20))
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteRows)
                    }
                    .listStyle(.plain)
                    .scrollContentBackground(.hidden)
                }
                .padding(.top, 8)
            }
        }
        .safeAreaInset(edge: .top, spacing: 12) {
            HeaderView(
                backgroundImage: nil,
                showsBack: true,
                onBack: { coordinator.pop() },
                title: "Notifications",
                showsTitle: true
            )
        }
        .navigationBarBackButtonHidden(true)
        .task {
            await history.mergeDeliveredFromNotificationCenter()
        }
        .onAppear {
            history.load()
        }
    }

    private func deleteRows(at offsets: IndexSet) {
        let ids = offsets.compactMap { idx -> UUID? in
            guard history.items.indices.contains(idx) else { return nil }
            return history.items[idx].id
        }
        ids.forEach { history.remove(id: $0) }
    }
}

private struct NotificationInboxRow: View {
    let item: InAppNotificationRecord

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(AppFont.subheadline())
                    .foregroundColor(.black)

                Text(item.message)
                    .font(AppFont.body2())
                    .foregroundColor(.grayscale400)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer(minLength: 8)

            Text(item.relativeTimeFormatted)
                .font(AppFont.body2())
                .foregroundColor(.grayscale200)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .circular)
                .fill(.colorF3EAF0)
        )
    }
}
