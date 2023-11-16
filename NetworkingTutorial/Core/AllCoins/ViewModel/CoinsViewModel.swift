//
//  CoinsViewModel.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 16/11/23.
//

import Foundation

class CoinsViewModel: ObservableObject {
    @Published var coins = ""
    @Published var price = ""
    
    init() {
        fetchCoin()
    }
    
    func fetchCoin() {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=bitcoin&vs_currencies=inr"
        guard let url = URL(string: urlString) else { return }
        
        print("Fetching request.....")
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Did recieved data: \(data)")
        }.resume()
        print("Request fetched!") //Will be printed before the "Did recieved data:" since API request takes time in completion Handler.
    }
}
