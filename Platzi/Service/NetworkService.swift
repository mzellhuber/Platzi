//
//  NetworkService.swift
//  Platzi
//
//  Created by Melissa Zellhuber on 04/10/23.
//

import Foundation
import Combine

enum NetworkError: Error {
    case invalidURL
    case missingJWT
    case missingData
    case decodingError(Error)
    case networkError(Error)
    case unknownError(Error)
}

enum MovieType: String {
    case popular
    case topRated = "top_rated"
    case upcoming
}

class NetworkService {
    
    static let shared = NetworkService()
    
    private let baseURL = URL(string: "https://api.themoviedb.org/3/movie/")!
    
    private init() {}
    
    private var jwtToken: String? {
        if let path = Bundle.main.path(forResource: "Config", ofType: "plist"),
           let dict = NSDictionary(contentsOfFile: path) as? [String: Any] {
            return dict["JWT_TOKEN"] as? String
        }
        return nil
    }
    
    func fetchMovies(ofType type: MovieType, page: Int = 1) -> AnyPublisher<APIResult<Movie>, NetworkError> {
        guard let url = URL(string: "\(baseURL)\(type.rawValue)?page=\(page)") else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        return Future { promise in
            Task {
                do {
                    let movies: APIResult<Movie> = try await self.request(url: url)
                    promise(.success(movies))
                } catch {
                    if let networkError = error as? NetworkError {
                        promise(.failure(networkError))
                    } else {
                        promise(.failure(.unknownError(error)))
                    }
                }
            }
        }.eraseToAnyPublisher()
    }
    
    private func request<T: Decodable>(url: URL) async throws -> T {
        var request = URLRequest(url: url, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 10.0)
        request.httpMethod = "GET"
        
        guard let jwt = jwtToken else {
            throw NetworkError.missingJWT
        }
        
        request.allHTTPHeaderFields = [
            "accept": "application/json",
            "Authorization": "Bearer \(jwt)"
        ]
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse, 200...299 ~= httpResponse.statusCode else {
                throw NetworkError.networkError(URLError(.badServerResponse))
            }
            
            let decodedData = try JSONDecoder().decode(T.self, from: data)
            return decodedData
            
        } catch {
            if let urlError = error as? URLError {
                throw NetworkError.networkError(urlError)
            } else if let decodingError = error as? DecodingError {
                throw NetworkError.decodingError(decodingError)
            } else {
                throw NetworkError.unknownError(error)
            }
        }
    }
}
