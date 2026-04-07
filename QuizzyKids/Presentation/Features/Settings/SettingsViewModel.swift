//  SettingsViewModel.swift
//  Quizzy Kids

import Foundation
import FirebaseFirestore
import FirebaseAuth
internal import Combine

@MainActor
final class SettingsViewModel: ObservableObject {
    static let shared = SettingsViewModel()
    
    @Published var profile: UserProfile? = nil
    @Published var isLoading: Bool = false
    @Published var errorMessage: String = ""
    
    @Published var notificationsOn: Bool = true {
        didSet {
            UserDefaults.standard.set(notificationsOn, forKey: Keys.notifications)
            Task { await LocalNotificationScheduler.shared.applySettingsToggle(notificationsOn) }
        }
    }
    
    private let db = Firestore.firestore()
    @Published var isChangingPassword: Bool = false
    @Published var passwordChangeErrorText: String? = nil
    
    
    private enum Keys {
        static let notifications = "settings.notificationsOn"

    }
    
    init() {
        if UserDefaults.standard.object(forKey: Keys.notifications) == nil {
            notificationsOn = true
        } else {
            notificationsOn = UserDefaults.standard.bool(forKey: Keys.notifications)
        }
    }
    
    func loadProfileIfNeeded(user: User?) async {
        guard let user else { return }
        await loadProfile(
            uid: user.uid,
            fallbackName: user.displayName ?? "",
            fallbackEmail: user.email ?? ""
        )
    }
    
    func loadProfile(uid: String, fallbackName: String, fallbackEmail: String) async {
        isLoading = true
        errorMessage = ""
        defer { isLoading = false }
        
        do {
            let snap = try await db.collection("users").document(uid).getDocument()
            if let data = snap.data() {
                let nameFromDoc = (data["name"] as? String)
                    ?? (data["displayName"] as? String)
                    ?? fallbackName
                let email = (data["email"] as? String) ?? fallbackEmail
                let age = Self.stringField(data["age"])
                let date = Self.stringField(data["date"])
                let bonuses = data["bonuses"] as? Int ?? 100
                
                self.profile = UserProfile(
                    id: uid,
                    name: nameFromDoc,
                    email: email,
                    age: age,
                    date: date,
                    bonuses: bonuses
                )
            } else {
                let newProfile = UserProfile(id: uid, name: fallbackName, email: fallbackEmail, bonuses: 100)
                self.profile = newProfile
                try await db.collection("users").document(uid).setData([
                    "name": newProfile.name,
                    "email": newProfile.email.lowercased(),
                    "bonuses": newProfile.bonuses,
                    "createdAt": FieldValue.serverTimestamp()
                ], merge: true)
            }
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private static func stringField(_ value: Any?) -> String? {
        switch value {
        case let s as String: return s.isEmpty ? nil : s
        case let i as Int: return String(i)
        case let d as Double: return String(Int(d))
        default: return nil
        }
    }
    
    func saveProfile(_ draft: UserProfile) async -> Bool {
        profile = draft
        return await saveProfile()
    }
    
    func adjustBonuses(by delta: Int) async {
        guard let user = Auth.auth().currentUser, delta != 0 else { return }
        await loadProfileIfNeeded(user: user)
        guard var p = profile, p.id == user.uid else { return }
        let next = max(0, p.bonuses + delta)
        guard next != p.bonuses else { return }
        p.bonuses = next
        profile = p
        _ = await saveProfile()
    }

    func saveProfile() async -> Bool {
        guard let p = profile else { return false }
        isLoading = true
        errorMessage = ""
        defer { isLoading = false }
        
        do {
            try await db.collection("users").document(p.id).setData([
                "name": p.name,
                "displayName": p.name,
                "email": p.email.lowercased(),
                "age": p.age as Any,
                "date": p.date as Any,
                "bonuses": p.bonuses
            ], merge: true)
            
            if let user = Auth.auth().currentUser, user.uid == p.id {
                do {
                    let change = user.createProfileChangeRequest()
                    change.displayName = p.name
                    try await change.commitChanges()
                } catch {
                    print(error.localizedDescription)
                }
            }
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
    
    func changePassword(to newPassword: String) async -> Bool {
        guard let user = Auth.auth().currentUser else {
            passwordChangeErrorText = "You are not authorized."
            return false
        }
        
        isChangingPassword = true
        defer { isChangingPassword = false }
        
        do {
            try await user.updatePassword(to: newPassword)
            passwordChangeErrorText = nil
            return true
        } catch {
            passwordChangeErrorText = error.localizedDescription
            return false
        }
    }
}
