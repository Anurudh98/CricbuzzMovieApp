//
//  MovieDetail.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

struct MovieDetail: Codable, Identifiable, Hashable {

    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
    let backdropPath: String?
    let releaseDate: String?
    let voteAverage: Double
    let runtime: Int?
    let genres: [Genre]
    let tagline: String?
    let credits: Credits?

    struct Credits: Codable, Hashable {
        let cast: [CastMember]
    }

    var cast: [CastMember] {
        credits?.cast ?? []
    }

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

    var formattedRuntime: String? {
        guard let runtime, runtime > 0 else { return nil }
        let hours = runtime / 60
        let minutes = runtime % 60
        if hours > 0 {
            return "\(hours)h \(minutes)m"
        }
        return "\(minutes)m"
    }

    var genresText: String {
        genres.map(\.name).joined(separator: ", ")
    }

    var asMovie: Movie {
        Movie(
            id: id,
            title: title,
            overview: overview,
            posterPath: posterPath,
            backdropPath: backdropPath,
            releaseDate: releaseDate,
            voteAverage: voteAverage,
            genreIds: genres.map(\.id)
        )
    }
}
