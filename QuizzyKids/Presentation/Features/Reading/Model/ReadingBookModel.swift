//  ReadingBook.swift
//  Quizzy Kids

import Foundation

struct ReadingBookModel: Identifiable, Hashable {
    let id: String
    let title: String
    let image: BooksImages
    let pages: [String]
  
    var imageName: String { image.rawValue }
}

enum ReadingMockDB {
    static let books: [ReadingBookModel] = [
        .init(
            id: "turtle",
            title: "Toby the Turtle’s\nBig Trip",
            image: .level01,
            pages: [
                "Toby was a little turtle who lived in a quiet pond. He loved swimming, napping, and watching dragonflies. But Toby had a big dream.",
                "“I did it!” he shouted. “I made it all the way here!” Toby may have been a small turtle.",
                "Toby looked at the sea and smiled.”",
                "The road was long, but Toby stayed brave.",
                "He met a bird who sang a happy song.",
                "They crossed a bridge and saw bright flowers.",
                "At night, Toby watched the stars.",
                "In the morning, he helped a small snail.",
                "Finally, Toby reached a beautiful hill."
            ]
        ),
        .init(
            id: "moon",
            title: "The Moon That\nCouldn't Sleep",
            image: .level02,
            pages: [
                "The Moon blinked in the sky, wide awake.",
                "“I can’t sleep,” the Moon sighed softly.",
                "The stars twinkled and said, “Try counting us!”",
                "The Moon counted—one, two, three… but stayed bright.",
                "A little cloud floated by and sang a sleepy song.",
                "The Moon listened, but still couldn’t yawn.",
                "Then the wind whispered, “Let your light be gentle.”",
                "The Moon glowed smaller and softer, like a night lamp.",
                "At last, the Moon smiled and drifted into dreamy sleep."
            ]
        ),
        .init(
            id: "pencil",
            title: "Milo and the\nMagic Pencil",
            image: .level03,
            pages: [
                "Milo found a pencil under a big green tree.",
                "It sparkled as if it had a secret to share.",
                "Milo drew a tiny cookie—pop! A real cookie appeared!",
                "He drew a ball—bounce! It rolled across the grass.",
                "Milo giggled and drew a kite with a long tail.",
                "Whoosh! The kite flew up high in the wind.",
                "But then Milo drew too many toys and made a big mess.",
                "“Magic is best with care,” the pencil seemed to say.",
                "Milo drew a clean-up box, smiled, and shared the magic."
            ]
        ),
        .init(
            id: "clouds",
            title: "Colors in the\nClouds",
            image: .level04,
            pages: [
                "Lina looked up and saw clouds like fluffy pillows.",
                "One cloud was pink, like cotton candy in the sky.",
                "Another cloud turned orange, like a warm sunset.",
                "A blue cloud floated by, calm as the sea.",
                "Then a purple cloud appeared, quiet and dreamy.",
                "Lina waved her hands and imagined painting the sky.",
                "The clouds danced and mixed their colors together.",
                "A rainbow peeked out and said, “Hello!”",
                "Lina smiled and whispered, “Thank you, colorful clouds.”"
            ]
        ),
        .init(
            id: "zebra",
            title: "Zebra and Her\nRainbow Stripes",
            image: .level05,
            pages: [
                "Zara the zebra looked at her stripes and sighed.",
                "“I wish my stripes had colors,” she whispered.",
                "A butterfly fluttered by and sprinkled shiny dust.",
                "One stripe turned red like an apple—wow!",
                "Another stripe became yellow like the sun.",
                "A blue stripe appeared, cool as a river.",
                "Soon Zara had green, purple, and orange too.",
                "Zara ran and her rainbow stripes sparkled brightly.",
                "She smiled and said, “My stripes are perfect—just like me!”"
            ]
        ),
        .init(
            id: "leo",
            title: "Leo the Brave\nLittle Lion",
            image: .level06,
            pages: [
                "Leo was a little lion with a big brave heart.",
                "But one day, a loud thunder made him jump.",
                "Leo took a deep breath and counted to three.",
                "He found a tiny bird shivering in the rain.",
                "“Don’t worry,” Leo said, “I will help you.”",
                "Leo held a leaf like an umbrella over the bird.",
                "They walked together to a cozy cave nearby.",
                "The thunder faded, and the bird felt safe again.",
                "Leo smiled: “Being brave means helping, even when you’re scared.”"
            ]
        ),
        .init(
            id: "wonders",
            title: "The Flying Book\nof Wonders",
            image: .level07,
            pages: [
                "Mia opened an old book and heard a tiny “whoosh!”",
                "The book shook, spread pages like wings, and lifted up.",
                "“Hold on!” the book seemed to giggle.",
                "It flew over a garden full of glowing flowers.",
                "Next, it zoomed past a mountain made of soft clouds.",
                "Mia saw fish swimming in the air like balloons.",
                "They visited a city where houses were made of candy.",
                "Mia laughed and waved to friendly flying cats.",
                "The book gently landed at home and closed: “Wonders are everywhere.”"
            ]
        ),
    ]

    static func book(id: String) -> ReadingBookModel? {
        books.first { $0.id == id }
    }
}
