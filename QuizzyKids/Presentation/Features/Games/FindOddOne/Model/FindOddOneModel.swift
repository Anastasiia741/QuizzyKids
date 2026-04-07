//  FindOddOne.swift
//  Quizzy Kids

import Foundation

struct FindOddOneModel {
    var currentIndex: Int = 0
    var selectedID: UUID? = nil
    var wrongID: UUID? = nil
    var isCorrect: Bool = false
    var isLocked: Bool = false
}


struct FindOddOneQuestion: Identifiable, Equatable {
    let id = UUID()
    let items: [FindOddOneItem]
    let correctItemID: UUID
}

struct FindOddOneItem: Identifiable, Equatable {
    let id = UUID()
    let image: String
}

enum FindOddOneMockDB {

    static let items: [FindOddOneQuestion] = {

        let q1_1  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_2  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_3  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_4  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_5  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_6  = FindOddOneItem(image: FindOddOne1.i02.rawValue)
        let q1_7  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_8  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_9  = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_10 = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_11 = FindOddOneItem(image: FindOddOne1.i01.rawValue)
        let q1_12 = FindOddOneItem(image: FindOddOne1.i01.rawValue)

        let q1 = FindOddOneQuestion(
            items: [q1_1, q1_2, q1_3, q1_4, q1_5, q1_6, q1_7, q1_8, q1_9, q1_10, q1_11, q1_12],
            correctItemID: q1_6.id
        )

        let q2_1  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_2  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_3  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_4  = FindOddOneItem(image: FindOddOne1.i04.rawValue)
        let q2_5  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_6  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_7  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_8  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_9  = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_10 = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_11 = FindOddOneItem(image: FindOddOne1.i03.rawValue)
        let q2_12 = FindOddOneItem(image: FindOddOne1.i03.rawValue)

        let q2 = FindOddOneQuestion(
            items: [q2_1, q2_2, q2_3, q2_4, q2_5, q2_6, q2_7, q2_8, q2_9, q2_10, q2_11, q2_12],
            correctItemID: q2_4.id
        )

        let q3_1  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_2  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_3  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_4  = FindOddOneItem(image: FindOddOne1.i09.rawValue)
        let q3_5  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_6  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_7  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_8  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_9  = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_10 = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_11 = FindOddOneItem(image: FindOddOne1.i10.rawValue)
        let q3_12 = FindOddOneItem(image: FindOddOne1.i10.rawValue)

        let q3 = FindOddOneQuestion(
            items: [q3_1, q3_2, q3_3, q3_4, q3_5, q3_6, q3_7, q3_8, q3_9, q3_10, q3_11, q3_12],
            correctItemID: q3_4.id
        )

        let q4_1  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_2  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_3  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_4  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_5  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_6  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_7  = FindOddOneItem(image: FindOddOne1.i06.rawValue)
        let q4_8  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_9  = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_10 = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_11 = FindOddOneItem(image: FindOddOne1.i05.rawValue)
        let q4_12 = FindOddOneItem(image: FindOddOne1.i05.rawValue)

        let q4 = FindOddOneQuestion(
            items: [q4_1, q4_2, q4_3, q4_4, q4_5, q4_6, q4_7, q4_8, q4_9, q4_10, q4_11, q4_12],
            correctItemID: q4_7.id
        )

        let q5_1  = FindOddOneItem(image: FindOddOne2.i01.rawValue)
        let q5_2  = FindOddOneItem(image: FindOddOne2.i02.rawValue)
        let q5_3  = FindOddOneItem(image: FindOddOne2.i03.rawValue)
        let q5_4  = FindOddOneItem(image: FindOddOne2.i04.rawValue)
        let q5_5  = FindOddOneItem(image: FindOddOne2.i05.rawValue)
        let q5_6  = FindOddOneItem(image: FindOddOne2.i06.rawValue)
        let q5_7  = FindOddOneItem(image: FindOddOne2.i07.rawValue)
        let q5_8  = FindOddOneItem(image: FindOddOne2.i08.rawValue)
        let q5_9  = FindOddOneItem(image: FindOddOne2.i09.rawValue)
        let q5_10 = FindOddOneItem(image: FindOddOne2.i10.rawValue)
        let q5_11 = FindOddOneItem(image: FindOddOne2.i11.rawValue)
        let q5_12 = FindOddOneItem(image: FindOddOne2.i12.rawValue)

        let q5 = FindOddOneQuestion(
            items: [q5_1, q5_2, q5_3, q5_4, q5_5, q5_6, q5_7, q5_8, q5_9, q5_10, q5_11, q5_12],
            correctItemID: q5_8.id
        )

        let q6_1  = FindOddOneItem(image: FindOddOne3.i01.rawValue)
        let q6_2  = FindOddOneItem(image: FindOddOne3.i02.rawValue)
        let q6_3  = FindOddOneItem(image: FindOddOne3.i03.rawValue)
        let q6_4  = FindOddOneItem(image: FindOddOne3.i04.rawValue)
        let q6_5  = FindOddOneItem(image: FindOddOne3.i05.rawValue)
        let q6_6  = FindOddOneItem(image: FindOddOne3.i06.rawValue)
        let q6_7  = FindOddOneItem(image: FindOddOne3.i07.rawValue)
        let q6_8  = FindOddOneItem(image: FindOddOne3.i08.rawValue)
        let q6_9  = FindOddOneItem(image: FindOddOne3.i09.rawValue)
        let q6_10 = FindOddOneItem(image: FindOddOne3.i10.rawValue)
        let q6_11 = FindOddOneItem(image: FindOddOne3.i11.rawValue)
        let q6_12 = FindOddOneItem(image: FindOddOne3.i12.rawValue)

        let q6 = FindOddOneQuestion(
            items: [q6_1, q6_2, q6_3, q6_4, q6_5, q6_6, q6_7, q6_8, q6_9, q6_10, q6_11, q6_12],
            correctItemID: q6_6.id
        )

        let q7_1  = FindOddOneItem(image: FindOddOne4.i01.rawValue)
        let q7_2  = FindOddOneItem(image: FindOddOne4.i02.rawValue)
        let q7_3  = FindOddOneItem(image: FindOddOne4.i03.rawValue)
        let q7_4  = FindOddOneItem(image: FindOddOne4.i04.rawValue)
        let q7_5  = FindOddOneItem(image: FindOddOne4.i05.rawValue)
        let q7_6  = FindOddOneItem(image: FindOddOne4.i06.rawValue)
        let q7_7  = FindOddOneItem(image: FindOddOne4.i07.rawValue)
        let q7_8  = FindOddOneItem(image: FindOddOne4.i08.rawValue)
        let q7_9  = FindOddOneItem(image: FindOddOne4.i09.rawValue)
        let q7_10 = FindOddOneItem(image: FindOddOne4.i10.rawValue)
        let q7_11 = FindOddOneItem(image: FindOddOne4.i11.rawValue)
        let q7_12 = FindOddOneItem(image: FindOddOne4.i12.rawValue)

        let q7 = FindOddOneQuestion(
            items: [q7_1, q7_2, q7_3, q7_4, q7_5, q7_6, q7_7, q7_8, q7_9, q7_10, q7_11, q7_12],
            correctItemID: q7_7.id
        )

        let q8_1  = FindOddOneItem(image: FindOddOne5.i01.rawValue)
        let q8_2  = FindOddOneItem(image: FindOddOne5.i02.rawValue)
        let q8_3  = FindOddOneItem(image: FindOddOne5.i03.rawValue)
        let q8_4  = FindOddOneItem(image: FindOddOne5.i04.rawValue)
        let q8_5  = FindOddOneItem(image: FindOddOne5.i05.rawValue)
        let q8_6  = FindOddOneItem(image: FindOddOne5.i06.rawValue)
        let q8_7  = FindOddOneItem(image: FindOddOne5.i07.rawValue)
        let q8_8  = FindOddOneItem(image: FindOddOne5.i08.rawValue)
        let q8_9  = FindOddOneItem(image: FindOddOne5.i09.rawValue)
        let q8_10 = FindOddOneItem(image: FindOddOne5.i10.rawValue)
        let q8_11 = FindOddOneItem(image: FindOddOne5.i11.rawValue)
        let q8_12 = FindOddOneItem(image: FindOddOne5.i12.rawValue)

        let q8 = FindOddOneQuestion(
            items: [q8_1, q8_2, q8_3, q8_4, q8_5, q8_6, q8_7, q8_8, q8_9, q8_10, q8_11, q8_12],
            correctItemID: q8_10.id
        )
     
        
        let q9_1  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_2  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_3  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_4  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_5  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_6  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_7  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_8  = FindOddOneItem(image: FindOddOne1.i08.rawValue)
        let q9_9  = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_10 = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_11 = FindOddOneItem(image: FindOddOne1.i07.rawValue)
        let q9_12 = FindOddOneItem(image: FindOddOne1.i07.rawValue)

        let q9 = FindOddOneQuestion(
            items: [q9_1, q9_2, q9_3, q9_4, q9_5, q9_6, q9_7, q9_8, q9_9, q9_10, q9_11, q9_12],
            correctItemID: q9_8.id
        )

        return [q1, q2, q3, q4, q5, q6, q7, q8, q9]
    }()
}
