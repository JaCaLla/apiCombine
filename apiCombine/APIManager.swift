//
//  APIManager.swift
//  apiCombine
//
//  Created by Javier Calatrava on 20/2/21.
//

import Foundation
import UIKit
import Combine

class APIManager {

    private static let baseUrl = URL(string: "https://developer.nps.gov/api/v1/")!
    // To get a valid api key subscribe to https://www.nps.gov/subjects/developer/get-started.htm
    private static let apiKey = ""
    private let session = URLSession.shared
    private let jsonDecoder = JSONDecoder()

    static var injectedUrl: URL?
    
    enum URLPark {
        case park
        
        func getURL() -> URL {
            switch self {
            case .park: return injectedUrl ?? baseUrl
                .appending(path: "parks")
                .appending(queryParams: [
                "api_key": apiKey])
            default:
                return baseUrl
            }
        }
    }
    
    func fetchParksOriginal(completion: @escaping (Result<ParksResponseAPI, Error>) -> Void) {
        let url = APIManager.injectedUrl ?? APIManager.baseUrl
            .appending(path: "parks")
            .appending(queryParams: [
                "api_key": APIManager.apiKey
        ])
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
              completion(.failure(error))
            }
            guard let data = data else {
                assertionFailure("No error and no data. This should never happen.")
              return
            }
            do {
              let decodedResponse = try JSONDecoder().decode(ParksResponseAPI.self, from: data)
              completion(.success(decodedResponse))
            } catch {
              completion(.failure(error))
            }
          }.resume()
        }
    
    
    func fetchParks() -> AnyPublisher<ParksResponseAPI, HTTPError> {
        let url = APIManager.injectedUrl ?? APIManager.baseUrl
            .appending(path: "parks")
            .appending(queryParams: [
                "api_key": APIManager.apiKey
        ])
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { (data: Data, response: URLResponse) -> (Data, HTTPURLResponse) in
                guard let http = response as? HTTPURLResponse else {
                    throw HTTPError.nonHTTPResponse
                }
                return (data, http)
            }
            .mapError { error -> HTTPError in
                guard let httpError = error as? HTTPError else {
                    return HTTPError.networkError(error)
                }
                return httpError
            }
            .tryMap { (data: Data, response: HTTPURLResponse) -> Data in
            switch response.statusCode {
            case 200...299: return data
            case 400...499: throw HTTPError.requestFailed(response.statusCode)
            case 500...599: throw HTTPError.serverError(response.statusCode)
            default:
                fatalError("Unhandled HTTP Response status code: \(response.statusCode)")
            }
        }
            .decode(type: ParksResponseAPI.self, decoder: JSONDecoder())
            .mapError { error in
                guard let httpError = error as? HTTPError else {
                    return HTTPError.modelError(error)
                }
                return httpError
            }
            .eraseToAnyPublisher()
    }
}

public extension URL {
    func appending(path: String) -> URL {
        appendingPathComponent(path, isDirectory: false)
    }

    func appending(queryParams: [String: String]) -> URL {
        var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
        components.queryItems = queryParams.map { key, value in
            URLQueryItem(name: key, value: value)
        }
        return components.url!
    }
}
