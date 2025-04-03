/* Coin (Data Model):
Purpose: Represents a single cryptocurrency’s data.
Type: This model contains the actual data fetched from the API for a specific coin.

Example: A Coin struct would include properties such as:
symbol ((e.g., "BTC" for Bitcoin))
name (e.g., "Bitcoin")
price (the current price of the coin)
marketCap (the total market capitalization)
volume24h (the 24-hour trading volume)
Usage: This data model is used to store the raw data fetched from an API, which you can then manipulate and display in the app.
 
 Created by michael hanna on 4/1/25.
*/
import Foundation

// Define a struct for the Coin
struct Coin: Identifiable, Decodable {
    var id = UUID() // Unique ID for each coin object in the list
    var symbol: String
    var name: String
    var rank: Int
    var price: String
    var market_cap: String
    var volume_24h: String
    var delta_24h: String
}

// Define the response structure to match the JSON returned by the API
struct CryptoResponse: Decodable {
    var coins: [Coin]
    var last_updated_timestamp: Int
    var remaining: Int
}
struct CryptoGlobalStats: Decodable {
    var coins: Int
    var markets: Int
    var total_market_cap: Double
    var total_volume_24h: Double
    var last_updated_timestamp: Double
    var remaining: Int
}
