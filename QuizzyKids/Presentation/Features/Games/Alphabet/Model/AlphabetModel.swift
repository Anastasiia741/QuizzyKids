//  AlphabetItem.swift
//  Quizzy Kids

import Foundation

struct AlphabetModel: Identifiable, Equatable {
    let id = UUID()
    let letter: String
    let word: String
    let image: AlphabetAnimal
    let letterSoundName: String
}

enum AlphabetData {
    static let items: [AlphabetModel] = [
        .init(
            letter: "A",
            word: "alligator",
            image: .alligator,
            letterSoundName: "A"
        ),
        .init(
            letter: "B",
            word: "bear",
            image: .bear,
            letterSoundName: "B"
        ),
        .init(
            letter: "C",
            word: "cat",
            image: .cat,
            letterSoundName: "C"
        ),
        .init(
            letter: "D",
            word: "duck",
            image: .duck,
            letterSoundName: "D"
        ),
        .init(
            letter: "E",
            word: "elephant",
            image: .elephant,
            letterSoundName: "E"
        ),
        .init(
            letter: "F",
            word: "fish",
            image: .fish,
            letterSoundName: "F"
        ),
        .init(
            letter: "G",
            word: "giraffe",
            image: .giraffe,
            letterSoundName: "G"
        ),
        .init(
            letter: "H",
            word: "horse",
            image: .horse,
            letterSoundName: "H"
        ),
        .init(
            letter: "I",
            word: "iguana",
            image: .iguana,
            letterSoundName: "I"
        ),
        .init(
            letter: "J",
            word: "jellyfish",
            image: .jellyfish,
            letterSoundName: "J"
        ),
        .init(
            letter: "K",
            word: "kangaroo",
            image: .kangaroo,
            letterSoundName: "K"
        ),
        .init(
            letter: "L",
            word: "lion",
            image: .lion,
            letterSoundName: "L"
        ),
        .init(
            letter: "M",
            word: "monkey",
            image: .monkey,
            letterSoundName: "M"
        ),
        .init(
            letter: "N",
            word: "narwhal",
            image: .narwhal,
            letterSoundName: "N"
        ),
        .init(
            letter: "O",
            word: "owl",
            image: .owl,
            letterSoundName: "O"
        ),
        .init(
            letter: "P",
            word: "panda",
            image: .panda,
            letterSoundName: "P"
        ),
        .init(
            letter: "Q",
            word: "quokka",
            image: .quokka,
            letterSoundName: "Q"
        ),
        .init(
            letter: "R",
            word: "rabbit",
            image: .rabbit,
            letterSoundName: "R"
        ),
        .init(
            letter: "S",
            word: "snake",
            image: .snake,
            letterSoundName: "S"
        ),
        .init(
            letter: "T",
            word: "tiger",
            image: .tiger,
            letterSoundName: "T"
        ),
        .init(
            letter: "U",
            word: "unicorn",
            image: .unicorn,
            letterSoundName: "U"
        ),
        .init(
            letter: "V",
            word: "vulture",
            image: .vulture,
            letterSoundName: "V"
        ),
        .init(
            letter: "W",
            word: "whale",
            image: .whale,
            letterSoundName: "W"
        ),
        .init(
            letter: "X",
            word: "x-ray fish",
            image: .xRayfish,
            letterSoundName: "X"
        ),
        .init(
            letter: "Y",
            word: "yak",
            image: .yak,
            letterSoundName: "Y"
        ),
        .init(
            letter: "Z",
            word: "zebra",
            image: .zebra,
            letterSoundName: "Z"
        ),
    ]
    static func item(for letter: String) -> AlphabetModel? {
        items.first { $0.letter == letter }
    }
}
