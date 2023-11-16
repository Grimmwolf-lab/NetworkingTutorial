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
    
    init() {
        fetchCoin(coin: "ethereum")
    }
    
    func fetchCoin(coin: String) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=inr"
        guard let url = URL(string: urlString) else { return }
        
        print("Fetching request.....")
        URLSession.shared.dataTask(with: url) { data, response, error in
            print("Did recieved data: \(String(describing: data))")
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            print(jsonObject)
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("Failed to parse value!")
                return
            }
            guard let price = value["inr"] else { return }
            DispatchQueue.main.async {
                self.coin = coin.capitalized
                self.price = "₹\(price)"
            }
        }.resume()
        print("Request fetched!") // Will be printed before the "Did recieved data:" since API request takes time.
    }
}
