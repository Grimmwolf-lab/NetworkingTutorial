//
//  CoinsService.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 17/11/23.
//

import Foundation
import UIKit

/// Class responsible to communicate with DataSource (API) and provide the required data to ViewModel.
class CoinsService {
    private let urlString = "https://api.coingecko.com/api/v3/coins/markets?vs_currency=inr&order=market_cap_desc&per_page=500&page=1&sparkline=false&price_change_percentage=24h&locale=en"
     
    /// Making use of async throws has made the fetch method more readable and efficient.
    func fetchCoins() async throws -> [Coin]{
        guard let url = URL(string: urlString) else { return [] }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let coins = try JSONDecoder().decode([Coin].self, from: data)
            return coins
        } catch {
            print("DEBUG: Fetch failed with error - \(error.localizedDescription)")
            return []
        }
    }
}

// MARK: - Completion Handler Method

extension CoinsService {
    /// This way we have more robust way to handle success and error case instead of opional value.
    func fetchCoinsWithResult(completion: @escaping(Result<[Coin], CoinAPIError>) -> Void) {
        guard let url = URL(string: urlString) else { return }
        URLSession.shared.dataTask(with: url) { data, response, error1 in
            if let error1 = error1 {
                completion(.failure(.unknownError(error: error1)))
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(.requestFailed(description: "Request failed")))
                return
            }
            
            guard httpResponse.statusCode == 200 else {
                completion(.failure(.invalideStatus(statusCode: httpResponse.statusCode)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.invalidData))
                return
            }
            
            /// Now instead of guard statement we are going to use do-catch block.
            do {
                /// We will decode the data in our required format that is Coin model
                let coins = try JSONDecoder().decode([Coin].self, from: data)
                completion(.success(coins))
            } catch {
                completion(.failure(.jsonParsingFailure))
                print("DEBUG: Failed json decoding with error: \(error)") /// This error is provided by the catch block. This is like writing "catch let error".
                ///but swift does it for us.
            }
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
