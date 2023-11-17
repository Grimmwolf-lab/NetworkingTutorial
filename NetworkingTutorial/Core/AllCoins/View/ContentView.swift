//
//  ContentView.swift
//  NetworkingTutorial
//
//  Created by Kailash Bora on 16/11/23.
//

import SwiftUI

struct ContentView: View {
    @StateObject var coinsViewModel = CoinsViewModel()
    var body: some View {
        List {
            ForEach(coinsViewModel.coins) { coin in
                Text(coin.name)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
