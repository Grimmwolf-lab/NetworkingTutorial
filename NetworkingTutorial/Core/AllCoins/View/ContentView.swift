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
        VStack {
            if let errorMessage = coinsViewModel.errorMessage {
                Text(errorMessage)
            } else {
                Text("\(coinsViewModel.coin): \(coinsViewModel.price)")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
