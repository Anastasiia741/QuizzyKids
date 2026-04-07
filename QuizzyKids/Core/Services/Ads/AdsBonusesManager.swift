//  StorageService.swift
//  Quizzy Kids

import SwiftUI
import FirebaseAuth
import FirebaseFirestore
internal import Combine


@MainActor
final class BonusesManager: ObservableObject {
    
    static let shared = BonusesManager()
    
    @Published private(set) var bonuses: Int = 0
    
    private let db = Firestore.firestore()
    private let cacheKey = "cached_user_bonuses"
    
    private init() {
        bonuses = UserDefaults.standard.integer(forKey: cacheKey)
    }
    
    func load() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        do {
            let doc = try await db.collection("users")
                .document(uid)
                .getDocument()
            
            let value = doc.data()?["bonuses"] as? Int ?? 0
            setLocal(value)
            
        } catch {
            print("Bonuses load error:", error)
        }
    }
    
    func add(_ value: Int) async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let ref = db.collection("users").document(uid)
        
        do {
            try await ref.updateData([
                "bonuses": FieldValue.increment(Int64(value))
            ])
            
            let newLocal = max(0, bonuses + value)
            setLocal(newLocal)
            
        } catch {
            print("🔥 Bonuses update error:", error)
        }
    }
    
    private func setLocal(_ value: Int) {
        bonuses = value
        UserDefaults.standard.set(value, forKey: cacheKey)
    }
}
