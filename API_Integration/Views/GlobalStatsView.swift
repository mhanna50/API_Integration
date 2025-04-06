//
//  GlobalStatsView.swift
//  API_Integration
//
//  Created by michael hanna on 4/5/25.
//

import SwiftUI
import UIKit

struct GlobalStatsView: View {
    @State private var stats: CryptoGlobalStats?
    @State private var isLoading = true

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, Color.blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack {
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .foregroundColor(.white)
                        .scaleEffect(1.3)
                        .padding()
                } else if let stats = stats {
                    VStack(spacing: 20) {
                        HStack(spacing: 10) {
                            Image(systemName: "chart.bar.fill")
                                .font(.title2)
                                .foregroundColor(.blue)
                            Text("Global Statistics")
                                .font(.title)
                                .fontWeight(.heavy)
                                .foregroundColor(.white)
                        }
                        .padding(.bottom, 28)

                        StatsCard(title: "Total Coins", value: "\(stats.coins)")
                        StatsCard(title: "Total Markets", value: "\(stats.markets)")
                        StatsCard(title: "Market Cap", value: stats.total_market_cap)
                        StatsCard(title: "Volume (24h)", value: stats.total_volume_24h)
                    }
                    .padding()
                    // Removed transition here
                }
            }
            .padding()
        }
        .onAppear {
            APIService().fetchGlobalMarketStats { result in
                switch result {
                case .success(let data):
                    withAnimation(.easeIn(duration: 0.5)) {
                        self.stats = data
                        self.isLoading = false
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
}

struct StatsCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .font(.caption)
                .bold()
                .padding(6)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.blue.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 6))

            Text(value)
                .font(.title)
                .fontWeight(.semibold)
                .padding(6)
                .background(Color.black.opacity(0.75))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            BlurView(style: .systemUltraThinMaterialDark)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .blue.opacity(0.25), radius: 10, x: 0, y: 5)
    }
}


// Helper UIViewRepresentable for blur effect
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct GlobalStatsView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalStatsView()
            .preferredColorScheme(.dark)
    }
}
