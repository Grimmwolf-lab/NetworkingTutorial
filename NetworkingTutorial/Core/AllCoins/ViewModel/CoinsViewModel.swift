//
//  CoinsViewModel.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 16/11/23.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = [Coin]()
    @Published var errorMessage: String?
    
    let service = CoinsService() /// Service class will be now responsible for the communication with the API and provide data to ViewModel. 

    init() {
        fetchCoinsWithResult()
    }

    func fetchCoinsWithResult() {
        service.fetchCoinsWithResult { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let coins):
                    self.coins = coins
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

//    func fetchCoins() {
//        service.fetchCoins { coins, error in
//            DispatchQueue.main.async {
//                if let error = error {
//                    self.errorMessage = error.localizedDescription
//                    return
//                }
//                guard let coins = coins else { return }
//                self.coins = coins
//            }
//        }
//    }
}
