//
//  CoinAPIError.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 17/11/23.
//

import Foundation

enum CoinAPIError: Error {
    case invalidData
    case jsonParsingFailure
    case requestFailed(description: String)
    case invalideStatus(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData: return "Invalid Data"
        case .jsonParsingFailure: return "Parsing Failed"
        case let .requestFailed(description): return "Request failed: \(description)"
        case let .invalideStatus(statusCode): return "Invalid status: \(statusCode)"
        case let .unknownError(error): return "Unknown error: \(error.localizedDescription)"
        }
    }
}
