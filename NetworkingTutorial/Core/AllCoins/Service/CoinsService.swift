//
//  CoinsService.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 17/11/23.
//

import Foundation

/// Class responsible to communicate with DataSource (API) and provide the required data to ViewModel.
class CoinsService {
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=50&page=1&sparkline=false&price_change_percentage=24h&locale=en"

    /// This way we have more robust way to handle success and error case instead of opional value. 
    func fetchCoinsWithResult(completion: @escaping(Result<[Coin], Error>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
            }
            guard let data = data else { return }
            /// We will decode the data in our required format that is Coin model
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("Decode Failed")
                return
            }
            completion(.success(coins))
        }.resume()
    }

    func fetchCoins(completion: @escaping([Coin]?, Error?) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(nil, error)
            }
            guard let data = data else { return }
            /// We will decode the data in our required format that is Coin model
            guard let coins = try? JSONDecoder().decode([Coin].self, from: data) else {
                print("Decode Failed")
                return
            }
            completion(coins, nil)
        }.resume()
    }

    func fetchPrice(coin: String, completion: @escaping(Double) -> Void) {
        let urlString = "https://api.coingecko.com/api/v3/simple/price?ids=\(coin)&vs_currencies=inr"
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            /// Removed main queue wrapper since we are not handling UI updation variable from here.
            /// Three layer of error handling and request handling.
            /// We first check if we are getting any ERROR if not we check is the HTTP response is good or not.
            if let error = error {
                print("DEBUG: Failed with error \(error.localizedDescription)") 
                // self.errorMessage = error.localizedDescription /// Values which are responsible for UI updates should be updated in background threads.
                return
            }
            guard let httpResponse = response as? HTTPURLResponse else {
                // self.errorMessage = "Bad HTTP response"
                return
            }
            guard httpResponse.statusCode == 200 else {
                // self.errorMessage = "Request failed with statusCode \(httpResponse.statusCode)"
                return
            }
            guard let data = data else { return }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else { return }
            guard let value = jsonObject[coin] as? [String: Double] else {
                print("Failed to parse value!")
                return
            }
            guard let price = value["inr"] else { return }
            print("DEBUG: price fetch from service class \(price)")
            completion(price)
        }.resume()
    }
}
