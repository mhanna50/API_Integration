/* This file handles all API requests

 baseURL = "https://coinlib.io/api/v1"
 apikey = cb4a3c70a3b4ee80
 
 This file will fetch global statistics, a coin list, and relevant coin information

 It should also include a generalized fetchData function.
 
  Created by michael hanna on 4/1/25.
*/

import Foundation

class APIService {
    
    private let baseURL = "https://coinlib.io/api/v1"
    private let apiKey = "cb4a3c70a3b4ee80"
    
    func fetchGlobalMarketStats(completion: @escaping (Result<CryptoGlobalStats, Error>) -> Void) {
        let urlString = "\(baseURL)/global?key=\(apiKey)&pref=EUR"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "Invalid URL", code: 0, userInfo: nil)))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(NSError(domain: "No data received", code: 0, userInfo: nil)))
                return
            }
            
            // Debugging: Print the raw JSON response
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Raw API Response: \(json)")
            } catch {
                print("Failed to serialize JSON: \(error)")
            }

            // Now attempt to decode the response
            do {
                let decodedResponse = try JSONDecoder().decode(CryptoGlobalStats.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("Failed to decode response: \(error)")
                completion(.failure(error))
            }
        }
        
        task.resume()
    }
}



