//
//  Coin.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 17/11/23.
//

import Foundation

/// Make sure to keep the variable names as it is in the json response.
/// Since decoder map all these data to the JSON response and fetch related values.
/// But to follow camel casing we have to use a different approach of using enum.
struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
    let currentPrice: Double
    let marketCapRank: Int
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case currentPrice = "current_price" /// assigning the correct JSON key name to our own camel cased variable.
        case marketCapRank = "market_cap_rank"
    }
}
