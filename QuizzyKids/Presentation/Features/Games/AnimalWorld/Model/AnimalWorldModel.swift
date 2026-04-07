//  AnimalWorldModel.swift
//  Quizzy Kids

import Foundation

struct AnimalWorldModel {
    let id = UUID()
      let images: [AnimalWorld]
      let oddOne: AnimalWorld
      let title: String?
}


struct AnimalWorldQuestion {
    var items: [AnimalWorldItem] = []
    var attemptsLeft: Int = 3
    var showWrongText: Bool = false

    var selectedID: UUID? = nil
    var wrongID: UUID? = nil
    var isLocked: Bool = false

}

struct AnimalWorldItem: Identifiable, Equatable {
    let id = UUID()
    let image: AnimalWorld
}

enum AnimalWorldMockDB {
    static let items: [AnimalWorldModel] = [
        .init(images: [.cat, .dog, .lion, .cow], oddOne: .lion, title: "Domestic animals"),
        .init(images: [.lion, .panda, .cat, .dog], oddOne: .panda, title: "Predators"),
        .init(images: [.cow, .elephant, .panda, .lion], oddOne: .lion, title: "Herbivores"),
        .init(images: [.fish, .lion, .penguin, .frog], oddOne: .lion, title: "Water animals"),
        .init(images: [.dog, .cat, .cow, .fish], oddOne: .fish, title: "Land animals"),
        .init(images: [.cat, .dog, .bee, .owl,], oddOne: .bee, title: "Not an insect"),
        .init(images: [.frog, .owl, .duck, .seagull, ], oddOne: .frog, title: "Birds"),
        .init(images: [.lion, .elephant, .cow, .panda,], oddOne: .cow, title: "Wild animals"),
        .init(images: [.penguin, .fish, .owl, .lion], oddOne: .lion, title: "Cold places"),
        .init(images: [.lion,  .panda, .elephant, .cow], oddOne: .panda, title: "Tropical animals")
    ]
}



