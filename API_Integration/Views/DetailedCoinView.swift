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
                LinearGradient(colors: [.black, Color.blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    if isLoading {
                        ProgressView("Loading...")
                            .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                            .foregroundColor(.white)
                            .scaleEffect(1.3)
                            .padding()
                    } else if let detailedCoin = detailedCoin {
                        VStack(spacing: 20) {
                            TextField("Enter a coin symbol...", text: $coinSymbol_String)
                                .multilineTextAlignment(.center)
                                .padding(6.0)
                                
                                .background(
                                    RoundedRectangle(cornerRadius: 4.0, style: .continuous)
                                        .stroke(.white, lineWidth: 1.0)
                                )
                            
                            // Button to fetch new data based on entered coin symbol
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
                            
                            HStack(spacing: 10) {
                                KFImage(URL(string: "https://coinlib.io/static/img/coins/small/\((detailedCoin.symbol).lowercased()).png"))
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                Text("\(detailedCoin.name) (\(detailedCoin.symbol))")
                                    .font(.title)
                                    .fontWeight(.heavy)
                                    .foregroundColor(.white)
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
                            
                            ScrollView {
                                CoinInfoCard(title: "Price", value: "$\(detailedCoin.price)")
                                CoinInfoCard(title: "Market Cap", value: detailedCoin.market_cap)
                                CoinInfoCard(title: "Volume (last 24 hours)", value: detailedCoin.total_volume_24h)
                                CoinInfoCard(title: "High (last 24 hours)", value: "$\(detailedCoin.high_24h)")
                                CoinInfoCard(title: "Low (last 24 hours)", value: "$\(detailedCoin.low_24h)")
                                CoinInfoCard(title: "Percent Change (last hour)", value: "\(detailedCoin.delta_1h)%")
                                CoinInfoCard(title: "Percent Change (last day)", value: "\(detailedCoin.delta_24h)%")
                                CoinInfoCard(title: "Percent Change (last week)", value: "\(detailedCoin.delta_7d)%")
                                CoinInfoCard(title: "Percent Change (last month)", value: "\(detailedCoin.delta_30d)%")
                            }
                            
                        }
                        .padding()
                        // Removed transition here
                    }
                }
                .padding()
            }
            .onAppear {
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

struct CoinInfoCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(title.uppercased())
                .multilineTextAlignment(.center)
                .font(.caption)
                .bold()
                .padding(6)
                .background(Color.black.opacity(0.6))
                .foregroundColor(.blue.opacity(0.9))
                .clipShape(RoundedRectangle(cornerRadius: 6))

            Text(value)
                .fontWeight(.semibold)
                .padding(6)
                .background(Color.black.opacity(0.75))
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
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


// Helper UIViewRepresentable for blur effect
struct BlurView2: UIViewRepresentable {
    var style: UIBlurEffect.Style
    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {}
}

struct DetailedCoinView_Previews: PreviewProvider {
    static var previews: some View {
        DetailedCoinView()
            .preferredColorScheme(.dark)
    }
}
