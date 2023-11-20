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
                HStack(spacing: 12) {
                    Text("\(coin.marketCapRank)")
                        .foregroundColor(.gray)
                    AsyncImage(
                        url: coin.image,
                        content: { image in
                            image.resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 30, height: 30)
                        },
                        placeholder: {
                            Image(systemName: "photo")
                        }
                    )
                        
                    VStack(alignment: .leading, spacing: 2) {
                        Text(coin.name)
                            .fontWeight(.semibold)
                        Text(coin.symbol.uppercased())
                    }
                }
                .font(.footnote)
            }
        }.overlay {
            if let error = coinsViewModel.errorMessage {
                Text(error)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
