//  InAppNotificationHistory.swift
//  Quizzy Kids

import Foundation
import UserNotifications
internal import Combine

struct InAppNotificationRecord: Codable, Identifiable, Equatable {
    let id: UUID
    let requestIdentifier: String
    let title: String
    let message: String
    let receivedAt: Date

    var relativeTimeFormatted: String {
        let f = RelativeDateTimeFormatter()
        f.unitsStyle = .abbreviated
        return f.localizedString(for: receivedAt, relativeTo: Date())
    }
}

@MainActor
final class InAppNotificationHistory: ObservableObject {
    static let shared = InAppNotificationHistory()

    @Published private(set) var items: [InAppNotificationRecord] = []

    private let defaults = UserDefaults.standard
    private let storageKey = "inApp.notificationHistory"
    private let maxItems = 100

    private var lastAppendSignature: (String, TimeInterval)?
    private let dedupeWindow: TimeInterval = 2.5

    private init() {
        load()
    }

    func load() {
        guard let data = defaults.data(forKey: storageKey),
              let decoded = try? JSONDecoder().decode([InAppNotificationRecord].self, from: data)
        else {
            items = []
            return
        }
        items = decoded.sorted { $0.receivedAt > $1.receivedAt }
    }

    private func save() {
        let trimmed = Array(items.prefix(maxItems))
        items = trimmed
        if let data = try? JSONEncoder().encode(trimmed) {
            defaults.set(data, forKey: storageKey)
        }
    }

    func recordDelivery(requestIdentifier: String, title: String, body: String, date: Date) {
        let sig = "\(requestIdentifier)|\(body)"
        let ts = date.timeIntervalSince1970
        if let last = lastAppendSignature, last.0 == sig, abs(ts - last.1) < dedupeWindow {
            return
        }
        lastAppendSignature = (sig, ts)

        let nearDuplicate = items.contains {
            $0.requestIdentifier == requestIdentifier
                && $0.message == body
                && abs($0.receivedAt.timeIntervalSince(date)) < dedupeWindow
        }
        if nearDuplicate { return }

        let row = InAppNotificationRecord(
            id: UUID(),
            requestIdentifier: requestIdentifier,
            title: title.isEmpty ? "Quizzy Kids" : title,
            message: body,
            receivedAt: date
        )
        items.insert(row, at: 0)
        save()
    }

    func mergeDeliveredFromNotificationCenter() async {
        let delivered = await fetchDeliveredNotifications()
        for un in delivered {
            let content = un.request.content
            let title = content.title.isEmpty ? "Quizzy Kids" : content.title
            let body = content.body
            let id = un.request.identifier
            let date = un.date
            let exists = items.contains {
                $0.requestIdentifier == id
                    && $0.message == body
                    && abs($0.receivedAt.timeIntervalSince(date)) < 60
            }
            if !exists {
                recordDelivery(requestIdentifier: id, title: title, body: body, date: date)
            }
        }
    }

    private func fetchDeliveredNotifications() async -> [UNNotification] {
        await withCheckedContinuation { cont in
            UNUserNotificationCenter.current().getDeliveredNotifications { cont.resume(returning: $0) }
        }
    }

    func remove(id: UUID) {
        guard let row = items.first(where: { $0.id == id }) else { return }
        items.removeAll { $0.id == id }
        save()
        UNUserNotificationCenter.current().removeDeliveredNotifications(withIdentifiers: [row.requestIdentifier])
    }

    func removeAll() {
        items.removeAll()
        save()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
