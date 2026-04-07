//  FirebaseAnimalRepository.swift
//  Quizzy Kids

import Foundation
import FirebaseFirestore

protocol AnimalRepository {
    func fetchAnimals(level: Int) async throws -> [AnimalItem]
}

final class FirebaseAnimalRepository: AnimalRepository {
    private let db = Firestore.firestore()
    
    func fetchAnimals(level: Int) async throws -> [AnimalItem] {
        
        let snap = try await db.collection("animal_quiz_items")
            .getDocuments()
        
        if snap.documents.isEmpty { return [] }
        
        var result: [AnimalItem] = []
        result.reserveCapacity(snap.documents.count)
        
        for doc in snap.documents {
            let data = doc.data()
            
            guard let name = data["name"] as? String else { continue }
            guard let image = data["image"] as? String else { continue }
            
            result.append(
                AnimalItem(
                    id: doc.documentID,
                    name: name,
                    image: image
                )
            )
        }
        
        return result
    }
}


