//  FindDifferences.swift
//  Quizzy Kids

import Foundation
import SwiftUI

struct DiffPoint: Identifiable, Hashable {
    let id: String
    let x: CGFloat
    let y: CGFloat
    let radius: CGFloat
}


enum FindDifferencesMockDB {

    static let ids: [String] = (1...20).map { "dif\($0)" }

    private static let map: [String: [DiffPoint]] = [
        "dif1": [
            DiffPoint(id: "d1", x: 0.43, y: 0.264, radius: 0.06),
            DiffPoint(id: "d2", x: 0.497, y: 0.395, radius: 0.06),
        ],

        "dif2": [
            DiffPoint(id: "d1", x: 0.476, y: 0.784, radius: 0.06),
            DiffPoint(id: "d2", x: 0.436, y: 0.223, radius: 0.06),
        ],

        "dif3": [
            DiffPoint(id: "d1", x: 0.856, y: 0.112, radius: 0.06),
            DiffPoint(id: "d2", x: 0.891, y: 0.513, radius: 0.06),
            DiffPoint(id: "d3", x: 0.296, y: 0.926, radius: 0.06),
            DiffPoint(id: "d4", x: 0.134, y: 0.705, radius: 0.06),
            DiffPoint(id: "d5", x: 0.393, y: 0.616, radius: 0.06),
        ],

        "dif4": [
            DiffPoint(id: "d1", x: 0.276, y: 0.537, radius: 0.06),
            DiffPoint(id: "d2", x: 0.465, y: 0.402, radius: 0.06),
            DiffPoint(id: "d3", x: 0.937, y: 0.536, radius: 0.06),
            DiffPoint(id: "d4", x: 0.239, y: 0.988, radius: 0.06),
            DiffPoint(id: "d5", x: 0.794, y: 0.765, radius: 0.06),
        ],

        "dif5": [
            DiffPoint(id: "d1", x: 0.434, y: 0.195, radius: 0.06),
            DiffPoint(id: "d2", x: 0.132, y: 0.55, radius: 0.06),
            DiffPoint(id: "d3", x: 0.46, y: 0.42, radius: 0.06),
            DiffPoint(id: "d4", x: 0.832, y: 0.974, radius: 0.06),
            DiffPoint(id: "d5", x: 0.137, y: 0.695, radius: 0.06),
            DiffPoint(id: "d6", x: 0.347, y: 0.36, radius: 0.06),
        ],

        "dif6": [
            DiffPoint(id: "d1", x: 0.672, y: 0.619, radius: 0.06),
            DiffPoint(id: "d2", x: 0.385, y: 0.279, radius: 0.06),
            DiffPoint(id: "d3", x: 0.216, y: 0.575, radius: 0.06),
            DiffPoint(id: "d4", x: 0.147, y: 0.113, radius: 0.06),
            DiffPoint(id: "d5", x: 0.646, y: 0.304, radius: 0.06),
            DiffPoint(id: "d6", x: 0.557, y: 0.922, radius: 0.06),
        ],

        "dif7": [
            DiffPoint(id: "d1", x: 0.529, y: 0.286, radius: 0.06),
            DiffPoint(id: "d2", x: 0.829, y: 0.183, radius: 0.06),
            DiffPoint(id: "d3", x: 0.963, y: 0.349, radius: 0.06),
            DiffPoint(id: "d4", x: 0.101, y: 0.46, radius: 0.06),
            DiffPoint(id: "d5", x: 0.193, y: 0.963, radius: 0.06),
            DiffPoint(id: "d6", x: 0.404, y: 0.677, radius: 0.06),
            DiffPoint(id: "d7", x: 0.179, y: 0.24, radius: 0.06),
            DiffPoint(id: "d8", x: 0.878, y: 0.746, radius: 0.06),
        ],

        "dif8": [
            DiffPoint(id: "d1", x: 0.777, y: 0.094, radius: 0.06),
            DiffPoint(id: "d2", x: 0.497, y: 0.727, radius: 0.06),
            DiffPoint(id: "d3", x: 0.752, y: 0.523, radius: 0.06),
            DiffPoint(id: "d4", x: 0.926, y: 0.815, radius: 0.06),
            DiffPoint(id: "d5", x: 0.502, y: 0.929, radius: 0.06),
            DiffPoint(id: "d6", x: 0.205, y: 0.902, radius: 0.06),
            DiffPoint(id: "d7", x: 0.246, y: 0.193, radius: 0.06),
            DiffPoint(id: "d8", x: 0.469, y: 0.16, radius: 0.06),
        ],

        "dif9": [
            DiffPoint(id: "d1", x: 0.568, y: 0.186, radius: 0.06),
            DiffPoint(id: "d2", x: 0.723, y: 0.369, radius: 0.06),
            DiffPoint(id: "d3", x: 0.868, y: 0.66, radius: 0.06),
            DiffPoint(id: "d4", x: 0.574, y: 0.729, radius: 0.06),
            DiffPoint(id: "d5", x: 0.224, y: 0.593, radius: 0.06),
            DiffPoint(id: "d6", x: 0.124, y: 0.357, radius: 0.06),
            DiffPoint(id: "d7", x: 0.18, y: 0.077, radius: 0.06),
            DiffPoint(id: "d8", x: 0.747, y: 0.045, radius: 0.06),
        ],

        "dif10": [
            DiffPoint(id: "d1", x: 0.392, y: 0.453, radius: 0.06),
            DiffPoint(id: "d2", x: 0.852, y: 0.401, radius: 0.06),
            DiffPoint(id: "d3", x: 0.441, y: 0.716, radius: 0.06),
            DiffPoint(id: "d4", x: 0.408, y: 0.546, radius: 0.06),
            DiffPoint(id: "d5", x: 0.11, y: 0.725, radius: 0.06),
            DiffPoint(id: "d6", x: 0.022, y: 0.424, radius: 0.06),
            DiffPoint(id: "d7", x: 0.832, y: 0.135, radius: 0.06),
            DiffPoint(id: "d8", x: 0.703, y: 0.541, radius: 0.06),
        ],

        "dif11": [
            DiffPoint(id: "d1", x: 0.559, y: 0.496, radius: 0.06),
            DiffPoint(id: "d2", x: 0.614, y: 0.263, radius: 0.06),
            DiffPoint(id: "d3", x: 0.927, y: 0.507, radius: 0.06),
            DiffPoint(id: "d4", x: 0.512, y: 0.127, radius: 0.06),
            DiffPoint(id: "d5", x: 0.077, y: 0.2, radius: 0.06),
            DiffPoint(id: "d6", x: 0.038, y: 0.915, radius: 0.06),
            DiffPoint(id: "d7", x: 0.323, y: 0.852, radius: 0.06),
            DiffPoint(id: "d8", x: 0.561, y: 0.867, radius: 0.06),
        ],

        "dif12": [
            DiffPoint(id: "d1", x: 0.319, y: 0.05, radius: 0.06),
            DiffPoint(id: "d2", x: 0.459, y: 0.413, radius: 0.06),
            DiffPoint(id: "d3", x: 0.585, y: 0.06, radius: 0.06),
            DiffPoint(id: "d4", x: 0.87, y: 0.074, radius: 0.06),
            DiffPoint(id: "d5", x: 0.574, y: 0.626, radius: 0.06),
            DiffPoint(id: "d6", x: 0.908, y: 0.514, radius: 0.06),
            DiffPoint(id: "d7", x: 0.314, y: 0.879, radius: 0.06),
            DiffPoint(id: "d8", x: 0.222, y: 0.634, radius: 0.06),
            DiffPoint(id: "d9", x: 0.05, y: 0.531, radius: 0.06),
            DiffPoint(id: "d10", x: 0.053, y: 0.251, radius: 0.06),
        ],

        "dif13": [
            DiffPoint(id: "d1", x: 0.152, y: 0.368, radius: 0.06),
            DiffPoint(id: "d2", x: 0.294, y: 0.095, radius: 0.06),
            DiffPoint(id: "d3", x: 0.658, y: 0.181, radius: 0.06),
            DiffPoint(id: "d4", x: 0.955, y: 0.255, radius: 0.06),
            DiffPoint(id: "d5", x: 0.878, y: 0.412, radius: 0.06),
            DiffPoint(id: "d6", x: 0.546, y: 0.35, radius: 0.06),
            DiffPoint(id: "d7", x: 0.294, y: 0.457, radius: 0.06),
            DiffPoint(id: "d8", x: 0.269, y: 0.81, radius: 0.06),
            DiffPoint(id: "d9", x: 0.636, y: 0.946, radius: 0.06),
        ],

        "dif14": [
            DiffPoint(id: "d1", x: 0.191, y: 0.046, radius: 0.06),
            DiffPoint(id: "d2", x: 0.458, y: 0.289, radius: 0.06),
            DiffPoint(id: "d3", x: 0.392, y: 0.349, radius: 0.06),
            DiffPoint(id: "d4", x: 0.696, y: 0.121, radius: 0.06),
            DiffPoint(id: "d5", x: 0.774, y: 0.32, radius: 0.06),
            DiffPoint(id: "d6", x: 0.121, y: 0.308, radius: 0.06),
            DiffPoint(id: "d7", x: 0.35, y: 0.688, radius: 0.06),
            DiffPoint(id: "d8", x: 0.06, y: 0.625, radius: 0.06),
            DiffPoint(id: "d9", x: 0.113, y: 0.966, radius: 0.06),
            DiffPoint(id: "d10", x: 0.847, y: 0.695, radius: 0.06),
        ],

        "dif15": [
            DiffPoint(id: "d1", x: 0.311, y: 0.061, radius: 0.06),
            DiffPoint(id: "d2", x: 0.797, y: 0.664, radius: 0.06),
            DiffPoint(id: "d3", x: 0.889, y: 0.697, radius: 0.06),
            DiffPoint(id: "d4", x: 0.554, y: 0.447, radius: 0.06),
            DiffPoint(id: "d5", x: 0.895, y: 0.266, radius: 0.06),
            DiffPoint(id: "d6", x: 0.171, y: 0.749, radius: 0.06),
            DiffPoint(id: "d7", x: 0.309, y: 0.686, radius: 0.06),
            DiffPoint(id: "d8", x: 0.041, y: 0.474, radius: 0.06),
            DiffPoint(id: "d9", x: 0.169, y: 0.417, radius: 0.06),
            DiffPoint(id: "d10", x: 0.639, y: 0.691, radius: 0.06),
        ],

        "dif16": [
            DiffPoint(id: "d1", x: 0.472, y: 0.16, radius: 0.06),
            DiffPoint(id: "d2", x: 0.904, y: 0.263, radius: 0.06),
            DiffPoint(id: "d3", x: 0.786, y: 0.427, radius: 0.06),
            DiffPoint(id: "d4", x: 0.95, y: 0.854, radius: 0.06),
            DiffPoint(id: "d5", x: 0.681, y: 0.298, radius: 0.06),
        ],

        "dif17": [
            DiffPoint(id: "d1", x: 0.267, y: 0.824, radius: 0.06),
            DiffPoint(id: "d2", x: 0.714, y: 0.764, radius: 0.06),
            DiffPoint(id: "d3", x: 0.942, y: 0.629, radius: 0.06),
            DiffPoint(id: "d4", x: 0.485, y: 0.106, radius: 0.06),
            DiffPoint(id: "d5", x: 0.551, y: 0.562, radius: 0.06),
            DiffPoint(id: "d6", x: 0.086, y: 0.558, radius: 0.06),
            DiffPoint(id: "d7", x: 0.277, y: 0.54, radius: 0.06),
            DiffPoint(id: "d8", x: 0.376, y: 0.636, radius: 0.06),
            DiffPoint(id: "d9", x: 0.665, y: 0.653, radius: 0.06),
            DiffPoint(id: "d10", x: 0.533, y: 0.351, radius: 0.06),
        ],

        "dif18": [
            DiffPoint(id: "d1", x: 0.801, y: 0.027, radius: 0.06),
            DiffPoint(id: "d2", x: 0.852, y: 0.267, radius: 0.06),
            DiffPoint(id: "d3", x: 0.668, y: 0.178, radius: 0.06),
            DiffPoint(id: "d4", x: 0.933, y: 0.576, radius: 0.06),
            DiffPoint(id: "d5", x: 0.778, y: 0.826, radius: 0.06),
            DiffPoint(id: "d6", x: 0.417, y: 0.722, radius: 0.06),
            DiffPoint(id: "d7", x: 0.296, y: 0.069, radius: 0.06),
            DiffPoint(id: "d8", x: 0.517, y: 0.409, radius: 0.06),
            DiffPoint(id: "d9", x: 0.204, y: 0.362, radius: 0.06),
            DiffPoint(id: "d10", x: 0.088, y: 0.743, radius: 0.06),
        ],

        "dif19": [
            DiffPoint(id: "d1", x: 0.193, y: 0.076, radius: 0.06),
            DiffPoint(id: "d2", x: 0.538, y: 0.249, radius: 0.06),
            DiffPoint(id: "d3", x: 0.671, y: 0.277, radius: 0.06),
            DiffPoint(id: "d4", x: 0.609, y: 0.395, radius: 0.06),
            DiffPoint(id: "d5", x: 0.842, y: 0.916, radius: 0.06),
            DiffPoint(id: "d6", x: 0.905, y: 0.355, radius: 0.06),
            DiffPoint(id: "d7", x: 0.37, y: 0.784, radius: 0.06),
            DiffPoint(id: "d8", x: 0.217, y: 0.577, radius: 0.06),
            DiffPoint(id: "d9", x: 0.122, y: 0.786, radius: 0.06),
            DiffPoint(id: "d10", x: 0.464, y: 0.347, radius: 0.06),
        ],

        "dif20": [
            DiffPoint(id: "d1", x: 0.143, y: 0.159, radius: 0.06),
            DiffPoint(id: "d2", x: 0.722, y: 0.088, radius: 0.06),
            DiffPoint(id: "d3", x: 0.452, y: 0.068, radius: 0.06),
            DiffPoint(id: "d4", x: 0.719, y: 0.365, radius: 0.06),
            DiffPoint(id: "d5", x: 0.961, y: 0.464, radius: 0.06),
            DiffPoint(id: "d6", x: 0.95, y: 0.67, radius: 0.06),
            DiffPoint(id: "d7", x: 0.468, y: 0.874, radius: 0.06),
            DiffPoint(id: "d8", x: 0.415, y: 0.354, radius: 0.06),
            DiffPoint(id: "d9", x: 0.178, y: 0.372, radius: 0.06),
            DiffPoint(id: "d10", x: 0.176, y: 0.563, radius: 0.06),
        ],
    ]
  
    static func previewImage(for id: String) -> String {
        "games_dif_\(levelNumber(from: id)).1"
    }

    static func topImage(for id: String) -> String {
           "games_dif_\(levelNumber(from: id)).1"
       }

       static func bottomImage(for id: String) -> String {
           "games_dif_\(levelNumber(from: id)).2"
       }

       static func points(for id: String) -> [DiffPoint] {
           map[id] ?? []
       }

       private static func levelNumber(from id: String) -> String {
           id.replacingOccurrences(of: "dif", with: "")
       }
}
