//
//  Movie.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

struct Movie: Codable, Identifiable, Hashable {

    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let genreIds: [Int]?

    var posterURL: URL? {
        APIConfiguration.imageURL(path: posterPath, size: .poster)
    }

    var backdropURL: URL? {
        APIConfiguration.imageURL(path: backdropPath, size: .backdrop)
    }

    var formattedRating: String {
        String(format: "%.1f", voteAverage)
    }

    var releaseYear: String? {
        guard let releaseDate, releaseDate.count >= 4 else { return nil }
        return String(releaseDate.prefix(4))
    }
}
