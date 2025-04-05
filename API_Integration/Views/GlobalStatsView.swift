//
//  GlobalStatsView.swift
//  API_Integration
//
//  Created by michael hanna on 4/5/25.
//

import SwiftUI

struct GlobalStatsView: View {
    @State private var stats: CryptoGlobalStats?
    @State private var isLoading = true
    
    var body: some View {
        VStack {
            if isLoading {
                ProgressView("Loading...")
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .padding()
            } else if let stats = stats {
                VStack(spacing: 15) {
                    Text("Global Cryptocurrency Stats")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                    
                    StatsCard(title: "Total Coins", value: "\(stats.coins)")
                    StatsCard(title: "Total Markets", value: "\(stats.markets)")
                    StatsCard(title: "Market Cap", value: stats.total_market_cap)
                    StatsCard(title: "Volume (24h)", value: stats.total_volume_24h)
                }
                .padding()
            }
        }
        .onAppear {
            APIService().fetchGlobalMarketStats { result in
                switch result {
                case .success(let data):
                    self.stats = data
                    self.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        .background(Color(.systemBackground)) // Background color for the whole view
        .cornerRadius(20)
        .padding()
    }
}

struct StatsCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.headline)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.primary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}

struct GlobalStatsView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalStatsView()
            .preferredColorScheme(.dark) // For dark mode preview
    }
}
