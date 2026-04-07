//  AnimalURLCache.swift
//  Quizzy Kids

import Foundation

final class AnimalURLCache {
    static let shared = AnimalURLCache()
    private init() {}
    
    private let key = "animal_quiz_download_urls"
    
    private var dict: [String: String] {
        get {
            guard let data = UserDefaults.standard.data(forKey: key),
                  let obj = try? JSONDecoder().decode([String: String].self, from: data)
            else { return [:] }
            return obj
        }
        set {
            let data = try? JSONEncoder().encode(newValue)
            UserDefaults.standard.set(data, forKey: key)
        }
    }
    
    func get(forPath path: String) -> URL? {
        guard let s = dict[path] else { return nil }
        return URL(string: s)
    }
    
    func set(_ url: URL, forPath path: String) {
        var d = dict
        d[path] = url.absoluteString
        dict = d
    }
}

