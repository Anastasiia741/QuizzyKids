//  ProfileBirthDateSync.swift
//  Quizzy Kids

import Foundation

enum ProfileBirthDateSync {
    static let calendar = Calendar.current
    
    static let storageFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "dd-MM-yyyy"
        f.locale = Locale(identifier: "en_US_POSIX")
        f.timeZone = .current
        return f
    }()
    
    static func ageInFullYears(birthDate: Date, reference: Date = Date()) -> Int {
        let cal = calendar
        let yRef = cal.component(.year, from: reference)
        let yBirth = cal.component(.year, from: birthDate)
        var years = yRef - yBirth
        let bMonth = cal.component(.month, from: birthDate)
        let bDay = cal.component(.day, from: birthDate)
        let rMonth = cal.component(.month, from: reference)
        let rDay = cal.component(.day, from: reference)
        if rMonth < bMonth || (rMonth == bMonth && rDay < bDay) {
            years -= 1
        }
        return max(0, years)
    }
    
    static func birthDateSubtracting(years fullYears: Int, from reference: Date = Date()) -> Date? {
        calendar.date(byAdding: .year, value: -fullYears, to: reference)
    }
    
    static func parseStoredDate(_ string: String) -> Date? {
        let trimmed = string.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return nil }
        if let d = storageFormatter.date(from: trimmed) { return d }
        let alt = DateFormatter()
        alt.dateFormat = "yyyy-MM-dd"
        alt.locale = Locale(identifier: "en_US_POSIX")
        alt.timeZone = .current
        return alt.date(from: trimmed)
    }
    
    static func formatForStorage(_ date: Date) -> String {
        storageFormatter.string(from: date)
    }
    
    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.dateFormat = "d MMM yyyy"
        f.locale = .current
        return f
    }()
    
    static func formatForDisplay(_ date: Date) -> String {
        displayFormatter.string(from: date)
    }
    
    static var selectableRange: ClosedRange<Date> {
        let cal = calendar
        let end = cal.startOfDay(for: Date())
        let start = cal.date(byAdding: .year, value: -120, to: end) ?? end
        return start...end
    }
    
    static func clampToSelectable(_ date: Date) -> Date {
        min(max(date, selectableRange.lowerBound), selectableRange.upperBound)
    }
    
    static func defaultBirthDate() -> Date {
        clampToSelectable(birthDateSubtracting(years: 8, from: Date()) ?? Date())
    }
}
