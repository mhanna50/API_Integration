/*
 ContentView Layout

 Navigation Bar:
 The view will have a clean and simple navigation bar at the top displaying the title "Cryptocurrency Prices".
 The title is prominently placed to ensure users know exactly what content they are viewing.
 
 List of Coins:
 Below the navigation bar, the main body of the view will consist of a list displaying individual cryptocurrency data (e.g., name, symbol, price, market cap).
 Each list item (or row) will represent a single coin and will dynamically update as new data is fetched.
 The list will have smooth scrolling to allow users to explore a wide range of cryptocurrencies.
 
 Coin Rows:
 Each coin row will display essential information like the coin's name, symbol, current price, and market cap.
 The name and symbol of the coin will be aligned on the left side in a vertical stack, making the text easy to read.
 The price and market cap will be placed on the right side of the row, aligned with the right edge of the screen for balance and visual clarity.
 To ensure the information stands out, the coin name will be displayed in a bold, large font, while the symbol will be in a smaller, subtle font.
 The price will be displayed prominently with a bold style and a currency symbol to highlight its importance.
 The market cap will be shown in a smaller, lighter font to provide additional context.
 
 Dynamic Imagery:
 As an optional feature, dynamic imagery could be used to visually represent the price changes or coin trends. For example, a small coin image or colored icon could change based on the market data, such as a green icon for price increases and a red icon for price decreases.
 
 Design Elements:
 Each coin row will have rounded corners and a subtle shadow for a modern, sleek look.
 The rows will have a white background to ensure readability, with enough padding around the text to make the information easy to scan.
 The rows will also be spaced out evenly, allowing for a visually pleasing and organized layout that doesn’t feel crowded.
 
 User Interaction:
 The user will be able to scroll through the list seamlessly, with each row providing just enough information at a glance without overwhelming the user.
 When a user taps on a coin's row, they could be navigated to a detail view (this could be a different screen or modal) that shows more information about that specific coin, such as historical price data, market volume, and detailed charts.
 
 Loading State:
 When the data is being fetched, a loading indicator (such as a spinning wheel or a "loading" text) will be displayed in the center of the screen to inform users that the content is being loaded.
 Once the data is successfully fetched, the list of coins will appear smoothly, with a possible fade-in animation to enhance the user experience.
  Created by michael hanna on 3/25/25.
*/

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text("Hello, world!")
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
