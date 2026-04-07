//  UserProfile.swift
//  Quizzy Kids

import Foundation

struct UserProfile: Codable, Identifiable {
    var id: String
    var name: String
    var email: String
    var age: String?
    var date: String?
    var bonuses: Int

    init(
        id: String,
        name: String,
        email: String,
        age: String? = nil,
        date: String? = nil,
        bonuses: Int = 100
    ) {
        self.id = id
        self.name = name
        self.email = email
        self.age = age
        self.date = date
        self.bonuses = bonuses
    }
}


extension UserProfile {
    var resolvedBirthDate: Date {
        if let s = date, let parsed = ProfileBirthDateSync.parseStoredDate(s) {
            return ProfileBirthDateSync.clampToSelectable(parsed)
        }
        if let s = age, let years = Int(s.filter(\.isNumber)), (0...120).contains(years),
           let d = ProfileBirthDateSync.birthDateSubtracting(years: years) {
            return ProfileBirthDateSync.clampToSelectable(d)
        }
        return ProfileBirthDateSync.defaultBirthDate()
    }

    mutating func applyBirthDate(_ raw: Date) {
        let clamped = ProfileBirthDateSync.clampToSelectable(raw)
        age = String(ProfileBirthDateSync.ageInFullYears(birthDate: clamped))
        date = ProfileBirthDateSync.formatForStorage(clamped)
    }

    mutating func applyAgeFullYearsIfValid(_ text: String) {
        let digits = text.filter(\.isNumber)
        guard let years = Int(digits), (0...120).contains(years) else { return }
        let current = ProfileBirthDateSync.ageInFullYears(birthDate: resolvedBirthDate)
        guard years != current else { return }
        guard let shifted = ProfileBirthDateSync.birthDateSubtracting(years: years) else { return }
        applyBirthDate(shifted)
    }
}
