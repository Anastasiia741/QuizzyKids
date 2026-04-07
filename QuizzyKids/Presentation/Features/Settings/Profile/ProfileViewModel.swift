//  ProfileViewModel.swift
//  Quizzy Kids

internal import Combine
import FirebaseAuth
import Foundation
import SwiftUI

@MainActor
final class ProfileViewModel: ObservableObject {
    private let settings: SettingsViewModel
    private var cancellables = Set<AnyCancellable>()

    @Published var name = ""
    @Published var email = ""
    @Published var ageText = ""
    @Published var birthDate = ProfileBirthDateSync.defaultBirthDate()
    @Published var bonuses = 100
    @Published var userId = ""

    @Published var selectedAvatar: String = Avatar.avatar01.rawValue

    init(settings: SettingsViewModel) {
        self.settings = settings
        settings.objectWillChange
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)

        settings.$profile
            .map { $0?.bonuses }
            .removeDuplicates()
            .receive(on: RunLoop.main)
            .sink { [weak self] value in
                guard let value else { return }
                self?.bonuses = value
            }
            .store(in: &cancellables)
    }

    convenience init() {
        self.init(settings: SettingsViewModel.shared)
    }

    var isLoading: Bool { settings.isLoading }
    var errorMessage: String { settings.errorMessage }
    var serverProfileName: String? { settings.profile?.name }

    var headerDisplayName: String {
        name.isEmpty ? (serverProfileName ?? "—") : name
    }

    var bonusesDisplay: String {
        "\(bonuses)"
    }

    var birthDateDisplayText: String {
        ProfileBirthDateSync.formatForDisplay(birthDate)
    }

    func syncAgeFromBirthDate() {
        ageText = String(ProfileBirthDateSync.ageInFullYears(birthDate: birthDate))
    }

    func reactToAgeTextChange() {
        let digits = ageText.filter(\.isNumber)
        guard let years = Int(digits), (0...120).contains(years) else { return }
        let current = ProfileBirthDateSync.ageInFullYears(birthDate: birthDate)
        guard years != current else { return }
        guard let shifted = ProfileBirthDateSync.birthDateSubtracting(years: years) else { return }
        birthDate = ProfileBirthDateSync.clampToSelectable(shifted)
    }

    func loadForm(currentUser: User?) async {
        await settings.loadProfileIfNeeded(user: currentUser)
        if let p = settings.profile {
            applyFromProfile(p)
        } else if let u = currentUser {
            userId = u.uid
            name = u.displayName ?? ""
            email = u.email ?? ""
            ageText = ""
            bonuses = 100
            birthDate = ProfileBirthDateSync.defaultBirthDate()
            syncAgeFromBirthDate()
        }
        selectedAvatar = UserDefaults.standard.string(forKey: AvatarStorage.key) ?? Avatar.avatar01.rawValue
    }

    private func applyFromProfile(_ p: UserProfile) {
        userId = p.id
        name = p.name
        email = p.email
        bonuses = p.bonuses
        if let s = p.date, let d = ProfileBirthDateSync.parseStoredDate(s) {
            birthDate = ProfileBirthDateSync.clampToSelectable(d)
        } else if let s = p.age, let y = Int(s.filter(\.isNumber)), (0...120).contains(y),
                  let d = ProfileBirthDateSync.birthDateSubtracting(years: y) {
            birthDate = ProfileBirthDateSync.clampToSelectable(d)
        } else {
            birthDate = ProfileBirthDateSync.defaultBirthDate()
        }
        ageText = String(ProfileBirthDateSync.ageInFullYears(birthDate: birthDate))
    }

    func selectAvatar(assetName: String) {
        selectedAvatar = assetName
        UserDefaults.standard.set(assetName, forKey: AvatarStorage.key)
    }

    func saveDraft() async -> Bool {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedEmail = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let clampedBirth = ProfileBirthDateSync.clampToSelectable(birthDate)
        birthDate = clampedBirth
        let ageForStore = String(ProfileBirthDateSync.ageInFullYears(birthDate: clampedBirth))
        let dateForStore = ProfileBirthDateSync.formatForStorage(clampedBirth)

        name = trimmedName
        email = trimmedEmail
        ageText = ageForStore

        let uid = userId.isEmpty ? (settings.profile?.id ?? "") : userId
        let profile = UserProfile(
            id: uid,
            name: trimmedName,
            email: trimmedEmail,
            age: ageForStore,
            date: dateForStore,
            bonuses: bonuses
        )
        guard !profile.id.isEmpty else { return false }
        return await settings.saveProfile(profile)
    }
}

