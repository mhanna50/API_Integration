import SwiftUI
import Kingfisher

// Main View that displays the list of cryptocurrencies
struct CoinListView: View {
    // State variables to manage coin data, loading status, search input, and filtered results
    @State private var coins: [Coin] = []
    @State private var isLoading = true
    @State private var searchQuery = ""
    @State private var filteredCoins: [Coin] = []

    var body: some View {
        NavigationView {
            ZStack {
                // Gradient background from black to translucent blue
                LinearGradient(colors: [.black, Color.blue.opacity(0.3)], startPoint: .top, endPoint: .bottom)
                    .ignoresSafeArea()

                VStack {
                    // Spacer for design balance (can be removed or customized)
                    Text("")
                        .foregroundColor(.black)
                        .font(.headline)
                        .padding()
                    
                    // Search bar component for filtering coins
                    SearchBar(text: $searchQuery)
                        .padding(.horizontal)
                        .padding(.top, -48)

                    if isLoading {
                        // Show loading indicator while fetching data
                        Spacer()
                        ProgressView("Loading coins...")
                            .padding()
                        Spacer()
                    } else {
                        // List of filtered coins
                        List(filteredCoins) { coin in
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    // Coin image using Kingfisher
                                    KFImage(URL(string: "https://coinlib.io/static/img/coins/small/\((coin.symbol).lowercased()).png"))
                                        .resizable()
                                        .frame(width: 25, height: 25)

                                    // Coin name with stylized background
                                    Text(coin.name)
                                        .font(.headline)
                                        .padding(6)
                                        .background(Color.black.opacity(0.7))
                                        .foregroundColor(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 6))

                                    Spacer()

                                    // Up/down arrow image based on 24h delta
                                    if coin.delta_24h.first == "-" {
                                        Image("Red_Arrow")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    } else {
                                        Image("Green_Arrow")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                    }

                                    // Coin symbol
                                    Text(coin.symbol)
                                        .font(.subheadline)
                                        .foregroundColor(.gray)
                                }

                                // Rank and Price row
                                HStack {
                                    Text("Rank: \(coin.rank)")
                                    Spacer()
                                    Text("Price: $\(coin.price)")
                                }
                                .font(.subheadline)
                                .padding(6)
                                .background(Color.black.opacity(0.6))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))

                                // Market Cap and Volume row
                                HStack {
                                    Text("Market Cap: \(coin.market_cap)")
                                    Spacer()
                                    Text("Volume (24h): \(coin.volume_24h)")
                                }
                                .font(.subheadline)
                                .padding(6)
                                .background(Color.black.opacity(0.6))
                                .foregroundColor(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 6))
                            }
                            .padding()
                            .background(
                                // Background blur and styling
                                BlurView(style: .systemUltraThinMaterialDark)
                                    .background(Color.white.opacity(0.05))
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.blue.opacity(0.3), lineWidth: 1)
                                    )
                            )
                            .shadow(color: .blue.opacity(0.2), radius: 6, x: 0, y: 4)
                            .listRowBackground(Color.clear)
                            .padding(.vertical, 5)
                        }
                        .listStyle(PlainListStyle())
                        .onAppear {
                            // Hide list separators
                            UITableView.appearance().separatorStyle = .none
                        }
                    }
                }
            }
            // Remove navigation title text and ensure foreground color is white
            .navigationBarTitle("", displayMode: .inline)
            .foregroundColor(.white)
        }
        .onAppear {
            // Fetch coin data when the view appears
            APIService().fetchCoinList(page: 1) { result in
                switch result {
                case .success(let data):
                    self.coins = data.coins
                    self.filteredCoins = data.coins
                    self.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        .onChange(of: searchQuery) {
            // Filter coins as search query changes
            if searchQuery.isEmpty {
                filteredCoins = coins
            } else {
                filteredCoins = coins.filter { coin in
                    coin.name.lowercased().contains(searchQuery.lowercased()) ||
                    coin.symbol.lowercased().contains(searchQuery.lowercased())
                }
            }
        }
    }
}

// MARK: - Search Bar Component
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.white)
            TextField("Search for a coin...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.gray.opacity(0.15))
                .cornerRadius(10)
                .overlay(
                    HStack {
                        Spacer()
                        if !text.isEmpty {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(5)
                            }
                        }
                    }
                )
        }
        .padding(.horizontal)
        .padding(.top)
    }
}

// MARK: - Blur View Helper (for compatibility with background visuals)
// You can define a UIKit BlurView here if needed

// MARK: - Preview
struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView()
            .preferredColorScheme(.dark)
    }
}

