//  NumbersItem.swift
//  Quizzy Kids

import Foundation

struct DrawPoint {
    let x: CGFloat
    let y: CGFloat

    var cg: CGPoint { .init(x: x, y: y) }
}

struct DrawData {
    let steps: [DrawPoint]
    let path: [DrawPoint]
}

enum NumbersDrawPaths {

    static func data(for value: Int) -> [DrawData] {
          switch value {
          case 1:  return [one]
          case 2:  return [two]
          case 3:  return [three]
          case 4:  return [four]
          case 5:  return [five]
          case 6:  return [six]
          case 7:  return [seven]
          case 8:  return [eight]
          case 9:  return [nine]
          case 10: return [tenOne, tenZero]
          default: return []
          }
      }

    static func path(for value: Int) -> [CGPoint] {
        data(for: value).first?.path.map { $0.cg } ?? []
    }

    private static let one = DrawData(
        steps: [
            .init(x: 0.52, y: 0.12),
            .init(x: 0.52, y: 0.55),
            .init(x: 0.40, y: 0.90),
        ],
        path: [
            .init(x: 0.25, y: 0.27),
            .init(x: 0.68, y: 0.11),
            .init(x: 0.25, y: 0.27),
            .init(x: 0.68, y: 0.11),
            .init(x: 0.65, y: 0.93)
        ]
    )

    private static let two = DrawData(
        steps: [
            .init(x: 0.30, y: 0.29),
            .init(x: 0.75, y: 0.19),
            .init(x: 0.33, y: 0.90),
            .init(x: 0.88, y: 0.90),
        ],
        path: [
            .init(x: 0.30, y: 0.29),
            .init(x: 0.30, y: 0.21),
            .init(x: 0.33, y: 0.15),
            .init(x: 0.43, y: 0.10),
            .init(x: 0.51, y: 0.09),
            .init(x: 0.58, y: 0.10),
            .init(x: 0.67, y: 0.12),
            .init(x: 0.75, y: 0.19),
            .init(x: 0.78, y: 0.26),
            .init(x: 0.78, y: 0.32),
            .init(x: 0.74, y: 0.39),
            .init(x: 0.69, y: 0.45),
            .init(x: 0.61, y: 0.51),
            .init(x: 0.57, y: 0.56),
            .init(x: 0.56, y: 0.58),
            .init(x: 0.49, y: 0.61),
            .init(x: 0.45, y: 0.66),
            .init(x: 0.39, y: 0.71),
            .init(x: 0.36, y: 0.75),
            .init(x: 0.33, y: 0.80),
            .init(x: 0.33, y: 0.87),
            .init(x: 0.33, y: 0.90),
            .init(x: 0.46, y: 0.90),
            .init(x: 0.57, y: 0.91),
            .init(x: 0.68, y: 0.90),
            .init(x: 0.78, y: 0.90),
            .init(x: 0.83, y: 0.90),
            .init(x: 0.86, y: 0.90),
            .init(x: 0.88, y: 0.90),
        ]
    )

    private static let three = DrawData(
        steps: [
            .init(x: 0.33, y: 0.17),
            .init(x: 0.55, y: 0.50),
            .init(x: 0.28, y: 0.76),
        ],
        path: [
            .init(x: 0.33, y: 0.17),
            .init(x: 0.52, y: 0.07),
            .init(x: 0.68, y: 0.12),
            .init(x: 0.77, y: 0.27),
            .init(x: 0.78, y: 0.33),
            .init(x: 0.69, y: 0.41),
            .init(x: 0.61, y: 0.45),
            .init(x: 0.55, y: 0.50),
            .init(x: 0.66, y: 0.55),
            .init(x: 0.76, y: 0.60),
            .init(x: 0.79, y: 0.66),
            .init(x: 0.79, y: 0.74),
            .init(x: 0.76, y: 0.81),
            .init(x: 0.71, y: 0.85),
            .init(x: 0.61, y: 0.88),
            .init(x: 0.52, y: 0.90),
            .init(x: 0.40, y: 0.89),
            .init(x: 0.32, y: 0.81),
            .init(x: 0.28, y: 0.76),
        ]
    )

    private static let four = DrawData(
        steps: [
            .init(x: 0.30, y: 0.10),
            .init(x: 0.30, y: 0.55),
            .init(x: 0.68, y: 0.55),
            .init(x: 0.68, y: 0.92),
        ],
        path: [
            .init(x: 0.30, y: 0.10),
            .init(x: 0.30, y: 0.55),

            .init(x: 0.68, y: 0.55),

            .init(x: 0.68, y: 0.10),
            .init(x: 0.68, y: 0.92),
        ]
    )

    private static let five = DrawData(
        steps: [
            .init(x: 0.80, y: 0.11),
            .init(x: 0.35, y: 0.42),
            .init(x: 0.27, y: 0.77),
        ],
        path: [
            .init(x: 0.80, y: 0.11),
            .init(x: 0.61, y: 0.12),
            .init(x: 0.31, y: 0.10),
            .init(x: 0.28, y: 0.36),
            .init(x: 0.27, y: 0.43),
            .init(x: 0.25, y: 0.46),
            .init(x: 0.35, y: 0.42),
            .init(x: 0.46, y: 0.42),
            .init(x: 0.51, y: 0.43),
            .init(x: 0.59, y: 0.45),
            .init(x: 0.71, y: 0.51),
            .init(x: 0.73, y: 0.55),
            .init(x: 0.75, y: 0.63),
            .init(x: 0.75, y: 0.70),
            .init(x: 0.75, y: 0.75),
            .init(x: 0.73, y: 0.83),
            .init(x: 0.64, y: 0.87),
            .init(x: 0.53, y: 0.88),
            .init(x: 0.45, y: 0.88),
            .init(x: 0.33, y: 0.86),
            .init(x: 0.29, y: 0.81),
            .init(x: 0.28, y: 0.78),
            .init(x: 0.27, y: 0.77),
        ]
    )

    private static let six = DrawData(
        steps: [
            .init(x: 0.52, y: 0.14),
            .init(x: 0.25, y: 0.55),
            .init(x: 0.56, y: 0.91),
        ],
        path: [
            .init(x: 0.52, y: 0.14),
            .init(x: 0.43, y: 0.23),
            .init(x: 0.35, y: 0.35),
            .init(x: 0.25, y: 0.55),
            .init(x: 0.22, y: 0.66),
            .init(x: 0.21, y: 0.72),
            .init(x: 0.23, y: 0.78),
            .init(x: 0.27, y: 0.82),
            .init(x: 0.31, y: 0.86),
            .init(x: 0.37, y: 0.89),
            .init(x: 0.41, y: 0.90),
            .init(x: 0.49, y: 0.91),
            .init(x: 0.56, y: 0.91),
            .init(x: 0.65, y: 0.90),
            .init(x: 0.70, y: 0.89),
            .init(x: 0.75, y: 0.85),
            .init(x: 0.79, y: 0.78),
            .init(x: 0.81, y: 0.71),
            .init(x: 0.80, y: 0.62),
            .init(x: 0.75, y: 0.55),
            .init(x: 0.71, y: 0.52),
            .init(x: 0.67, y: 0.49),
            .init(x: 0.61, y: 0.47),
            .init(x: 0.54, y: 0.47),
            .init(x: 0.49, y: 0.47),
            .init(x: 0.41, y: 0.48),
            .init(x: 0.33, y: 0.52),
            .init(x: 0.26, y: 0.56),
        ]
    )

    private static let seven = DrawData(
        steps: [
            .init(x: 0.17, y: 0.13),
            .init(x: 0.81, y: 0.12),
            .init(x: 0.39, y: 0.93),
        ],
        path: [
            .init(x: 0.17, y: 0.13),
            .init(x: 0.25, y: 0.13),
            .init(x: 0.34, y: 0.12),
            .init(x: 0.44, y: 0.12),
            .init(x: 0.54, y: 0.12),
            .init(x: 0.62, y: 0.12),
            .init(x: 0.71, y: 0.12),
            .init(x: 0.81, y: 0.12),
            .init(x: 0.81, y: 0.17),
            .init(x: 0.80, y: 0.21),
            .init(x: 0.76, y: 0.28),
            .init(x: 0.72, y: 0.35),
            .init(x: 0.66, y: 0.45),
            .init(x: 0.62, y: 0.53),
            .init(x: 0.57, y: 0.63),
            .init(x: 0.51, y: 0.73),
            .init(x: 0.46, y: 0.82),
            .init(x: 0.42, y: 0.88),
            .init(x: 0.39, y: 0.93),
        ]
    )

    private static let eight = DrawData(
        steps: [
            .init(x: 0.30, y: 0.37),
            .init(x: 0.55, y: 0.08),
            .init(x: 0.52, y: 0.91),
        ],
        path: [
            .init(x: 0.30, y: 0.37),
            .init(x: 0.22, y: 0.32),
            .init(x: 0.22, y: 0.27),
            .init(x: 0.22, y: 0.20),
            .init(x: 0.26, y: 0.16),
            .init(x: 0.32, y: 0.11),
            .init(x: 0.39, y: 0.09),
            .init(x: 0.45, y: 0.07),
            .init(x: 0.55, y: 0.08),
            .init(x: 0.61, y: 0.10),
            .init(x: 0.69, y: 0.14),
            .init(x: 0.74, y: 0.20),
            .init(x: 0.76, y: 0.23),
            .init(x: 0.76, y: 0.27),
            .init(x: 0.75, y: 0.31),
            .init(x: 0.72, y: 0.35),
            .init(x: 0.67, y: 0.38),
            .init(x: 0.63, y: 0.40),
            .init(x: 0.58, y: 0.42),
            .init(x: 0.51, y: 0.45),
            .init(x: 0.43, y: 0.47),
            .init(x: 0.38, y: 0.50),
            .init(x: 0.31, y: 0.54),
            .init(x: 0.27, y: 0.57),
            .init(x: 0.23, y: 0.62),
            .init(x: 0.21, y: 0.67),
            .init(x: 0.21, y: 0.74),
            .init(x: 0.23, y: 0.78),
            .init(x: 0.27, y: 0.84),
            .init(x: 0.31, y: 0.86),
            .init(x: 0.37, y: 0.89),
            .init(x: 0.44, y: 0.91),
            .init(x: 0.52, y: 0.91),
            .init(x: 0.60, y: 0.91),
            .init(x: 0.68, y: 0.89),
            .init(x: 0.75, y: 0.85),
            .init(x: 0.78, y: 0.80),
            .init(x: 0.80, y: 0.74),
            .init(x: 0.80, y: 0.72),
            .init(x: 0.80, y: 0.68),
            .init(x: 0.78, y: 0.63),
            .init(x: 0.74, y: 0.60),
            .init(x: 0.67, y: 0.54),
            .init(x: 0.60, y: 0.51),
            .init(x: 0.54, y: 0.49),
            .init(x: 0.45, y: 0.43),
            .init(x: 0.36, y: 0.41),
            .init(x: 0.34, y: 0.41),
            .init(x: 0.35, y: 0.42),
        ]
    )

    private static let nine = DrawData(
        steps: [
            .init(x: 0.45, y: 0.53),
            .init(x: 0.56, y: 0.10),
            .init(x: 0.40, y: 0.91),
        ],
        path: [
            .init(x: 0.45, y: 0.53),
            .init(x: 0.38, y: 0.54),
            .init(x: 0.31, y: 0.52),
            .init(x: 0.24, y: 0.47),
            .init(x: 0.21, y: 0.40),
            .init(x: 0.20, y: 0.34),
            .init(x: 0.24, y: 0.26),
            .init(x: 0.25, y: 0.23),
            .init(x: 0.30, y: 0.19),
            .init(x: 0.36, y: 0.15),
            .init(x: 0.43, y: 0.11),
            .init(x: 0.49, y: 0.10),
            .init(x: 0.56, y: 0.10),
            .init(x: 0.64, y: 0.12),
            .init(x: 0.71, y: 0.17),
            .init(x: 0.75, y: 0.22),
            .init(x: 0.79, y: 0.28),
            .init(x: 0.79, y: 0.34),
            .init(x: 0.77, y: 0.40),
            .init(x: 0.74, y: 0.47),
            .init(x: 0.70, y: 0.54),
            .init(x: 0.62, y: 0.61),
            .init(x: 0.56, y: 0.68),
            .init(x: 0.50, y: 0.76),
            .init(x: 0.44, y: 0.84),
            .init(x: 0.40, y: 0.91),
        ]
    )

    private static let tenOne = DrawData(
        steps: [
            .init(x: 0.13, y: 0.28),
            .init(x: 0.30, y: 0.09),
            .init(x: 0.27, y: 0.89),
        ],
        path: [
            .init(x: 0.13, y: 0.28),
            .init(x: 0.17, y: 0.24),
            .init(x: 0.21, y: 0.18),
            .init(x: 0.26, y: 0.13),
            .init(x: 0.30, y: 0.09),
            .init(x: 0.30, y: 0.10),
            .init(x: 0.30, y: 0.16),
            .init(x: 0.30, y: 0.23),
            .init(x: 0.30, y: 0.32),
            .init(x: 0.29, y: 0.43),
            .init(x: 0.29, y: 0.49),
            .init(x: 0.29, y: 0.60),
            .init(x: 0.28, y: 0.74),
            .init(x: 0.28, y: 0.84),
            .init(x: 0.27, y: 0.89),
        ]
    )

    private static let tenZero = DrawData(
        steps: [
            .init(x: 0.53, y: 0.76),
            .init(x: 0.69, y: 0.17),
            .init(x: 0.55, y: 0.80),
        ],
        path: [
            .init(x: 0.53, y: 0.76),
            .init(x: 0.51, y: 0.72),
            .init(x: 0.48, y: 0.63),
            .init(x: 0.48, y: 0.56),
            .init(x: 0.48, y: 0.48),
            .init(x: 0.50, y: 0.40),
            .init(x: 0.53, y: 0.32),
            .init(x: 0.56, y: 0.26),
            .init(x: 0.59, y: 0.22),
            .init(x: 0.63, y: 0.18),
            .init(x: 0.69, y: 0.17),
            .init(x: 0.74, y: 0.17),
            .init(x: 0.81, y: 0.24),
            .init(x: 0.82, y: 0.31),
            .init(x: 0.83, y: 0.39),
            .init(x: 0.84, y: 0.46),
            .init(x: 0.84, y: 0.56),
            .init(x: 0.84, y: 0.62),
            .init(x: 0.83, y: 0.70),
            .init(x: 0.82, y: 0.76),
            .init(x: 0.79, y: 0.81),
            .init(x: 0.76, y: 0.84),
            .init(x: 0.73, y: 0.88),
            .init(x: 0.67, y: 0.88),
            .init(x: 0.62, y: 0.87),
            .init(x: 0.58, y: 0.84),
            .init(x: 0.55, y: 0.80),
        ]
    )
}
