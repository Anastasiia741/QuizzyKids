//  Enums.swift
//  Quizzy Kids

import SwiftUI

typealias Puzzle = Game.Puzzle
typealias Alphabet = Game.Alphabet
typealias AlphabetAnimal = Game.AlphabetAnimal
typealias AnimationAlphabet = Game.AnimationAlphabet

typealias BooksImages = Game.BooksImages
typealias Differences = Game.Differences

typealias FindOddOne = Game.FindOddOne
typealias FindOddOne1 = Game.FindOddOne1
typealias FindOddOne2 = Game.FindOddOne2
typealias FindOddOne3 = Game.FindOddOne3
typealias FindOddOne4 = Game.FindOddOne4
typealias FindOddOne5 = Game.FindOddOne5

typealias GamesImages = Game.GamesImages

typealias AnimalWorld = Game.AnimalWorld
typealias Numbers = Game.Numbers
typealias NumFruits = Game.NumFruits
typealias NumPlay = Game.NumPlay

typealias MagicCount = Game.MagicCount

typealias Avatar = UI.Avatar
typealias Background = UI.Background
typealias Banner = UI.Banner
typealias Icons = UI.Icons
typealias Shapes = UI.Shapes


enum Game {
    enum Puzzle: String, CaseIterable {
        case level01 = "games_puzzle_01"
        case level02 = "games_puzzle_02"
        case level03 = "games_puzzle_03"
        case level04 = "games_puzzle_04"
    }
    
    enum Alphabet: String, CaseIterable {
        case base = "games_alphabet"
    }
        
    enum AlphabetAnimal: String, CaseIterable {
        case alligator = "games_alphabet_an_alligator"
        case bear      = "games_alphabet_an_bear"
        case cat       = "games_alphabet_an_cat"
        case duck      = "games_alphabet_an_duck"
        case elephant  = "games_alphabet_an_elephant"
        case fish      = "games_alphabet_an_fish"
        case giraffe   = "games_alphabet_an_giraffe"
        case horse     = "games_alphabet_an_horse"
        case iguana    = "games_alphabet_an_iguana"
        case jellyfish = "games_alphabet_an_jellyfish"
        case kangaroo  = "games_alphabet_an_kangaroo"
        case lion      = "games_alphabet_an_lion"
        case monkey    = "games_alphabet_an_monkey"
        case narwhal   = "games_alphabet_an_narwhal"
        case owl       = "games_alphabet_an_owl"
        case panda     = "games_alphabet_an_panda"
        case quokka    = "games_alphabet_an_quokka"
        case rabbit    = "games_alphabet_an_rabbit"
        case snake     = "games_alphabet_an_snake"
        case tiger     = "games_alphabet_an_tiger"
        case unicorn   = "games_alphabet_an_unicorn"
        case vulture   = "games_alphabet_an_vulture"
        case whale     = "games_alphabet_an_whale"
        case xRayfish  = "games_alphabet_an_x-rayfish"
        case yak       = "games_alphabet_an_yak"
        case zebra     = "games_alphabet_an_zebra"
    }
        
    enum AnimationAlphabet: String, CaseIterable {
        case a01 = "games_alphabet_anim_01"
        case a02 = "games_alphabet_anim_02"
        case a03 = "games_alphabet_anim_03"
        case a04 = "games_alphabet_anim_04"
        case a05 = "games_alphabet_anim_05"
        case a06 = "games_alphabet_anim_06"
        case a07 = "games_alphabet_anim_07"
        case a08 = "games_alphabet_anim_08"
        case a09 = "games_alphabet_anim_09"
        case a10 = "games_alphabet_anim_10"
    }
    
    enum BooksImages: String, CaseIterable {
        case level01 = "games_books_images_01"
        case level02 = "games_books_images_02"
        case level03 = "games_books_images_03"
        case level04 = "games_books_images_04"
        case level05 = "games_books_images_05"
        case level06 = "games_books_images_06"
        case level07 = "games_books_images_07"
    }

    enum Differences: String, CaseIterable {
        case games_dif_1_1 = "games_dif_1.1"
        case games_dif_1_2 = "games_dif_1.2"
        case games_dif_2_1 = "games_dif_2.1"
        case games_dif_2_2 = "games_dif_2.2"
        case games_dif_3_1 = "games_dif_3.1"
        case games_dif_3_2 = "games_dif_3.2"
        case games_dif_4_1 = "games_dif_4.1"
        case games_dif_4_2 = "games_dif_4.2"
        case games_dif_5_1 = "games_dif_5.1"
        case games_dif_5_2 = "games_dif_5.2"
        case games_dif_6_1 = "games_dif_6.1"
        case games_dif_6_2 = "games_dif_6.2"
        case games_dif_7_1 = "games_dif_7.1"
        case games_dif_7_2 = "games_dif_7.2"
        case games_dif_8_1 = "games_dif_8.1"
        case games_dif_8_2 = "games_dif_8.2"
        case games_dif_9_1 = "games_dif_9.1"
        case games_dif_9_2 = "games_dif_9.2"
        case games_dif_10_1 = "games_dif_10.1"
        case games_dif_10_2 = "games_dif_10.2"
        case games_dif_11_1 = "games_dif_11.1"
        case games_dif_11_2 = "games_dif_11.2"
        case games_dif_12_1 = "games_dif_12.1"
        case games_dif_12_2 = "games_dif_12.2"
        case games_dif_13_1 = "games_dif_13.1"
        case games_dif_13_2 = "games_dif_13.2"
        case games_dif_14_1 = "games_dif_14.1"
        case games_dif_14_2 = "games_dif_14.2"
        case games_dif_15_1 = "games_dif_15.1"
        case games_dif_15_2 = "games_dif_15.2"
        case games_dif_16_1 = "games_dif_16.1"
        case games_dif_16_2 = "games_dif_16.2"
        case games_dif_17_1 = "games_dif_17.1"
        case games_dif_17_2 = "games_dif_17.2"
        case games_dif_18_1 = "games_dif_18.1"
        case games_dif_18_2 = "games_dif_18.2"
        case games_dif_19_1 = "games_dif_19.1"
        case games_dif_19_2 = "games_dif_19.2"
        case games_dif_20_1 = "games_dif_20.1"
        case games_dif_20_2 = "games_dif_20.2"
    }
        
    enum FindOddOne: String, CaseIterable {
        case base = "games_findOddOne_01"
    }
    
    enum FindOddOne1: String, CaseIterable {
        case i01 = "games_findOddOne_1_01"
        case i02 = "games_findOddOne_1_02"
        case i03 = "games_findOddOne_1_03"
        case i04 = "games_findOddOne_1_04"
        case i05 = "games_findOddOne_1_05"
        case i06 = "games_findOddOne_1_06"
        case i07 = "games_findOddOne_1_07"
        case i08 = "games_findOddOne_1_08"
        case i09 = "games_findOddOne_1_09"
        case i10 = "games_findOddOne_1_10"
    }
        
    enum FindOddOne2: String, CaseIterable {
        case i01 = "games_findOddOne_2_1"
        case i02 = "games_findOddOne_2_2"
        case i03 = "games_findOddOne_2_3"
        case i04 = "games_findOddOne_2_4"
        case i05 = "games_findOddOne_2_5"
        case i06 = "games_findOddOne_2_6"
        case i07 = "games_findOddOne_2_7"
        case i08 = "games_findOddOne_2_8"
        case i09 = "games_findOddOne_2_9"
        case i10 = "games_findOddOne_2_10"
        case i11 = "games_findOddOne_2_11"
        case i12 = "games_findOddOne_2_12"
    }

    enum FindOddOne3: String, CaseIterable {
        case i01 = "games_findOddOne_3_1"
        case i02 = "games_findOddOne_3_2"
        case i03 = "games_findOddOne_3_3"
        case i04 = "games_findOddOne_3_4"
        case i05 = "games_findOddOne_3_5"
        case i06 = "games_findOddOne_3_6"
        case i07 = "games_findOddOne_3_7"
        case i08 = "games_findOddOne_3_8"
        case i09 = "games_findOddOne_3_9"
        case i10 = "games_findOddOne_3_10"
        case i11 = "games_findOddOne_3_11"
        case i12 = "games_findOddOne_3_12"
    }

    enum FindOddOne4: String, CaseIterable {
        case i01 = "games_findOddOne_4_1"
        case i02 = "games_findOddOne_4_2"
        case i03 = "games_findOddOne_4_3"
        case i04 = "games_findOddOne_4_4"
        case i05 = "games_findOddOne_4_5"
        case i06 = "games_findOddOne_4_6"
        case i07 = "games_findOddOne_4_7"
        case i08 = "games_findOddOne_4_8"
        case i09 = "games_findOddOne_4_9"
        case i10 = "games_findOddOne_4_10"
        case i11 = "games_findOddOne_4_11"
        case i12 = "games_findOddOne_4_12"
    }

    enum FindOddOne5: String, CaseIterable {
        case i01 = "games_findOddOne_5_1"
        case i02 = "games_findOddOne_5_2"
        case i03 = "games_findOddOne_5_3"
        case i04 = "games_findOddOne_5_4"
        case i05 = "games_findOddOne_5_5"
        case i06 = "games_findOddOne_5_6"
        case i07 = "games_findOddOne_5_7"
        case i08 = "games_findOddOne_5_8"
        case i09 = "games_findOddOne_5_9"
        case i10 = "games_findOddOne_5_10"
        case i11 = "games_findOddOne_5_11"
        case i12 = "games_findOddOne_5_12"

    }

    enum GamesImages: String, CaseIterable {
        case game01 = "games_gamesImg_01"
        case game02 = "games_gamesImg_02"
        case game03 = "games_gamesImg_03"
        case game04 = "games_gamesImg_04"
        case game05 = "games_gamesImg_05"
        case game06 = "games_gamesImg_06"
        case game07 = "games_gamesImg_07"
        case game08 = "games_gamesImg_08"
    }
    
    enum AnimalWorld: String {
        case panda = "animal_world_01"
        case cat = "animal_world_02"
        case dog = "animal_world_03"
        case cow = "animal_world_04"
        case pig = "animal_world_05"
        case lion = "animal_world_06"
        case elephant = "animal_world_07"
        case penguin = "animal_world_08"
        case fish = "animal_world_09"
        case bee = "animal_world_10"
        case frog = "animal_world_11"
        case owl = "animal_world_12"
        case duck = "animal_world_13"
        case seagull = "animal_world_14"
    }
    
    enum Numbers: String, CaseIterable {
        case level01 = "games_numbers_01"
        case level02 = "games_numbers_02"
        case level03 = "games_numbers_03"
        case level04 = "games_numbers_04"
        case level05 = "games_numbers_05"
    }
        
    enum NumFruits: String, CaseIterable {
        case level01 = "games_numbers_numFruits_01"
        case level02 = "games_numbers_numFruits_02"
        case level03 = "games_numbers_numFruits_03"
        case level04 = "games_numbers_numFruits_04"
        case level05 = "games_numbers_numFruits_05"
        case level06 = "games_numbers_numFruits_06"
        case level07 = "games_numbers_numFruits_07"
        case level08 = "games_numbers_numFruits_08"
        case level09 = "games_numbers_numFruits_09"
        case level10 = "games_numbers_numFruits_10"
    }
        
    enum NumPlay: String, CaseIterable {
        case level01 = "games_numbers_numPlay_01"
        case level02 = "games_numbers_numPlay_02"
        case level03 = "games_numbers_numPlay_03"
        case level04 = "games_numbers_numPlay_04"
        case level05 = "games_numbers_numPlay_05"
        case level06 = "games_numbers_numPlay_06"
        case level07 = "games_numbers_numPlay_07"
        case level08 = "games_numbers_numPlay_08"
        case level09 = "games_numbers_numPlay_09"
        case level10 = "games_numbers_numPlay_10"
    }
        
    enum MagicCount: String {
        case level01 = "magic_count_01"
        case level02 = "magic_count_02"
        case level03 = "magic_count_03"
        case level04 = "magic_count_04"
        case level05 = "magic_count_05"
        case level06 = "magic_count_06"
        case level07 = "magic_count_07"
        case level08 = "magic_count_08"
        case level09 = "magic_count_09"
        case level10 = "magic_count_10"
    }
    
    
}
    
enum UI {
    enum Avatar: String, CaseIterable {
        case avatar01 = "ui_avatars_01"
        case avatar02 = "ui_avatars_02"
        case avatar03 = "ui_avatars_03"
        case avatar04 = "ui_avatars_04"
        case avatar05 = "ui_avatars_05"
        case avatar06 = "ui_avatars_06"
        case avatar07 = "ui_avatars_07"
        case avatar08 = "ui_avatars_08"
    }
        
    enum Background: String {
        case bg01 = "ui_bg_01"
        case bg02 = "ui_bg_02"
        case bg03 = "ui_bg_03"
        case bg04 = "ui_bg_04"
        case bg05 = "ui_bg_05"
        case bg06 = "ui_bg_06"
        case bg07 = "ui_bg_07"
        case bg08 = "ui_bg_08"
        case bg09 = "ui_bg_09"
        case bg10 =  "ui_bg_10"
        case bg11 =  "ui_bg_11"
        case bg12 =  "ui_bg_12"
        case bg13 =  "ui_bg_13"

    }
        
    enum Banner: String, CaseIterable {
        case banner01 = "ui_banners_01"
        case banner02 = "ui_banners_02"
        case banner03 = "ui_banners_03"
        case banner04 = "ui_banners_04"
        case banner05 = "ui_banners_05"
        case banner06 = "ui_banners_06"
        case banner07 = "ui_banners_07"
        case banner08 = "ui_banners_08"
        case banner09 = "ui_banners_09"
        case banner10 = "ui_banners_10"
        case banner11 = "ui_banners_11"
        case banner12 = "ui_banners_12"
        case banner13 = "ui_banners_13"
    }
        
    enum Icons: String, CaseIterable {
        case icon01 = "ui_icons_01"
        case icon02 = "ui_icons_02"
        case icon03 = "ui_icons_03"
        case icon04 = "ui_icons_04"
        case icon05 = "ui_icons_05"
        case icon06 = "ui_icons_06"
        case icon07 = "ui_icons_07"
        case icon08 = "ui_icons_08"
        case icon09 = "ui_icons_09"
        case icon10 = "ui_icons_10"
        case icon11 = "ui_icons_11"
        case icon12 = "ui_icons_12"
        case icon13 = "ui_icons_13"
        case icon14 = "ui_icons_14"
        case icon15 = "ui_icons_15"
        case icon16 = "ui_icons_16"
        case icon17 = "ui_icons_17"
    }
        
    enum Shapes: String, CaseIterable {
        case shape01 = "ui_shape_01"
        case shape02 = "ui_shape_02"
        case shape03 = "ui_shape_03"
        case shape04 = "ui_shape_04"
        case shape05 = "ui_shape_05"
        case shape06 = "ui_shape_06"
        case shape07 = "ui_shape_07"
        case shape08 = "ui_shape_08"
        case shape09 = "ui_shape_09"
        case shape10 = "ui_shape_10"
        case shape11 = "ui_shape_11"
        case shape12 = "ui_shape_12"

    }
}

extension NumPlay {
    static func by(
        _ value: Int
    ) -> NumPlay {
        switch value {
        case 1:  return .level01
        case 2:  return .level02
        case 3:  return .level03
        case 4:  return .level04
        case 5:  return .level05
        case 6:  return .level06
        case 7:  return .level07
        case 8:  return .level08
        case 9:  return .level09
        case 10: return .level10
        default: return .level01
        }
    }
}


enum AvatarStorage {
    static let key = "profile.avatar.assetName"
    static let all = [
        Avatar.avatar01.rawValue,
        Avatar.avatar02.rawValue,
        Avatar.avatar03.rawValue,
        Avatar.avatar04.rawValue,
        Avatar.avatar05.rawValue,
        Avatar.avatar06.rawValue,
        Avatar.avatar07.rawValue,
        Avatar.avatar08.rawValue
    ]
}
