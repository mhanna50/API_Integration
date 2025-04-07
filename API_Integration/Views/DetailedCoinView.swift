//
//  DetailedCoinView.swift
//  API_Integration
//

import SwiftUI
import UIKit
import Kingfisher

struct DetailedCoinView: View {
    @State private var detailedCoin: DetailedCoin?
    @State private var isLoading = true
    @State var coinSymbol_String: String = ""

    var body: some View {
        NavigationView {
            ZStack {
                // Background gradient
                LinearGradient(colors: [.black, Color.blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    if isLoading {
                        // Show loading spinner
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .foregroundColor(.white)
                            .scaleEffect(1.3)
                            .padding()
                    } else if let detailedCoin = detailedCoin {
                        VStack(spacing: 20) {
                            // Coin input field
                            TextField("Enter a coin symbol...", text: $coinSymbol_String)
                                .multilineTextAlignment(.center)
                                .padding(6.0)
                                .background(
                                    RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                        .stroke(.white, lineWidth: 1.0)
                                )

                            // Search button
                            Button("Search") {
                                APIService().fetchCoinDetails(coinSymbol: coinSymbol_String) { result in
                                    switch result {
                                    case .success(let data):
                                        withAnimation(.easeIn(duration: 0.5)) {
                                            self.detailedCoin = data
                                            self.isLoading = false
                                        }
                                    case .failure(let error):
                                        print("Error: \(error)")
                                    }
                                }
                            }
                            .buttonStyle(.bordered)

                            // Coin image and name/symbol
                            HStack(spacing: 10) {
                                KFImage(URL(string: "https://coinlib.io/static/img/coins/small/\((detailedCoin.symbol).lowercased()).png"))
                                    .resizable()
                                    .frame(width: 25, height: 25)

                                Text("\(detailedCoin.name) (\(detailedCoin.symbol))")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)

                                // Arrow indicator for 24h change
                                if detailedCoin.delta_24h.first == "-" {
                                    Image("Red_Arrow")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                } else {
                                    Image("Green_Arrow")
                                        .resizable()
                                        .frame(width: 25, height: 25)
                                }
                            }

                            // Scrollable coin info cards
                            ScrollView {
                                CoinInfoCard(title: "Price", value: "$\(detailedCoin.price)")
                                CoinInfoCard(title: "Market Cap", value: detailedCoin.market_cap)
                                CoinInfoCard(title: "Volume (24H)", value: detailedCoin.total_volume_24h)
                                CoinInfoCard(title: "High (24H)", value: "$\(detailedCoin.high_24h)")
                                CoinInfoCard(title: "Low (24H)", value: "$\(detailedCoin.low_24h)")
                                CoinInfoCard(title: "Percent Change (1H)", value: "\(detailedCoin.delta_1h)%")
                                CoinInfoCard(title: "Percent Change (24H)", value: "\(detailedCoin.delta_24h)%")
                                CoinInfoCard(title: "Percent Change (7D)", value: "\(detailedCoin.delta_7d)%")
                                CoinInfoCard(title: "Percent Change (30D)", value: "\(detailedCoin.delta_30d)%")
                            }
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .onAppear {
                // Load BTC as default coin on appear
                APIService().fetchCoinDetails(coinSymbol: "BTC") { result in
                    switch result {
                    case .success(let data):
                        withAnimation(.easeIn(duration: 0.5)) {
                            self.detailedCoin = data
                            self.isLoading = false
                        }
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                }
            }
        }
    }
}

// MARK: - Coin Info Card View

struct CoinInfoCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            Text(title.uppercased())
                .font(.caption)
                .bold()
                .foregroundColor(.blue.opacity(0.9))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)

            Text(value)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            BlurView2(style: .systemUltraThinMaterialDark)
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

// MARK: - Blur Helper View

struct BlurView2: UIViewRepresentable {
    var style: UIBlurEffect.Style

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

// MARK: - Preview

struct DetailedCoinView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedCoinView()
            .preferredColorScheme(.dark)
    }
}

