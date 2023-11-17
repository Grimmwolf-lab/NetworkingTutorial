//
//  CoinsViewModel.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 16/11/23.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coin = ""
    @Published var price = ""
    @Published var errorMessage: String?
    
    let service = CoinsService() /// Service class will be now responsible for the communication with the API and provide data to ViewModel. 

    init() {
        fetchCoin(coin: "ethereum")
    }
    
    func fetchCoin(coin: String) {
        service.fetchPrice(coin: coin) { price in
            /// Now we can use main queue only for the variables which are responsible for the UI updates
            /// and not the full logic which can be heavy and make UI load slower. 
            DispatchQueue.main.async {
                self.coin = coin.capitalized
                self.price = "₹ \(price)"
            }
        }
    }
}
