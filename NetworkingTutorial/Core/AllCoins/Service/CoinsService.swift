//
//  CoinsService.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 17/11/23.
//

import Foundation

/// Class responsible to communicate with DataSource (API) and provide the required data to ViewModel.
class CoinsService {
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
