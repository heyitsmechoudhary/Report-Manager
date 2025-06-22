//
//  APIService.swift
//  Report Manager
//
//  Created by Rahul choudhary on 22/06/25.
//

import Foundation

enum APIError: Error {
    case invalidURL
    case invalidResponse
    case decodingError
    case networkError(Error)
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .decodingError:
            return "Error decoding data"
        case .networkError(let error):
            return error.localizedDescription
        }
    }
}

class APIService {
    static let shared = APIService()
    private let baseURL = "https://api.restful-api.dev/objects"
    
    func fetchObjects() async throws -> [APIObject] {
        guard let url = URL(string: baseURL) else {
            throw APIError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw APIError.invalidResponse
            }
            
            return try JSONDecoder().decode([APIObject].self, from: data)
        } catch {
            print("API Error: \(error)")
            throw APIError.networkError(error)
        }
    }
}
