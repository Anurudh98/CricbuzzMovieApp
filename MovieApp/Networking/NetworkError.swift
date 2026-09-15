//
//  NetworkError.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

enum NetworkError: LocalizedError, Equatable {

    case invalidUrl
    case invalidResponse
    case serverError(Int)
    case decodingFailed
    case noInternet
    case unknownError(String)

    var errorDescription: String? {
        switch self {
        case .invalidUrl:
            return "The request could not be created. Please try again."
        case .invalidResponse:
            return "We received an unexpected response from the server."
        case .decodingFailed:
            return "We couldn't read the data from the server."
        case .serverError(let code):
            return "The server returned an error (code \(code))."
        case .noInternet:
            return "No internet connection. Please check your network and try again."
        case .unknownError(let message):
            return message
        }
    }
}
