//
//  Coin.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 17/11/23.
//

import Foundation

struct Coin: Codable, Identifiable {
    let id: String
    let symbol: String
    let name: String
//    let current_price: Double
//    let market_cap_rank: Int
}
