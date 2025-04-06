/* This file handles all API requests

 
 
 This file will fetch global statistics, a coin list, and relevant coin information

 It should also include a generalized fetchData function.
 
  Created by michael hanna on 4/1/25.
*/

import Foundation

class APIService {

    private let baseURL = "https://coinlib.io/api/v1"
    private let apiKey = "cb4a3c70a3b4ee80"
    
    enum APIError: LocalizedError {
        case invalidURL
        case noDataReceived
        case decodingError
        case networkError(String)
        case serverError(String)
        case unknownError
        
        var errorDescription: String? {
            switch self {
            case .invalidURL:
                return "The URL is invalid."
            case .noDataReceived:
                return "No data was received from the server."
            case .decodingError:
                return "There was an issue decoding the response data."
            case .networkError(let message):
                return "Network error: \(message)"
            case .serverError(let message):
                return "Server error: \(message)"
            case .unknownError:
                return "An unknown error occurred."
            }
        }
    }

    func fetchGlobalMarketStats(completion: @escaping (Result<CryptoGlobalStats, Error>) -> Void) {
        let urlString = "\(baseURL)/global?key=\(apiKey)&pref=USD"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(APIError.networkError("No internet connection.")))
                } else {
                    completion(.failure(APIError.networkError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noDataReceived))
                return
            }
            
            // Debugging: Print the raw JSON response
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Raw API Response: \(json)")
            } catch {
                print("Failed to serialize JSON: \(error)")
                completion(.failure(APIError.decodingError))
                return
            }

            // Now attempt to decode the response
            do {
                let decodedResponse = try JSONDecoder().decode(CryptoGlobalStats.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("Failed to decode response: \(error)")
                completion(.failure(APIError.decodingError))
            }
        }
        
        task.resume()
    }
    
    func fetchCoinList(page: Int = 1, completion: @escaping (Result<CoinListResponse, Error>) -> Void) {
        let urlString = "\(baseURL)/coinlist?key=\(apiKey)&pref=USD&page=\(page)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(APIError.invalidURL))
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if (error as NSError).code == NSURLErrorNotConnectedToInternet {
                    completion(.failure(APIError.networkError("No internet connection.")))
                } else {
                    completion(.failure(APIError.networkError(error.localizedDescription)))
                }
                return
            }
            
            guard let data = data else {
                completion(.failure(APIError.noDataReceived))
                return
            }
            
            // Debugging: Print the raw JSON response
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                print("Raw API Response: \(json)")
            } catch {
                print("Failed to serialize JSON: \(error)")
                completion(.failure(APIError.decodingError))
                return
            }

            // Now attempt to decode the response
            do {
                let decodedResponse = try JSONDecoder().decode(CoinListResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decodedResponse))
                }
            } catch {
                print("Failed to decode response: \(error)")
                completion(.failure(APIError.decodingError))
            }
        }
        
        task.resume()
    }
}
