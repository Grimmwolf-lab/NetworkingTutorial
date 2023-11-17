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
    
    init() {
        fetchCoin(coin: "ethereum")
    }
    
    func fetchCoin(coin: String) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=inr"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            /// We are wrapping whole logic under main queue so that it won't give us warning for updating Published variable for UI through background thread.
            /// Since these are light weight logic we can wrap it for now, later on we will have better approach to this.
            DispatchQueue.main.async {
                /// Three layer of error handling and request handling.
                /// We first check if we are getting any ERROR if not we check is the HTTP response is good or not.
                if let error = error {
                    print("DEBUG: Failed with error \(error.localizedDescription)")
                    self.errorMessage = error.localizedDescription /// Values which are responsible for UI updates should be updated in background threads.
                    return
                }
                guard let httpResponse = response as? HTTPURLResponse else {
                    self.errorMessage = "Bad HTTP response"
                    return
                }
                guard httpResponse.statusCode == 200 else {
                    self.errorMessage = "Request failed with statusCode \(httpResponse.statusCode)"
                    return
                }
                guard let data = data else { return }
                guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
                guard let value = jsonObject[coin] as? [String: Double] else {
                    print("Failed to parse value!")
                    return
                }
                guard let price = value["inr"] else { return }
                self.coin = coin.capitalized /// Values which are responsible for UI updates should be updated in background threads.
                self.price = "₹\(price)" /// Values which are responsible for UI updates should be updated in background threads.
            }
        }.resume()
    }
}
