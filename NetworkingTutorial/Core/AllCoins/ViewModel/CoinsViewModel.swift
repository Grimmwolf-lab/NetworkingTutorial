//
//  CoinsViewModel.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 16/11/23.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = [Coin]()
    
    let service = CoinsService() /// Service class will be now responsible for the communication with the API and provide data to ViewModel. 

    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        service.fetchCoins { coins in
            DispatchQueue.main.async {
                self.coins = coins
            }
        }
    }
}
