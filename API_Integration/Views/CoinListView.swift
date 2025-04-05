import SwiftUI

struct CoinListView: View {
    @State private var coins: [Coin] = []
    @State private var isLoading = true
    @State private var searchQuery = "" // The search query entered by the user
    @State private var filteredCoins: [Coin] = [] // The filtered coins based on the search query
    
    var body: some View {
        VStack {
            // Search Bar
            SearchBar(text: $searchQuery)
                .padding(.horizontal)
                .padding(.top)
            
            // Show loading message while the data is being fetched
            if isLoading {
                Text("Loading coins...")
                    .foregroundColor(.gray)
                    .padding(.top, 20)
            } else {
                // List of coins
                List(filteredCoins) { coin in
                    VStack(alignment: .leading) {
                        HStack {
                            Text(coin.name)
                                .font(.headline)
                                .frame(maxWidth: .infinity, alignment: .leading)
                            Text(coin.symbol)
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("Rank: \(coin.rank)")
                            Spacer()
                            Text("Price: \(coin.price)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        HStack {
                            Text("Market Cap: \(coin.market_cap)")
                            Spacer()
                            Text("Volume (24h): \(coin.volume_24h)")
                        }
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(8)
                    .shadow(radius: 5)
                    .padding(.bottom, 5)
                }
                .listStyle(PlainListStyle()) // Use plain style to make it more customizable
                .padding(.top, 10)
                .onAppear {
                    UITableView.appearance().separatorStyle = .none // Hide default separators for a cleaner look
                }
            }
        }
        .onAppear {
            // Fetch the list of coins from the API
            APIService().fetchCoinList(page: 1) { result in
                switch result {
                case .success(let data):
                    self.coins = data.coins
                    self.filteredCoins = data.coins // Initialize filteredCoins with all coins
                    self.isLoading = false
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
        .onChange(of: searchQuery) { newValue in
            // Filter coins based on the search query
            if newValue.isEmpty {
                filteredCoins = coins
            } else {
                filteredCoins = coins.filter { coin in
                    coin.name.lowercased().contains(newValue.lowercased()) || coin.symbol.lowercased().contains(newValue.lowercased())
                }
            }
        }
    }
}

// Custom Search Bar View
struct SearchBar: View {
    @Binding var text: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Search for a coin...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color.gray.opacity(0.1))
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

struct CoinListView_Previews: PreviewProvider {
    static var previews: some View {
        CoinListView()
            .preferredColorScheme(.dark)
    }
}

