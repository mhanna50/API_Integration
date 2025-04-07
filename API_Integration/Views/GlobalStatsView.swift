//
//  GlobalStatsView.swift
//  API_Integration
//
//  Created by michael hanna on 4/5/25.
//

import SwiftUI
import UIKit

// Main view for displaying global cryptocurrency statistics
struct GlobalStatsView: View {
    // State variables for storing fetched data and loading state
    @State private var stats: CryptoGlobalStats? // Holds the data once fetched
    @State private var isLoading = true          // Controls the loading spinner visibility

    var body: some View {
        ZStack {
            // Background gradient from black to transparent blue
            LinearGradient(colors: [.black, Color.blue.opacity(0.3)],
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea() // Extend background behind safe areas

            VStack {
                // Show loading spinner while fetching data
                if isLoading {
                    ProgressView("Loading...")
                        .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                        .foregroundColor(.white)
                        .scaleEffect(1.3)
                        .padding()
                }
                // Once data is loaded, display the statistics
                else if let stats = stats {
                    VStack(spacing: 20) {
                        // Header with icon and title
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

                        // Individual statistic cards
                        StatsCard(title: "Total Coins", value: "\(stats.coins)")
                        StatsCard(title: "Total Markets", value: "\(stats.markets)")
                        StatsCard(title: "Market Cap", value: stats.total_market_cap)
                        StatsCard(title: "Volume (24h)", value: stats.total_volume_24h)
                    }
                    .padding()
                }
            }
            .padding()
        }
        // Fetch global market stats when view appears
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

// View that displays a single statistic in a styled card
struct StatsCard: View {
    let title: String // Title for the stat (e.g. "Total Coins")
    let value: String // Corresponding value

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Title label with background
            Text(title.uppercased())
                .font(.caption)
                .bold()
                .padding(6)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.blue.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 6))

            // Value label with styled background
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
            // Background blur with a translucent overlay and border
            BlurView(style: .systemUltraThinMaterialDark)
                .background(Color.white.opacity(0.05))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                )
        )
        .shadow(color: .blue.opacity(0.25), radius: 10, x: 0, y: 5) // Blue glowing shadow
    }
}

// UIKit wrapper for blur effect in SwiftUI
struct BlurView: UIViewRepresentable {
    var style: UIBlurEffect.Style

    // Create the UIView with the desired blur effect
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    // Update view when SwiftUI state changes (unused here)
    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// Preview for SwiftUI canvas
struct GlobalStatsView_Previews: PreviewProvider {
    static var previews: some View {
        GlobalStatsView()
            .preferredColorScheme(.dark) // Dark mode preview
    }
}

