//  DomainEnums.swift
//  Quizzy Kids

import Foundation

enum AuthFlowError: LocalizedError {
    case checkHighlightedFields
    case missingGoogleClientID
    case noRootViewController
    case missingGoogleIDToken
    case googleSignInFailed
    case emptyEmail
    case appleSignInFailed
    case appleTokenMissing
    
    var errorDescription: String? {
        switch self {
        case .checkHighlightedFields: return "Check fields"
        case .missingGoogleClientID: return "Google setup error"
        case .noRootViewController:  return "UI error. Try again"
        case .missingGoogleIDToken:  return "Google token missing"
        case .googleSignInFailed:    return "Google sign-in failed"
        case .emptyEmail:            return "Enter email"
        case .appleSignInFailed:     return "Apple sign-in failed"
        case .appleTokenMissing:     return "Apple token missing"
        }
    }
}

enum GameState: Equatable { case idle, playing, win, lose  }
