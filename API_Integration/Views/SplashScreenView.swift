import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.3
    
    var body: some View {
        if isActive {
            ContentView() // Switches to the main app
        } else {
            VStack {
                Image("Crypto_Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                    .shadow(color: .blue, radius: 10)
                
                Text("Crypto Tracker")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .shadow(color: .cyan, radius: 5)
                    .padding(.top, 10)
                
                Text("Analyzing the market...")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.top, 10)
                
                ProgressView() // Loading animation
                    .progressViewStyle(CircularProgressViewStyle(tint: .blue))
                    .scaleEffect(1.5)
                    .padding(.top, 20)

            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.black.edgesIgnoringSafeArea(.all)) // Dark theme
            .opacity(opacity)
            .onAppear {
                // Fade-in animation
                withAnimation(.easeInOut(duration: 2.5)) {
                    opacity = 1.0
                }
                
                // Delay before switching to ContentView
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.7) {
                    withAnimation {
                        isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

