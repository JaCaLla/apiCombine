//
//  HTTPError.swift
//  apiCombine
//
//  Created by Javier Calatrava on 21/2/21.
//

enum HTTPError: Error {

    case networkError(Error)
    case nonHTTPResponse
    case requestFailed(Int)
    case serverError(Int)
    case modelError(Error)
   // case decodingError(DecodingError)

    var description: String {
        switch self {
        case .nonHTTPResponse: return "Non HTTP URL Response Received"
        case .requestFailed(let status): return "Received HTTP \(status)"
        case .networkError(let error): return "Networking error: \(error)"
        case .serverError(let code): return "Server error:\(code)"
        case .modelError(let decodingError): return "Decoding error \(decodingError)"
        }
    }
}

extension HTTPError: Equatable {
    static func == (lhs: HTTPError, rhs: HTTPError) -> Bool {
        lhs.description == rhs.description
    }
}
