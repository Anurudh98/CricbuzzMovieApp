//
//  APIConfiguration.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

enum APIConfiguration {

    static let apiKey = "cce16bc57b90dd5c3174a283114a5d11"

    static let baseURL = "https://api.themoviedb.org/3"

    static let imageBaseURL = "https://image.tmdb.org/t/p"

    enum ImageSize: String {
        case poster = "w500"
        case backdrop = "w780"
        case profile = "w185"
        case original = "original"
    }

    static func imageURL(path: String?, size: ImageSize) -> URL? {
        guard let path, !path.isEmpty else { return nil }
        return URL(string: "\(imageBaseURL)/\(size.rawValue)\(path)")
    }
}
