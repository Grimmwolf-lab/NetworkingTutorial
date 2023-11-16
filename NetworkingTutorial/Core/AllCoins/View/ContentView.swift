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
            Text("\(coinsViewModel.coins): \(coinsViewModel.price)")
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
