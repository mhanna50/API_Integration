/* Coin (Data Model):
Purpose: Represents a single cryptocurrency’s data.
Type: This model contains the actual data fetched from the API for a specific coin.

Example: A Coin struct would include properties such as:
symbol ((e.g., "BTC" for Bitcoin))
name (e.g., "Bitcoin")
price (the current price of the coin)
marketCap (the total market capitalization)
volume24h (the 24-hour trading volume)
delta24h (the 24-hour percent change in price)
Usage: This data model is used to store the raw data fetched from an API, which you can then manipulate and display in the app.
 
 Created by michael hanna on 4/1/25.
*/
import Foundation

// Global Stats Model
struct CryptoGlobalStats: Decodable {
    let coins: Int
    let markets: Int
    let total_market_cap: String
    let total_volume_24h: String
    
    enum CodingKeys: String, CodingKey {
        case coins, markets, total_market_cap, total_volume_24h
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.coins = try container.decode(Int.self, forKey: .coins)
        self.markets = try container.decode(Int.self, forKey: .markets)
        
        // Handle decoding of 'total_market_cap' and 'total_volume_24h' as a string or number
        self.total_market_cap = try CryptoGlobalStats.decodeAsString(container: container, forKey: .total_market_cap)
        self.total_volume_24h = try CryptoGlobalStats.decodeAsString(container: container, forKey: .total_volume_24h)
    }

    // Utility method for decoding mixed data types into a string
    private static func decodeAsString(container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> String {
        if let stringValue = try? container.decode(String.self, forKey: key) {
            return stringValue
        } else if let doubleValue = try? container.decode(Double.self, forKey: key) {
            return String(doubleValue)
        } else if let intValue = try? container.decode(Int.self, forKey: key) {
            return String(intValue)
        } else {
            return "" // Fallback to empty string if decoding fails
        }
    }
}

// Coin Model
struct Coin: Decodable, Identifiable {
    var id = UUID()
    let symbol: String
    let name: String
    let rank: Int
    let price: String
    let market_cap: String
    let volume_24h: String
    let delta_24h: String
    
    enum CodingKeys: String, CodingKey {
        case symbol, name, rank, price, market_cap, volume_24h, delta_24h
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.symbol = try container.decode(String.self, forKey: .symbol)
        self.name = try container.decode(String.self, forKey: .name)
        self.rank = try container.decode(Int.self, forKey: .rank)
        
        // Decode price, market_cap, and volume_24h as strings (handling potential number types)
        self.price = try Coin.decodeAsString(container: container, forKey: .price)
        self.market_cap = try Coin.decodeAsString(container: container, forKey: .market_cap)
        self.volume_24h = try Coin.decodeAsString(container: container, forKey: .volume_24h)
        self.delta_24h = try Coin.decodeAsString(container: container, forKey: .delta_24h)
    }

    // Utility method for decoding mixed data types into a string
    private static func decodeAsString(container: KeyedDecodingContainer<CodingKeys>, forKey key: CodingKeys) throws -> String {
        if let stringValue = try? container.decode(String.self, forKey: key) {
            return stringValue
        } else if let doubleValue = try? container.decode(Double.self, forKey: key) {
            return String(doubleValue)
        } else if let intValue = try? container.decode(Int.self, forKey: key) {
            return String(intValue)
        } else {
            return "" // Fallback to empty string if decoding fails
        }
    }
}

// Coin List Response Model
struct CoinListResponse: Decodable {
    let coins: [Coin]
}
