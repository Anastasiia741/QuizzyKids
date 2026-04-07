//  AppFont.swift
//  Quizzy Kids

import SwiftUI

enum AppFont {
    static func marker(_ size: CGFloat) -> Font {
           .custom("PermanentMarker-Regular", size: size)
       }

    static func largeTitle() -> Font {
        .custom("Nunito-Bold", size: 34)
            .leading(51)
    }

    static func title1() -> Font {
        .custom("Nunito-Bold", size: 28)
            .leading(42)
    }

    static func title2() -> Font {
        .custom("Nunito-Bold", size: 24)
            .leading(36)
    }

    static func title3() -> Font {
        .custom("Nunito-Bold", size: 20)
            .leading(30)
    }

    static func headline() -> Font {
        .custom("Nunito-SemiBold", size: 20)
            .leading(30)
    }

    static func subheadline() -> Font {
        .custom("Nunito-Bold", size: 18)
            .leading(27)
    }

    static func body() -> Font {
        .custom("Nunito-Regular", size: 17)
            .leading(25)
    }

    static func body2() -> Font {
        .custom("Nunito-Regular", size: 15)
            .leading(22)
    }

    static func callout() -> Font {
        .custom("Nunito-Medium", size: 16)
            .leading(24)
    }

    static func caption1() -> Font {
        .custom("Nunito-Bold", size: 18)
            .leading(27)
    }

    static func caption2() -> Font {
        .custom("Nunito-Bold", size: 15)
            .leading(22)
    }

    static func footnote() -> Font {
        .custom("Nunito-Medium", size: 13)
            .leading(19)
    }
}

extension Font {
    func leading(_ value: CGFloat) -> Font {
        return self
    }
}
