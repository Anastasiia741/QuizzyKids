//  LocalNotificationScheduler.swift
//  Quizzy Kids

import Foundation
import UserNotifications

private enum LocalPushID {
    static let reengage = "quizzy.local.reengage"
    static let rewards = "quizzy.local.rewards"
    static let streak = "quizzy.local.streak"
}

@MainActor
final class LocalNotificationScheduler {
    static let shared = LocalNotificationScheduler()

    private let defaults = UserDefaults.standard
    private var pendingRewardAccum = 0

    private enum Keys {
        static let reengagePhase = "push.reengage.phase"
        static let reengageWeekStamps = "push.reengage.weekStamps"
        static let reengageLastScheduleDay = "push.reengage.lastScheduleDay"
        static let rewardsLastDeliveryDay = "push.rewards.lastDeliveryDay"
        static let streakLastScheduledDay = "push.streak.lastScheduledDay"
        static let askedAuth = "push.askedAuthorization"
    }

    private init() {}

    func bootstrapOnLaunch() async {
        guard SettingsViewModel.shared.notificationsOn else { return }
        await requestAuthorizationIfNeeded()
    }

    func applySettingsToggle(_ enabled: Bool) async {
        let center = UNUserNotificationCenter.current()
        if enabled {
            _ = await requestAuthorizationIfNeeded()
        } else {
            center.removeAllPendingNotificationRequests()
            pendingRewardAccum = 0
        }
    }

    @discardableResult
    private func requestAuthorizationIfNeeded() async -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await notificationSettings(center)
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            return true
        case .denied, .notDetermined:
            break
        @unknown default:
            break
        }
        do {
            let ok = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            defaults.set(true, forKey: Keys.askedAuth)
            return ok
        } catch {
            return false
        }
    }

    private func notificationSettings(_ center: UNUserNotificationCenter) async -> UNNotificationSettings {
        await withCheckedContinuation { cont in
            center.getNotificationSettings { cont.resume(returning: $0) }
        }
    }

    private func isAuthorized() async -> Bool {
        let s = await notificationSettings(UNUserNotificationCenter.current())
        switch s.authorizationStatus {
        case .authorized, .provisional, .ephemeral: return true
        default: return false
        }
    }

    func handleSceneBecameActive() async {
        guard await isAuthorized(), SettingsViewModel.shared.notificationsOn else { return }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalPushID.reengage])
        if AppVisitStreak.hasVisitedToday() {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalPushID.streak])
        }
        if pendingRewardAccum > 0 {
            rescheduleRewardNotification()
        }
    }

    func handleSceneDidEnterBackground() async {
        guard SettingsViewModel.shared.notificationsOn, await isAuthorized() else { return }
        scheduleReengageIfAllowed()
        scheduleStreakReminderIfNeeded()
    }

    private func scheduleReengageIfAllowed() {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalPushID.reengage])

        let cal = Calendar.current
        let now = Date()

        let phase = defaults.integer(forKey: Keys.reengagePhase)
        if phase >= 2 {
            defaults.set(0, forKey: Keys.reengagePhase)
            return
        }

        if let lastDay = defaults.object(forKey: Keys.reengageLastScheduleDay) as? TimeInterval,
           cal.isDate(Date(timeIntervalSince1970: lastDay), inSameDayAs: now) {
            return
        }

        var stamps = (defaults.array(forKey: Keys.reengageWeekStamps) as? [TimeInterval] ?? [])
            .filter { now.timeIntervalSince1970 - $0 < 7 * 24 * 3600 }
        defaults.set(stamps, forKey: Keys.reengageWeekStamps)
        guard stamps.count < 3 else { return }

        let body = PushNotificationTexts.reengageBodies.randomElement() ?? PushNotificationTexts.reengageBodies[0]
        let content = UNMutableNotificationContent()
        content.title = "Quizzy Kids"
        content.body = body
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 24 * 3600, repeats: false)
        let request = UNNotificationRequest(identifier: LocalPushID.reengage, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { [weak self] error in
            guard error == nil else { return }
            Task { @MainActor in
                self?.commitReengageScheduled()
            }
        }
    }

    private func commitReengageScheduled() {
        let cal = Calendar.current
        let now = Date()
        var stamps = (defaults.array(forKey: Keys.reengageWeekStamps) as? [TimeInterval] ?? [])
            .filter { now.timeIntervalSince1970 - $0 < 7 * 24 * 3600 }
        stamps.append(now.timeIntervalSince1970)
        defaults.set(stamps, forKey: Keys.reengageWeekStamps)
        defaults.set(cal.startOfDay(for: now).timeIntervalSince1970, forKey: Keys.reengageLastScheduleDay)
        let p = defaults.integer(forKey: Keys.reengagePhase)
        defaults.set(min(p + 1, 2), forKey: Keys.reengagePhase)
    }

    func recordRewardEvents(count: Int) {
        guard SettingsViewModel.shared.notificationsOn else { return }
        pendingRewardAccum += max(1, count)
        Task { await rescheduleRewardNotificationAsync() }
    }

    private func rescheduleRewardNotification() {
        Task { await rescheduleRewardNotificationAsync() }
    }

    private func rescheduleRewardNotificationAsync() async {
        guard SettingsViewModel.shared.notificationsOn, await isAuthorized() else { return }
        guard pendingRewardAccum > 0 else { return }

        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [LocalPushID.rewards])

        let cal = Calendar.current
        let now = Date()
        let todayStart = cal.startOfDay(for: now)

        if let last = defaults.object(forKey: Keys.rewardsLastDeliveryDay) as? TimeInterval {
            let lastDate = Date(timeIntervalSince1970: last)
            if cal.isDate(lastDate, inSameDayAs: now) {
                guard let tomorrow = cal.date(byAdding: .day, value: 1, to: todayStart),
                      let fire = cal.date(bySettingHour: 10, minute: Int.random(in: 0 ... 30), second: 0, of: tomorrow)
                else { return }

                let content = UNMutableNotificationContent()
                content.title = "Quizzy Kids"
                content.body = rewardBody(for: pendingRewardAccum)
                content.sound = .default
                let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: fire)
                let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
                let request = UNNotificationRequest(identifier: LocalPushID.rewards, content: content, trigger: trigger)
                center.add(request, withCompletionHandler: nil)
                return
            }
        }

        let delay: TimeInterval = Double(Int.random(in: 300 ... 600))
        let content = UNMutableNotificationContent()
        content.title = "Quizzy Kids"
        content.body = rewardBody(for: pendingRewardAccum)
        content.sound = .default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: LocalPushID.rewards, content: content, trigger: trigger)
        center.add(request, withCompletionHandler: nil)
    }

    private func rewardBody(for count: Int) -> String {
        if count > 1 {
            return PushNotificationTexts.mergedRewardsBody(count: count)
        }
        return PushNotificationTexts.rewardBodies.randomElement() ?? PushNotificationTexts.rewardBodies[0]
    }

    func handleRewardNotificationDelivered() {
        let cal = Calendar.current
        defaults.set(cal.startOfDay(for: Date()).timeIntervalSince1970, forKey: Keys.rewardsLastDeliveryDay)
        pendingRewardAccum = 0
    }

    private func scheduleStreakReminderIfNeeded() {
        guard !AppVisitStreak.hasVisitedToday() else {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [LocalPushID.streak])
            return
        }

        let cal = Calendar.current
        let now = Date()

        if let last = defaults.object(forKey: Keys.streakLastScheduledDay) as? TimeInterval {
            let d = Date(timeIntervalSince1970: last)
            if cal.isDate(d, inSameDayAs: now) { return }
        }

        guard let fire = nextStreakFireDate(from: now) else { return }

        let streak = max(1, AppVisitStreak.consecutiveDays)
        let pool = PushNotificationTexts.streakBodies(streakDays: streak)
        let body = pool.randomElement() ?? pool[0]

        let content = UNMutableNotificationContent()
        content.title = "Quizzy Kids"
        content.body = body
        content.sound = .default

        let comps = cal.dateComponents([.year, .month, .day, .hour, .minute], from: fire)
        let trigger = UNCalendarNotificationTrigger(dateMatching: comps, repeats: false)
        let request = UNNotificationRequest(identifier: LocalPushID.streak, content: content, trigger: trigger)

        let scheduledDayStamp = cal.startOfDay(for: Date()).timeIntervalSince1970
        UNUserNotificationCenter.current().add(request) { [weak self] _ in
            Task { @MainActor in
                self?.defaults.set(scheduledDayStamp, forKey: Keys.streakLastScheduledDay)
            }
        }
    }

    private func nextStreakFireDate(from now: Date) -> Date? {
        let cal = Calendar.current

        for dayOffset in 0..<8 {
            guard let day = cal.date(byAdding: .day, value: dayOffset, to: cal.startOfDay(for: now)) else { continue }
            let wd = cal.component(.weekday, from: day)
            let weekend = (wd == 1 || wd == 7)

            let candidates: [Date]
            if weekend {
                let morning = randomDate(on: day, hourRange: 10 ... 11, cal: cal)
                let evening = randomDate(on: day, hourRange: 17 ... 19, cal: cal)
                candidates = [morning, evening].compactMap { $0 }.sorted()
            } else {
                candidates = [randomDate(on: day, hourRange: 17 ... 19, cal: cal)].compactMap { $0 }
            }

            for candidate in candidates where candidate > now {
                return candidate
            }
        }
        return nil
    }

    private func randomDate(on day: Date, hourRange: ClosedRange<Int>, cal: Calendar) -> Date? {
        let hour = Int.random(in: hourRange)
        let minute = Int.random(in: 0 ... 59)
        return cal.date(bySettingHour: hour, minute: minute, second: 0, of: day)
    }

    func handleNotificationDelivered(_ notification: UNNotification) {
        let id = notification.request.identifier
        let content = notification.request.content
        InAppNotificationHistory.shared.recordDelivery(
            requestIdentifier: id,
            title: content.title,
            body: content.body,
            date: notification.date
        )
        switch id {
        case LocalPushID.rewards:
            handleRewardNotificationDelivered()
        default:
            break
        }
    }
}
