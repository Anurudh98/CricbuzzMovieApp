//
//  MovieRepository.swift
//  MovieApp
//
//  Created by Merugu Anurudh on 15/09/26.
//

import Foundation

final class MovieRepository: MovieRepositoryProtocol {

    private let apiClient: APIClientProtocol

    init(apiClient: APIClientProtocol) {
        self.apiClient = apiClient
    }

    func popularMovies(page: Int) async throws -> PagedResponse<Movie> {
        try await apiClient.request(.popularMovies(page: page))
    }

    func searchMovies(query: String, page: Int) async throws -> PagedResponse<Movie> {
        try await apiClient.request(.searchMovies(query: query, page: page))
    }

    func movieDetail(id: Int) async throws -> MovieDetail {
        try await apiClient.request(.movieDetail(id: id))
    }

    func movieVideos(id: Int) async throws -> [Video] {
        let response: VideosResponse = try await apiClient.request(.movieVideos(id: id))
        return response.results
    }
}
